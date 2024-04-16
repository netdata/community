package main

import (
    "encoding/json"
    "fmt"
    "log"
    "net/http"
    "os"
    "os/exec"
    "bufio"
    "strings"

    "golang.org/x/sys/windows/svc"
    "golang.org/x/sys/windows/svc/eventlog"
	"io"
)

var elog *eventlog.Log

type myService struct{}

func init() {
    // Early logging setup, ensuring output before service fully initializes
    file, err := os.OpenFile("C:\\service_log.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
    if err == nil {
        log.SetOutput(file)
    } else {
        log.SetOutput(os.Stderr)
    }
    log.Println("Service is initializing...")
}

func (m *myService) Execute(args []string, r <-chan svc.ChangeRequest, s chan<- svc.Status) (bool, uint32) {
    const cmdsAccepted = svc.AcceptStop | svc.AcceptShutdown
    s <- svc.Status{State: svc.StartPending}
    log.Println("Service starting...")

    http.HandleFunc("/metrics", metricsHandler)
    server := &http.Server{Addr: ":19997"}

    go func() {
        if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
            log.Printf("HTTP server failed: %v\n", err)
            elog.Error(1, fmt.Sprintf("HTTP server failed: %v", err))
        }
    }()
    log.Println("HTTP server started on :19997")

    s <- svc.Status{State: svc.Running, Accepts: cmdsAccepted}

    for {
        select {
        case c := <-r:
            switch c.Cmd {
            case svc.Interrogate:
                s <- c.CurrentStatus
            case svc.Stop, svc.Shutdown:
                log.Println("Service stopping...")
                server.Close()
                s <- svc.Status{State: svc.StopPending}
                return false, 0
            default:
                elog.Error(1, fmt.Sprintf("Unexpected control request #%d", c))
            }
        }
    }
}

type MetricInfo struct {
    Help    string
    Type    string
    Heading string
}

var metricConfig = map[string]MetricInfo{
    "temperature":                {"Current temperature of the drive", "gauge", "disk_temperature"},
    "warning_temp_time":          {"Time under warning temperature", "counter", "disk_temperature"},
    "available_spare":            {"Percentage of remaining spare capacity available", "gauge", "disk_usage"},
    "available_spare_threshold":  {"Threshold of available spare capacity", "gauge", "disk_usage"},
    "available_reservd_space":    {"Percentage of reserved space available", "gauge", "disk_usage"},
    "data_units_read":            {"Total data units read", "counter", "disk_usage"},
    "data_units_written":         {"Total data units written", "counter", "disk_usage"},
    "host_reads":                 {"Total host read commands", "counter", "disk_usage"},
    "host_writes":                {"Total host write commands", "counter", "disk_usage"},
    "reallocated_sector_ct":      {"Count of reallocated sectors", "gauge", "disk_wear"},
    "reallocated_event_count":    {"Reallocated event count", "gauge", "disk_wear"},
    "media_wearout_indicator":    {"Wearout indicator", "gauge", "disk_wear"},
    "offline_uncorrectable":      {"Uncorrectable offline sectors", "gauge", "disk_wear"},
    "total_lbas_written":         {"Total logical blocks written", "counter", "disk_wear"},
    "total_lbas_read":            {"Total logical blocks read", "counter", "disk_wear"},
    "power_cycle_count":          {"Number of power cycles", "counter", "disk_power"},
    "power_on_hours":             {"Total power on hours", "counter", "disk_power"},
    "unsage_shutdowns":           {"Count of unsafe shutdowns", "counter", "disk_power"},
    "spin_up_time":               {"Spin-up time", "gauge", "disk_spin"},
    "spin_retry_count":           {"Spin retry count", "gauge", "disk_spin"},
    "controller_busy_time":       {"Time the controller was busy", "counter", "disk_performance"},
    "critical_comp_time":         {"Time spent in critical component operations", "counter", "disk_performance"},
    "seek_time_performance":      {"Seek time performance", "gauge", "disk_performance"},
    "start_stop_count":           {"Start/stop count of the drive", "counter", "disk_performance"},
    "media_errors":               {"Number of media errors", "counter", "disk_errors"},
    "num_err_log_entries":        {"Number of error log entries", "counter", "disk_errors"},
    "raw_read_error_rate":        {"Rate of raw read errors", "gauge", "disk_errors"},
    "seek_error_rate":            {"Rate of seek errors", "gauge", "disk_errors"},
    "udma_crc_error_count":       {"Count of UDMA CRC errors", "counter", "disk_errors"},
    "end_to_end_error":           {"End-to-end error rate", "gauge", "disk_errors"},
    "reported_uncorrect":         {"Count of reported uncorrectable errors", "counter", "disk_errors"},
    "command_timeout":            {"Count of command timeouts", "counter", "disk_errors"},
    "throughput_performance":     {"Overall throughput performance of the drive", "gauge", "disk_performance"},
    "power-off_retract_count":    {"Count of power-off retract events", "counter", "disk_power"},
    "load_cycle_count":           {"Load cycle count of the drive", "counter", "disk_usage"},
    "temperature_celsius":        {"Current temperature in Celsius", "gauge", "disk_temperature"},
    "current_pending_sector":     {"Number of unstable sectors waiting to be remapped", "gauge", "disk_wear"},
	"critical_warning":           {"Indicates critical warnings for the device health", "gauge", "disk_health"},
    "percentage_used":            {"Percentage of the rated lifetime used by the device", "gauge", "disk_health"},
    "power_cycles":               {"Number of power cycle counts", "counter", "disk_power"},
    "unsafe_shutdowns":           {"Number of unsafe shutdowns that occurred", "counter", "disk_power"},
	"airflow_temperature_cel":    {"Temperature of the air flowing within the case", "gauge", "disk_temperature"},
    "hardware_ecc_recovered":     {"Number of error-correction checks performed", "counter", "disk_health"},
    "wear_leveling_count":        {"Number of wear leveling actions performed", "gauge", "disk_wear"},
}

