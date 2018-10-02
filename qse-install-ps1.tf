data "template_file" "qse_install_ps1" {
  template = "${file("qse-install.tpl.ps1")}"

  vars {
    windows_admin_user         = "${var.windows_admin_user}"
    windows_admin_password     = "${random_string.admin_password.result}"

    install_files_path         = "${var.install_files_path}"
    qse_installer_url          = "${var.qse_installer_url}"

    qse_share_path             = "${var.qse_share_path}"
    qse_share_name             = "${var.qse_share_name}"

    qse_svc_user               = "${var.qse_svc_user}"
    qse_svc_password           = "${random_string.service_password.result}"

    qse_db_admin_password      = "${random_string.database_password.result}"
    qse_cn_hostname            = "${var.qse_cn_hostname}"

    qse_license                = "${var.qse_license_key}"
    qse_control                = "${var.qse_license_control}"
    qse_name                   = "${var.qse_license_name}"
    qse_org                    = "${var.qse_license_org}"

    shared_persistence_xml     = "shared-persistence.xml"
  }
}

resource "local_file" "qse_install_ps1" {
  content  = "${data.template_file.qse_install_ps1.rendered}"
  filename = "./remote-files/qse-install.ps1"
}
