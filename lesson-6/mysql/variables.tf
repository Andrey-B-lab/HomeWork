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
  description = "The MySQL user password"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "The database host address"
  type        = string
}
