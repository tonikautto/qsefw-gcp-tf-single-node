output "Public IP                      " { value = "${google_compute_instance.qs-central-node.*.network_interface.0.access_config.0.assigned_nat_ip[0]}" }
output "Qlik Sense Hub                 " { value = "https://${google_compute_instance.qs-central-node.*.network_interface.0.access_config.0.assigned_nat_ip[0]}/" }
output "Qlik Sense QMC                 " { value = "https://${google_compute_instance.qs-central-node.*.network_interface.0.access_config.0.assigned_nat_ip[0]}/qmc/" }
output "Windows Administrator Name     " { value = "${upper(var.qse_cn_hostname)}\\${var.windows_admin_user}"}
output "Windows Administrator Pwd      " { value = "${random_string.admin_password.result}"}
output "Qlik Sense Service Account Name" { value = "${upper(var.qse_cn_hostname)}\\${var.qse_svc_user}"}
output "Qlik Sense Service Account Pwd " { value = "${random_string.service_password.result}"}
output "Qlik Sense Repository DB Pwd   " { value = "${random_string.database_password.result}"}
