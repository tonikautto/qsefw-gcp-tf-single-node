resource "random_string" "database_password" {
  length = 16
  min_lower = 2
  min_upper = 2
  min_special = 2
  min_numeric = 2

  // Postgre password policy uncponfirmed  
  override_special = "!@#$()-_+?"
}

resource "random_string" "service_password" {
  length = 16
  min_lower = 2
  min_upper = 2
  min_special = 2
  min_numeric = 2

  override_special = "${var.windows_pwd_special_chars}"
}

resource "random_string" "admin_password" {
  length = 16
  min_lower = 2
  min_upper = 2
  min_special = 2
  min_numeric = 2

  override_special = "${var.windows_pwd_special_chars}"
}
