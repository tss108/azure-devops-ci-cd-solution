### Provides local variables for configuration
locals {
  rg_name               = "rg-${var.RESOURCE_NAME_PREFIX}-${var.LOCATION}-${var.ENV}"
  app_service_plan_name = "plan-${var.RESOURCE_NAME_PREFIX}-${var.LOCATION}-${var.ENV}"
  app_service_name      = "app-${var.RESOURCE_NAME_PREFIX}-${var.LOCATION}-${var.ENV}"
  sql_server_name       = "sql-${var.RESOURCE_NAME_PREFIX}-${var.LOCATION}-${var.ENV}"
  sql_db_name           = "sqldb-${var.RESOURCE_NAME_PREFIX}-${var.LOCATION}-${var.ENV}"
}


### Creating resource group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.LOCATION
}

# Deploys app service plan.
resource "azurerm_service_plan" "app_service_plan" {
  name                = local.app_service_plan_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = var.os_type
  sku_name            = var.app_service_plan_sku
}


# Deploys Azure web appliaction with connection string to previously created SQL database
resource "azurerm_windows_web_app" "app_service" {
  name                = local.app_service_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {}

  connection_string {
    name  = var.connection_string_name
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sql_db.name};Persist Security Info=False;User ID=${var.SQL_SERVER_ADMINISTRATOR_LOGIN};Password=${var.SQL_SERVER_ADMINISTRATOR_PASSWORD};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
  app_settings = {
    "Version" = var.app_version
  }
}


resource "azurerm_windows_web_app_slot" "app_service" {
  name           = local.app_service_name
  app_service_id = azurerm_windows_web_app.app_service.id

  site_config {}
  connection_string {
    name  = var.connection_string_name
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_mssql_server.sql_server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.sql_db.name};Persist Security Info=False;User ID=${var.SQL_SERVER_ADMINISTRATOR_LOGIN};Password=${var.SQL_SERVER_ADMINISTRATOR_PASSWORD};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}

### Creates Azure SQL server
resource "azurerm_mssql_server" "sql_server" {
  name                         = local.sql_server_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.LOCATION
  version                      = var.sql_server_version
  administrator_login          = var.SQL_SERVER_ADMINISTRATOR_LOGIN
  administrator_login_password = var.SQL_SERVER_ADMINISTRATOR_PASSWORD
  minimum_tls_version          = "1.2"
}


### Creates Azure SQL server firewall rule
resource "azurerm_mssql_firewall_rule" "sql_server" {
  for_each = var.sql_server_firewall_rules

  name             = each.key
  server_id        = azurerm_mssql_server.sql_server.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

### Creates Azure SQL database
resource "azurerm_mssql_database" "sql_db" {
  name           = local.sql_db_name
  server_id      = azurerm_mssql_server.sql_server.id
  collation      = var.collation
  max_size_gb    = var.max_size_gigabytes
  sku_name       = var.sql_db_sku
  zone_redundant = var.zone_redundant

}
