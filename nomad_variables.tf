provider "nomad" {
address = var.nomad_addr
token = var.nomad_token
}


resource "nomad_variable" "n8n_vars" {
path = "nomad/jobs/n8n"
items = {
mariadb_host = "10.1.2.3"
mariadb_port = "3306"
mariadb_name = "n8nprod"
mariadb_user = "n8n_user"
mariadb_password = var.mariadb_password
n8n_basic_auth_user = "admin"
n8n_basic_auth_password = var.n8n_basic_auth_password
n8n_timezone = "UTC"
}
}