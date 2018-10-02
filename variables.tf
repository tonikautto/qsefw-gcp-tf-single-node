variable "gcp_service_account" {
  description = "GCP service account used for Qlik Sense deployment"
}
variable "region" { 
  description = "GCP region as listed in https://cloud.google.com/compute/docs/regions-zones/#available"
}
variable "zone" { 
  description = "GCP zone as listed in https://cloud.google.com/compute/docs/regions-zones/#available"
}
variable "project_id" { 
  description = "GCP project ID"
}
variable "network_cidr" { 
  default = "Subnet CIDR used for Qlik Sense"
  default = "192.168.0.0/24"
}
variable "machine_type" { 
  description = "Machine type for Qlik Sense deployment"
}
variable "central_node_tag" { 
  description = "Tag used to apply security rules on server instance"
  default = "qse-node-central"
}
variable "qse_installer_url" {
  description = "URL to Qlik Sense Enterprise installer. Default is for June 2018 release."  
  default = "https://da3hntz84uekx.cloudfront.net/QlikSense/12.26.1/0/_MSI/Qlik_Sense_setup.exe"
}
variable "qse_cn_hostname" {
  description = "Windows host name for Qlik Sense central node"
  default = "qsefw-central"
}
variable "install_files_path" {
  description = "Local path on Qlik Sense server for installaiton file storage"
  default = "c:\\Qlik-Install"
}
variable "qse_share_path" {
  description = "Local path to Qlik Sense persistence storage"
  default = "c:\\Qlik-Share"
}
variable "qse_share_name" {
  description = "Name of Qlik Sense persistence SMB share"
  default = "QlikShare"
}
variable "qse_svc_user" {
  description = "Local Qlik Sense servcie account name"
  default = "QlikService"
}
variable "qse_license_key" {
  description = "Qlik Sense license key"
}
variable "qse_license_control" {
  description = "Qlik Sense control number"
}
variable "qse_license_name" {
  description = "Qlik Sense licensee name"
}
variable "qse_license_org" {
  description = "Qlik Sense licensee organisation"
}
variable "boot_disk_size_size" {
  description = "Boot disk size. Minimum 50GB for Win2016 image"
  default = "50"      
} 
variable "boot_disk_size_type" {
  description = "Boot disk type. pd-standard or pd-ssd, for HDD or SSD"
  default = "pd-standard"
}
variable "windows_admin_user" {
  description = "Local Windows administrator"
  default = "admin"   
}
variable "winrm_timeout" {
  default = "10m"
}

variable "windows_pwd_special_chars" {
  description = "Special characters allowed in Windows password policy"
  default = "~!@#$%^&*_-+=|(){}[]:;'<>.?"
}
