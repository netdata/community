#!/bin/bash

set -e # Enable the script to exit immediately if a command exits with a non-zero status.

# Function to clean special characters in parsed data
clean_data() {
    echo "$1" | tr -d '\r'
}

# Function to process each network address (IP or hostname)
configure_address() {
    ADDRESS="$1"

    echo "Processing address: $ADDRESS"

    # Fetch data
    DATA=$(curl -s "http://$ADDRESS:19998" || echo "error")
    if [[ "$DATA" == "error" || -z "$DATA" ]]; then
        echo "Error: Failed to fetch data or no data returned for $ADDRESS. Proceeding to next address if applicable."
        return 1
    fi

    # Parse data
    HOSTNAME=$(echo "$DATA" | grep 'Hostname:' | cut -d ' ' -f2)
    GUID=$(echo "$DATA" | grep 'UID:' | cut -d ' ' -f2)
    OS_NAME="Microsoft Windows"
    OS_VERSION=$(echo "$DATA" | grep 'OS Version:' | sed -E 's/.*Microsoft Windows (.*) Home/\1 Home/')
    SYSTEM_CORES=$(clean_data "$(echo "$DATA" | grep 'NumberOfCores=' | cut -d '=' -f2)")
    CPU_FREQ=$(clean_data "$(echo "$DATA" | grep 'MaxClockSpeed=' | cut -d '=' -f2)")
    SYSTEM_RAM_TOTAL=$(echo "$DATA" | grep 'TotalPhysicalMemory=' | cut -d '=' -f2)
    SYSTEM_DISK_SPACE=$(echo "$DATA" | grep 'Hard Disk Size:' | cut -d '=' -f2)
    KERNEL_VERSION=$(echo "$DATA" | grep 'Kernel:' | cut -d '=' -f2)
    ARCHITECTURE=$(echo "$DATA" | grep 'Architecture:' | cut -d '=' -f2)
    
    # Define configuration file paths
    WINDOWS_CONF_PATH="/etc/netdata/go.d/windows.conf"
    VNODES_CONF_PATH="/etc/netdata/vnodes/vnodes.conf"
    if [[ ! -f "$WINDOWS_CONF_PATH" ]]; then
        WINDOWS_CONF_PATH="/opt/netdata/etc/netdata/go.d/windows.conf"
    fi
    if [[ ! -f "$VNODES_CONF_PATH" ]]; then
        VNODES_CONF_PATH="/opt/netdata/etc/netdata/vnodes/vnodes.conf"
    fi
    
    # Check and append/update windows.conf
    if [[ -f "$WINDOWS_CONF_PATH" ]]; then
        # Check if the job for the address already exists
        if grep -Fq "url: http://$ADDRESS:9182/metrics" "$WINDOWS_CONF_PATH"; then
            read -p "Configuration for $ADDRESS already exists in windows.conf. Overwrite? [y/N]: " choice
            if [[ "$choice" =~ ^[Yy]$ ]]; then
                echo "Replacing existing configuration for $ADDRESS in windows.conf."
                # Remove the existing job entry based on a unique identifier, e.g., the hostname or URL
                sed -i "/  - name: $HOSTNAME/,+3d" "$WINDOWS_CONF_PATH"
    
                # Directly append the new job details without adding "jobs:"
                echo "  - name: $HOSTNAME" >> "$WINDOWS_CONF_PATH"
                echo "    vnode: $HOSTNAME" >> "$WINDOWS_CONF_PATH"
                echo "    url: http://$ADDRESS:9182/metrics" >> "$WINDOWS_CONF_PATH"
    
            else
                echo "Skipping windows.conf update."
            fi
        else
            # If this is the first job or if "jobs:" is not present, add it
            if ! grep -Fq "jobs:" "$WINDOWS_CONF_PATH"; then
                echo "jobs:" >> "$WINDOWS_CONF_PATH"
            fi
            echo "Appending new configuration for $ADDRESS in windows.conf."
            # Append the job details
            echo "  - name: $HOSTNAME" >> "$WINDOWS_CONF_PATH"
            echo "    vnode: $HOSTNAME" >> "$WINDOWS_CONF_PATH"
            echo "    url: http://$ADDRESS:9182/metrics" >> "$WINDOWS_CONF_PATH"
        fi
    else
        echo "Error: windows.conf not found."
    fi

    # Check and append/update vnodes.conf
	if [[ -f "$VNODES_CONF_PATH" ]]; then
        if grep -Fq "hostname: $HOSTNAME" "$VNODES_CONF_PATH"; then
             read -p "An entry for $HOSTNAME already exists in vnodes.conf. Overwrite? [y/N]: " choice
           if [[ "$choice" =~ ^[Yy]$ ]]; then
               echo "Replacing existing configuration for $HOSTNAME in vnodes.conf."
               # Create a temporary file with the new entry
               TEMP_FILE=$(mktemp)
               cat <<EOF >"$TEMP_FILE"
- hostname: $HOSTNAME
  guid: $GUID
  labels:
    _os_name: "$OS_NAME"
    _os_version: "$OS_VERSION"
    _system_cores: "$SYSTEM_CORES"
    _system_cpu_freq: "$CPU_FREQ"
    _system_ram_total: "$SYSTEM_RAM_TOTAL"
    _system_disk_space: "$SYSTEM_DISK_SPACE"
    _kernel_version: "$KERNEL_VERSION"
    _architecture: "$ARCHITECTURE"
EOF

              # Remove the existing entry for the hostname
              sed -i "/- hostname: $HOSTNAME/,/  _architecture: .*/d" "$VNODES_CONF_PATH"

              # Append the new entry
              cat "$TEMP_FILE" >> "$VNODES_CONF_PATH"
              rm "$TEMP_FILE" # Clean up the temporary file
           else
              echo "Skipping vnodes.conf update for $HOSTNAME."
              return 1
           fi
        else
           echo "Appending new configuration for $ADDRESS in vnodes.conf."
           cat <<EOF >>"$VNODES_CONF_PATH"
- hostname: $HOSTNAME
  guid: $GUID
  labels:
    _os_name: "$OS_NAME"
    _os_version: "$OS_VERSION"
    _system_cores: "$SYSTEM_CORES"
    _system_cpu_freq: "$CPU_FREQ"
    _system_ram_total: "$SYSTEM_RAM_TOTAL"
    _system_disk_space: "$SYSTEM_DISK_SPACE"
    _kernel_version: "$KERNEL_VERSION"
    _architecture: "$ARCHITECTURE"
EOF
        fi
    else
         echo "Error: vnodes.conf not found."
    fi

    # Restart netdata
    if ! systemctl restart netdata 2>/dev/null && ! service netdata restart 2>/dev/null; then
        echo "Warning: Failed to restart netdata for $ADDRESS. Please manually restart the netdata agent."
        return 1
    fi

    # Wait for 10 seconds
    echo -n "Applying changes."
    for i in {1..10}; do
        echo -n "."
        sleep 1
    done
    echo

    echo "Windows node $ADDRESS successfully configured."
}

# Main logic to handle a list of addresses or a single address
if [[ -n "$1" && -f "$1" ]]; then
    error_count=0
    total_count=0
    while IFS= read -r line; do
        ((total_count++))
        if ! configure_address "$line"; then
            ((error_count++))
        fi
    done < "$1"
    if ((error_count == total_count)); then
        echo "All Windows hosts failed to configure. Please check the log for errors."
        exit 1
    fi
elif [[ -n "$1" ]]; then
    if ! configure_address "$1"; then
        echo "Failed to configure: $1"
        exit 1
    fi
else
    echo "Usage: $0 <IP_or_Hostname_or_DNSname> or $0 <file_with_host_addresses>"
    exit 1
fi


