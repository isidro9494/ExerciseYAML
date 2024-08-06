#Se definen las variables que necesitamos
variable "acr_server" {
  description = "The ACR server for the instance registry"
  type        = string
}

variable "acr_server_subscription" {
  description = "The subscription ID for the instance registry"
  type        = string
}

variable "source_acr_client_id" {
  description = "The client ID for the source ACR"
  type        = string
}

variable "source_acr_client_secret" {
  description = "The client secret for the source ACR"
  type        = string
}

variable "source_acr_server" {
  description = "The ACR server for the reference registry"
  type        = string
}

variable "charts" {
  description = "List of Helm charts to be copied and installed"
  type = list(object({
    chart_name       = string
    chart_namespace  = string
    chart_repository = string
    chart_version    = string
    values = list(object({
      name  = string
      value = string
    }))
    sensitive_values = list(object({
      name  = string
      value = string
    }))
  }))
}
