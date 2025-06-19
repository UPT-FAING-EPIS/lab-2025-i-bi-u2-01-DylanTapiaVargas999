terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}

  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}

# Recurso: Grupo de recursos
resource "azurerm_resource_group" "lap_u2_1_rg" {
  name     = "lap_u2_1_rg"
  location = "westus2"
}

# Recurso: Servidor SQL
resource "azurerm_mssql_server" "lap_u2_1_sql_server" {
  name                         = var.sql_server_name
  location                     = azurerm_resource_group.lap_u2_1_rg.location
  resource_group_name          = azurerm_resource_group.lap_u2_1_rg.name
  version                      = "12.0"
  administrator_login          = var.sql_admin
  administrator_login_password = var.sql_password
}

# Recurso: Base de datos
resource "azurerm_mssql_database" "lap_u2_1_db" {
  name      = var.database_name
  server_id = azurerm_mssql_server.lap_u2_1_sql_server.id
  sku_name  = "Basic"
  depends_on = [
    azurerm_mssql_server.lap_u2_1_sql_server
  ]
}

# Recurso: Regla de firewall para IP pública
resource "azurerm_mssql_firewall_rule" "allow_my_ip" {
  name             = "AllowMyIP"
  server_id        = azurerm_mssql_server.lap_u2_1_sql_server.id
  start_ip_address = "38.250.158.150"
  end_ip_address   = "38.250.158.150"
}
