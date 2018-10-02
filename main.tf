provider "google" {
  credentials = "${file("./.secrets/account.json")}"
  region  = "${var.region}"
  project = "${var.project_id}"
}
