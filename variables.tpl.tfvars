# Either uncomment the variable values below and edit, 
# or enter during Terraform deployment

# Define GCP region and zone for deployment, for available options see
# https://cloud.google.com/compute/docs/regions-zones/#available  

#region  = "australia-southeast1"
#zone    = "australia-southeast1-c"

# Service account executing Terraform in Google Cloud Platform
# This is qsefw-sa@qsefw-tf-single-node.iam.gserviceaccount.com if you followed the README guide

gcp_service_account = "qsefw-sa@qsefw-tf-single-node.iam.gserviceaccount.com"

# ID of GCP project to deploy in
# Set to qsefw-gcp-tf if you followed the GCP setup in README

#project_id = "PROJECT_ID"

# Google Compute Engine (GKE) configuration
# Machine type reference: https://cloud.google.com/compute/docs/machine-types
# Local disk size for installation and Qlik Sense persistence storage
# Note 50GB is minimum for Windows Server 2016 image in GCP
# Disk type can be pd-standard or pd-ssd
machine_type          = "n1-highmem-2"
boot_disk_size_size   = "50"
boot_disk_size_type   = "pd-standard"

# Qlik Sense license details
# Replace below values with valid license key
 
#qse_license_key            = "QLIK_SENSE_LICENSE_SERIAL"
#qse_license_control        = "QLIK_SENSE_LICENSE_CONTROL_NO"
#qse_license_name           = "QLIK_SENSE_LICENSE_NAME"
#qse_license_org            = "QLIK_SENSE_LICENSE_ORG"

# The downlaod URL for Qlik Sense installer. Below link goes to February 2019 release.
 qse_installer_url  = "https://da3hntz84uekx.cloudfront.net/QlikSense/13.9/0/_MSI/Qlik_Sense_setup.exe" 
