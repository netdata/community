template {
  source = "<absolute_path>/template.ctmpl"
  destination = "/etc/netdata/health.d/cpu.conf"
  command = "systemctl restart netdata "
}
log_level = "debug"