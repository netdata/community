package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"
	"strconv"  // Added import here
	"golang.org/x/sys/windows/svc"
	"golang.org/x/sys/windows/svc/debug"
	"golang.org/x/sys/windows/svc/eventlog"
	"time"
)

type myService struct{}

var elog debug.Log

func gatherSystemInfo(outputFile string) {
	file, err := os.Create(outputFile)
	if err != nil {
		elog.Error(1, fmt.Sprintf("Error creating file: %s\n", err))
		return
	}
	defer file.Close()

	commands := []struct {
		Label   string
		Command string
		Args    []string
		IsDiskSize bool
	}{
		{"Hostname", "hostname", nil, false},
		{"OS Version", "wmic", []string{"os", "get", "Caption", "/format:list"}, false},
		{"Architecture", "wmic", []string{"os", "get", "OSArchitecture", "/format:list"}, false},
		{"Kernel", "wmic", []string{"os", "get", "Version", "/format:list"}, false},
		{"CPU", "wmic", []string{"cpu", "get", "Name,NumberOfCores,NumberOfLogicalProcessors", "/format:list"}, false},
		{"CPUfreq", "wmic", []string{"cpu", "get", "MaxClockSpeed", "/format:list"}, false},
		{"Memory", "wmic", []string{"ComputerSystem", "get", "TotalPhysicalMemory", "/format:list"}, false},
		{"Hard Disk Size", "wmic", []string{"diskdrive", "get", "size", "/format:list"}, true},
		{"UID", "powershell", []string{"-Command", "[guid]::NewGuid().ToString()"}, false},
	}

    var totalDiskSize int64

	for _, cmdInfo := range commands {
		cmd := exec.Command(cmdInfo.Command, cmdInfo.Args...)
		output, err := cmd.CombinedOutput()
		if err != nil {
			fmt.Fprintf(file, "%s: Error executing command: %s\n", cmdInfo.Label, err)
			continue
		}
		cleanOutput := strings.TrimSpace(string(output))
        if cmdInfo.IsDiskSize {
             // Parse and sum disk sizes
             lines := strings.Split(cleanOutput, "\n\n")
             for _, line := range lines {
                 line = strings.TrimSpace(line)
                 if strings.HasPrefix(line, "Size=") {
                     sizeStr := strings.TrimPrefix(line, "Size=")
                     size, err := strconv.ParseInt(sizeStr, 10, 64)
                     if err == nil {
                         totalDiskSize += size
                     }
                 }
             }
         } else {
             fmt.Fprintf(file, "%s: %s\n\n", cmdInfo.Label, cleanOutput)
         }
	}
	
	// Write the total disk size to the file
    if totalDiskSize > 0 {
        fmt.Fprintf(file, "Total Hard Disk Size: %d\n\n", totalDiskSize)
    }
}

func serveFileContent(filePath string) {
    if elog == nil {
        log.Fatal("Error: Log system not initialized")
        return
    }
    http.HandleFunc("/info", func(w http.ResponseWriter, r *http.Request) {
        content, err := ioutil.ReadFile(filePath)
        if err != nil {
            http.Error(w, "File not found or read error", http.StatusNotFound)
            return
        }
        w.Write(content)
    })

    elog.Info(1, "Serving system information on http://localhost:19998/info")
    log.Fatal(http.ListenAndServe(":19998", nil))
}

func (m *myService) Execute(args []string, r <-chan svc.ChangeRequest, status chan<- svc.Status) (svcSpecificEC bool, exitCode uint32) {
	const cmdsAccepted = svc.AcceptStop | svc.AcceptShutdown
	status <- svc.Status{State: svc.StartPending}
	outputFile := "system_info.txt"
	go gatherSystemInfo(outputFile)
	go serveFileContent(outputFile)
	status <- svc.Status{State: svc.Running, Accepts: cmdsAccepted}

	for {
		select {
		case c := <-r:
			switch c.Cmd {
			case svc.Interrogate:
				status <- c.CurrentStatus
			case svc.Stop, svc.Shutdown:
				status <- svc.Status{State: svc.StopPending}
				return
			default:
				elog.Error(1, fmt.Sprintf("unexpected control request #%d", c.Cmd))
			}
		}
		// Sleep for a while to prevent the service from stopping immediately
		time.Sleep(time.Second * 1)
	}
}

func runService(name string, isDebug bool) {
	var err error
	if isDebug {
		elog = debug.New(name)
	} else {
		elog, err = eventlog.Open(name)
		if err != nil {
			return
		}
	}
	defer elog.Close()

	elog.Info(1, fmt.Sprintf("starting %s service", name))
	run := svc.Run
	if isDebug {
		run = debug.Run
	}
	err = run(name, &myService{})
	if err != nil {
		elog.Error(1, fmt.Sprintf("%s service failed: %v", name, err))
		return
	}
	elog.Info(1, fmt.Sprintf("%s service stopped", name))
}

func main() {
	isInteractive, err := svc.IsAnInteractiveSession()
	if err != nil {
		log.Fatalf("failed to determine if we are running in an interactive session: %v", err)
	}
	if !isInteractive {
		runService("MyGoService", false)
		return
	}
	elog = debug.New("MyGoService") // Adjust the name as appropriate

	// If running in debug mode or directly, execute the main logic immediately.
	outputFile := "system_info.txt"
	gatherSystemInfo(outputFile)
	serveFileContent(outputFile)
}
