variable "azure_subscription_id" {
  description = "The Azure Subscription ID"
  type        = string
}

variable "azure_client_id" {
  description = "The Azure Client ID"
  type        = string
}

variable "azure_client_secret" {
  description = "The Azure Client Secret"
  type        = string
}

variable "azure_tenant_id" {
  description = "The Azure Tenant ID"
  type        = string
}

variable "sql_admin" {
  description = "The SQL Server administrator username"
  type        = string
}

variable "sql_password" {
  description = "The SQL Server administrator password"
  type        = string
  sensitive   = true
}

variable "sql_server_name" {
  description = "Nombre del servidor SQL"
  type        = string
}

variable "database_name" {
  description = "Nombre de la base de datos"
  type        = string
}
