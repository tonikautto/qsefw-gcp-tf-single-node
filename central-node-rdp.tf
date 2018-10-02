data "template_file" "central_node_rdp" {

//  template = "${file("central-node.tpl.rdp")}"
  template = <<EOF
full address:s:${google_compute_instance.qs-central-node.*.network_interface.0.access_config.0.assigned_nat_ip[0]}
audiomode:i:2
authentication level:i:0
disable themes:i:1
prompt for credentials:i:0
redirectclipboard:i:1
server port:i:3389
screen mode id:i:2
smart sizing:i:0
username:s:${var.qse_cn_hostname}\${var.windows_admin_user}
EOF
}

resource "local_file" "central_node_rdp" {
    content     = "${data.template_file.central_node_rdp.rendered}"
    filename = "central-node.rdp"
}