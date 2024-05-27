variable "LOCATION" {
  type        = string
  description = "Name of the location of differnet resource group"
}
variable "RESOURCE_NAME_PREFIX" {
  type        = string
  description = "Prefix of the resource group name"
}
variable "ENV" {
  type        = string
  description = "Name of the environment of the resources"
}
variable "SQL_SERVER_ADMINISTRATOR_LOGIN" {
  type        = string
  description = "SQL Server administraion login key"
}
variable "SQL_SERVER_ADMINISTRATOR_PASSWORD" {
  type        = string
  description = "SQl Server administration password"
  sensitive   = true
}
variable "backed_resource_group_name" {
  type        = string
  description = "The name of the backend storage account resource group"
  default     = "<storage act resource group name>"
}
variable "backend_container_name" {
  type        = string
  description = "The container name for the backend config"
  default     = "<blob storage container name>"

}
variable "backend_storage_account_name" {
  type        = string
  description = "The name of the backend storage account"
  default     = "<storage account name>"
}
variable "backend_key" {
  type        = string
  description = "The access key for the storage account"
  default     = "<storage account key>"
}
variable "sql_server_version" {
  type        = string
  description = "Version of SQL server"
  default     = "12.0"
}
variable "sql_server_connection_policy" {
  type        = string
  description = "SQL server connection policy"
  default     = "Default"
}
variable "sql_server_firewall_rules" {
  type        = map(any)
  description = "SQL server firewall rules"
  default = {
    allow_azure_services = {
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    }
  }
}
variable "edition" {
  type        = string
  description = "Edition of the server"
  default     = "Basic"
}
variable "collation" {
  type        = string
  description = "SQL Collation"
  default     = "SQL_Latin1_General_CP1_CI_AS"
}
variable "max_size_gigabytes" {
  type        = number
  description = "Size of the Server"
  default     = 1
}
variable "zone_redundant" {
  type        = bool
  description = "Zone redundant feature"
  default     = false
}
variable "os_type" {
  type        = string
  description = "Type of OS"
  default     = "Windows"
}

variable "app_service_plan_sku" {
  type        = string
  description = "SKU plan"
  default     = "S1"
}

variable "sql_db_sku" {
  type        = string
  description = "SKU plan of SQL"
  default     = "S0"
}
variable "connection_string_name" {
  type        = string
  description = "Connection key"
  default     = "MyDbConnection"
}
variable "app_version" {
  type = string
  description = "Version of the App"
  default     = "1.0.0"
}