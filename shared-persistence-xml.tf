data "template_file" "shared_persistence_xml" {

  template = "${file("shared-persistence.tpl.xml")}"

  vars {
    qse_cn_hostname = "${var.qse_cn_hostname}"
    qse_share_name  = "${var.qse_share_name}"
    qse_db_repo_pwd = "${random_string.database_password.result}"
  }
}

resource "local_file" "shared_persistence_xml" {
  content  = "${data.template_file.shared_persistence_xml.rendered}"
  filename = "./remote-files/shared-persistence.xml"
}