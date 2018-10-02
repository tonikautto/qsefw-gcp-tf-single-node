resource "google_compute_instance" "qs-central-node" {
  name         = "${var.qse_cn_hostname}" 
  zone         = "${var.zone}"
  machine_type = "${var.machine_type}"

  allow_stopping_for_update = true
  tags                      = ["${var.central_node_tag}"]

  boot_disk {
    auto_delete = "true"

    initialize_params {
      image = "windows-cloud/windows-2016"
      size  = "${var.boot_disk_size_size}"
      type  = "${var.boot_disk_size_type}"
    }
  }

  network_interface {
    subnetwork    = "${google_compute_subnetwork.qlik_subnet.name}"
    access_config = {}
    address       = ""
  }

  # Create installation folder, for setup file downloads
  # Create local administrator user for RDP and WinRM access
  metadata {
    sysprep-specialize-script-ps1 = <<EOF
New-Item -type directory -path "${var.install_files_path}" -Force
Start-Transcript -Path "${var.install_files_path}\bootstrap-sys-prep.log" -Append
New-LocalUser -name "${var.windows_admin_user}" -Password (ConvertTo-SecureString -AsPlainText "${random_string.admin_password.result}" -Force) -PasswordNeverExpires -AccountNeverExpires -FullName "${var.windows_admin_user}"
Add-LocalGroupMember -Group "Administrators" -Member "${var.windows_admin_user}"
Add-LocalGroupMember -Group "Remote Management Users" -Member "${var.windows_admin_user}"
Stop-Transcript
EOF
#${data.template_file.sys_prep_ps1.rendered}
  }

  # Enable WinRM with Basic auth over unencrypted connection
  metadata {
    windows-startup-script-ps1 = <<EOF
Start-Transcript -Path "${var.install_files_path}\bootstrap-windows-startup.log" -Append
New-NetFirewallRule -DisplayName 'RDP Port 3389' -Direction Inbound -LocalPort 3389 -Protocol TCP -Action Allow 
New-NetFirewallRule -DisplayName 'Qlik Sense' -Direction Inbound -LocalPort 443 -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName 'WinRM' -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow

do {
    Start-Sleep -Seconds 20
    Enable-PSRemoting -Force 
    Set-Item "wsman:\localhost\client\trustedhosts" -Value '*' -Force

    winrm set winrm/config/service/auth '@{Basic="true"}'  
    winrm set winrm/config/service '@{AllowUnencrypted="true"}'
    winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="1024"}'
    
    $winrm_cfg=[xml](winrm get winrm/config/service -format:xml)
    $winrm_cfg.Service
    $winrm_cfg.Service.Auth
} While( ($winrm_cfg.Service.AllowUnencrypted -eq "false") -or ($winrm_cfg.Service.Auth.Basic -eq "false") )

# Note, BitsTransfer does not work in remote-exec, must run in win startup  
Start-BitsTransfer -Source ${var.qse_installer_url} -Destination "${var.install_files_path}\Qlik_Sense_setup.exe" -ErrorAction Stop

Stop-Transcript
EOF
#${data.template_file.windows_startup_ps1.rendered}
  }

  connection {
    type     = "winrm"
    user     = "${var.windows_admin_user}"
//    password = "${var.admin_pwd}" 
    password = "${random_string.admin_password.result}"
    timeout  = "${var.winrm_timeout}"
    https    = "false"
    insecure = "true"
  }

  # Copy setup and configuration files to remote side
  provisioner "file" {
    source      = "./remote-files/shared-persistence.xml"
    destination = "${var.install_files_path}\\shared-persistence.xml"
  }  
  provisioner "file" {
    source      = "./remote-files/qse-install.ps1"
    destination = "${var.install_files_path}\\qse-install.ps1"
  }  
  
  # Execute Qlik Sense installation and configuration
  provisioner "remote-exec" {
    inline = ["powershell ${var.install_files_path}\\qse-install.ps1"]
  }  

}