func metricsHandler(w http.ResponseWriter, r *http.Request) {
    log.Println("Received metrics request.")
    defer func() {
        if r := recover(); r != nil {
            log.Printf("Recovered in metricsHandler: %v\n", r)
            http.Error(w, "Internal Server Error", http.StatusInternalServerError)
        }
    }()
    discoverAndProcessDisks(w)
}

func discoverAndProcessDisks(w io.Writer) {
    log.Println("Discovering disks...")
    cmd := exec.Command("C:\\Program Files\\smartmontools\\bin\\smartctl", "--scan")
    scanOutput, err := cmd.Output()
    if err != nil {
        log.Printf("Failed to scan disks: %s\n", err)
        return
    }

    scanner := bufio.NewScanner(strings.NewReader(string(scanOutput)))
    for scanner.Scan() {
        line := scanner.Text()
        log.Printf("Processing line: %s\n", line)
        parts := strings.Fields(line)
        if len(parts) > 0 {
            diskName := parts[0]
            log.Printf("Processing disk: %s\n", diskName)
            processDisk(diskName, w)
        }
    }
    log.Println("Completed disk discovery.")
}

func processDisk(diskName string, w io.Writer) {
    log.Printf("Getting SMART data for disk: %s\n", diskName)
    cmd := exec.Command("C:\\Program Files\\smartmontools\\bin\\smartctl", "-A", "--json=c", diskName)
    jsonData, err := cmd.Output()
    if err != nil {
        log.Printf("Failed to get SMART data for disk %s: %s\n", diskName, err)
        return
    }
    log.Printf("SMART data retrieved for disk: %s\n", diskName)

    var data map[string]interface{}
    if err := json.Unmarshal(jsonData, &data); err != nil {
        log.Printf("Error parsing JSON from disk %s: %s\n", diskName, err)
        return
    }

    nvmeExists := data["nvme_smart_health_information_log"] != nil
    ataExists := data["ata_smart_attributes"] != nil
    if !nvmeExists && !ataExists {
        log.Printf("Skipping disk %s as it does not contain NVMe or ATA data blocks\n", diskName)
        return
    }

    generateMetrics(data, w)
    log.Printf("Metrics generated for disk: %s\n", diskName)
}


func generateMetrics(data map[string]interface{}, w io.Writer) {
    deviceData, _ := data["device"].(map[string]interface{})
    deviceName := deviceData["name"].(string)
	deviceProtocol := deviceData["protocol"].(string)
    modelName, _ := data["model_name"].(string)
    serialNumber, _ := data["serial_number"].(string)

    // Check for NVMe data
    if nvmeData, found := data["nvme_smart_health_information_log"].(map[string]interface{}); found {
        processNVMeBlock(nvmeData, deviceName, deviceProtocol, modelName, serialNumber, w)
    }

    // Check for ATA data
    if ataData, found := data["ata_smart_attributes"].(map[string]interface{}); found {
        if table, exists := ataData["table"].([]interface{}); exists {
            processATABlock(table, deviceName, deviceProtocol, modelName, serialNumber, w)
        }
    }
}

