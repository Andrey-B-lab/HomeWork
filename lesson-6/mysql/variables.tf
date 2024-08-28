variable "mysql_root_password" {
  description = "The root password for the MySQL database"
  type        = string
  sensitive   = true
}

variable "mysql_database" {
  description = "The name of the MySQL database"
  type        = string
  default     = "bookstack"
}

variable "mysql_user" {
  description = "The MySQL user"
  type        = string
  default     = "bookstack"
}

variable "mysql_password" {
  description = "The password for the MySQL user"
  type        = string
  sensitive   = true
}
