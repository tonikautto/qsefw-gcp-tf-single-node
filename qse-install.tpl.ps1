Start-Transcript -Path "${install_files_path}\bootstrap-qse-install.log" -Append
Set-ExecutionPolicy Bypass -Scope Process -Force

# Add firewall rules to allow HTTPS and RDP to server
# New-NetFirewallRule -DisplayName 'RDP Port 3389' -Direction Inbound -LocalPort 3389 -Protocol TCP -Action Allow 
# New-NetFirewallRule -DisplayName 'Qlik Sense' -Direction Inbound -LocalPort 443 -Protocol TCP -Action Allow
# New-NetFirewallRule -DisplayName 'WinRM' -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow

# Create Qlik Sense service account 
New-LocalUser -name "${qse_svc_user}" `
              -Password (ConvertTo-SecureString -AsPlainText "${qse_svc_password}" -Force) `
              -PasswordNeverExpires `
              -UserMayNotChangePassword `
              -AccountNeverExpires `
              -FullName "Qlik Service" `
              -ErrorAction Stop

Add-LocalGroupMember -Group Administrators -Member "${qse_svc_user}"

# Create Qlik Sense share folder
New-Item -type directory -path "${qse_share_path}" -Force

$acl = Get-Acl "${qse_share_path}"
$acl.SetAccessRuleProtection($True, $False)

$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("NT AUTHORITY\SYSTEM","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("${qse_svc_user}","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("${windows_admin_user}","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")
$acl.AddAccessRule($rule)

Set-Acl "${qse_share_path}" $acl
Get-Acl "${qse_share_path}"  | Format-List

# Create file share and grant service account full access
New-SmbShare -Path "${qse_share_path}" -Name "${qse_share_name}" -fullaccess "${qse_svc_user}"
Grant-SmbShareAccess -Name "${qse_share_name}" -AccountName "${qse_svc_user}" -AccessRight Full -Force
Grant-SmbShareAccess -Name "${qse_share_name}" -AccountName "${windows_admin_user}" -AccessRight Full -Force

# Qlik Sense installer arguments
$arguments = @("-silent -log ""${install_files_path}\qsefw-installation.log""", `
               "hostname=""${qse_cn_hostname}""", `
               "spc=""${install_files_path}\${shared_persistence_xml}""", `
               "userwithdomain=""${qse_cn_hostname}\${qse_svc_user}""", `
               "userpassword=""${qse_svc_password}""", `
               "dbpassword=""${qse_db_admin_password}""" 
             )

Write-Host "Initiating silent Qlik Sense installation..."
$arguments

Start-Process -FilePath "${install_files_path}\Qlik_Sense_setup.exe" -ArgumentList $arguments -NoNewWindow


# INSTALL QLIK CLI

Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
Install-Module -Name Qlik-CLI -Force  | Out-Null

# Wait for Qlik CLI to install 
do {
    Write-Host "Waiting for Qlik CLI to finish installing..."
    Start-Sleep -Seconds 10
    Import-Module Qlik-CLI -ErrorAction SilentlyContinue
} While(!(Get-Module -ListAvailable -Name Qlik-CLI))

# Connect to the Qlik Sense, when installation has finished
do {
    Write-Host "Waiting for Qlik Sense to finish installing..."
    Start-Sleep -Seconds 60
} While( (Connect-Qlik ${qse_cn_hostname} -TrustAllCerts -UseDefaultCredentials -ErrorAction SilentlyContinue).length -eq 0 )

# CONFIGURE QLIK SENSE

Set-QlikLicense -serial "${qse_license}" -control "${qse_control}" -name "${qse_name}" -organization "${qse_org}"

$json = (@{userId = "${qse_svc_user}";
            userDirectory = "${qse_cn_hostname}";
            name = "${qse_svc_user}";
        } | ConvertTo-Json -Compress -Depth 10 )

Invoke-QlikPost "/qrs/user" $json

Update-QlikUser -id $(Get-QlikUser -full -filter "name eq '${qse_svc_user}'").id -roles "RootAdmin" | Out-Null

#TBD: White list public Ip 
#$external_ip = Invoke-RestMethod http://ipinfo.io/json | Select -exp ip

Stop-Transcript