func processNVMeBlock(nvmeData map[string]interface{}, deviceName, deviceProtocol, modelName, serialNumber string, w io.Writer) {
    for key, val := range nvmeData {
        if metricInfo, exists := metricConfig[key]; exists {
            if value, ok := val.(float64); ok {
                outputMetric(metricInfo, key, value, deviceName, deviceProtocol, modelName, serialNumber, w)
            }
        }
    }
}

func processATABlock(table []interface{}, deviceName, deviceProtocol, modelName, serialNumber string, w io.Writer) {
    for _, item := range table {
        if entry, ok := item.(map[string]interface{}); ok {
            if name, exists := entry["name"].(string); exists {
                // Convert name to lower case to handle case insensitivity
                lowerName := strings.ToLower(name)
                if metricInfo, found := metricConfig[lowerName]; found {
                    // Ensure proper parsing of the value
                    value, valueOk := entry["value"].(float64) // Assuming float64 is suitable for all your metrics
                    if !valueOk {
                        // Attempt to cast from an integer if float64 fails
                        if intValue, intOk := entry["value"].(int); intOk {
                            value = float64(intValue)
                            valueOk = true
                        }
                    }
                    if valueOk {
                        outputMetric(metricInfo, lowerName, value, deviceName, deviceProtocol, modelName, serialNumber, w)
                    } else {
                        log.Printf("Invalid or missing value for metric %s; found in JSON but could not parse as number.\n", name)
                    }
                } else {
                    log.Printf("Metric %s not found in configuration.\n", name)
                }
            } else {
                log.Printf("Missing 'name' field or not a string in ATA attributes.\n")
            }
        } else {
            log.Printf("Malformed entry in ATA attributes table, expected a map but got something else.\n")
        }
    }
}



func outputMetric(metricInfo MetricInfo, key string, value float64, deviceName, deviceProtocol, modelName, serialNumber string, w io.Writer) {
    //labels := fmt.Sprintf(`device_name="%s", device_protocol="%s", serial_number="%s"`, deviceName, deviceProtocol, modelName, serialNumber)
	labels := fmt.Sprintf(`device_name="%s", device_protocol="%s"`, deviceName, deviceProtocol)
    metricName := fmt.Sprintf("%s_%s", metricInfo.Heading, key)
    fmt.Fprintf(w, "# HELP %s %s\n", metricName, metricInfo.Help)
    fmt.Fprintf(w, "# TYPE %s %s\n", metricName, metricInfo.Type)
    fmt.Fprintf(w, "%s{%s} %v\n", metricName, labels, value)
}

//func metricsHandler(w http.ResponseWriter, r *http.Request) {
    //filePath := "hdd.json" // Adjust the file path as necessary
    //file, err := os.Open(filePath)
    //if err != nil {
    //    http.Error(w, fmt.Sprintf("Error opening file: %s", err), http.StatusInternalServerError)
    //    return
    //}
    //defer file.Close()

    //var data map[string]interface{}
    //if err := json.NewDecoder(file).Decode(&data); err != nil {
    //    http.Error(w, fmt.Sprintf("Error parsing JSON: %s", err), http.StatusInternalServerError)
    //    return
    //}

    //generateMetrics(data, w)
//	discoverAndProcessDisks(w)
//}

func runService(name string, isDebug bool) {
	var err error
	elog, err = eventlog.Open(name)
	if err != nil {
		log.Fatalf("Failed to open event log: %v", err)
		return
	}
	defer elog.Close()

	elog.Info(1, fmt.Sprintf("starting %s service", name))
	err = svc.Run(name, &myService{})
	if err != nil {
		elog.Error(1, fmt.Sprintf("%s service failed: %v", name, err))
		return
	}
	elog.Info(1, fmt.Sprintf("%s service stopped", name))
}

func main() {
    isInteractive, err := svc.IsAnInteractiveSession()
    if err != nil {
        log.Fatalf("Failed to determine session type: %v", err)
    }

    if !isInteractive {
        runService("SmartdExporterService", false)
        return
    }

    // Interactive mode - directly start HTTP server for debugging purposes
    log.Println("Running in interactive mode...")
    http.HandleFunc("/metrics", metricsHandler)
    log.Fatal(http.ListenAndServe(":19997", nil))
}
