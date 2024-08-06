#Crea la logica del programa importando los chart que esten registrados
provider "azurerm" {
  features {}
}

resource "azurerm_container_registry" "instance_acr" {
  name                = "instance"
  resource_group_name = "your_resource_group"
  location            = "your_location"
  sku                 = "Basic"
}

resource "azurerm_container_registry" "reference_acr" {
  name                = "reference"
  resource_group_name = "your_resource_group"
  location            = "your_location"
  sku                 = "Basic"
}

resource "null_resource" "copy_helm_charts" {
  count = length(var.charts)

  provisioner "local-exec" {
    command = <<EOT
      az acr helm repo add --name ${azurerm_container_registry.reference_acr.name} --username ${var.source_acr_client_id} --password ${var.source_acr_client_secret}
      az acr helm repo add --name ${azurerm_container_registry.instance_acr.name} --username ${var.source_acr_client_id} --password ${var.source_acr_client_secret}
      az acr helm push --name ${azurerm_container_registry.instance_acr.name} ${var.charts[count.index].chart_repository}/${var.charts[count.index].chart_name}-${var.charts[count.index].chart_version}.tgz
    EOT
  }
}

resource "helm_release" "chart" {
  count = length(var.charts)

  name       = var.charts[count.index].chart_name
  namespace  = var.charts[count.index].chart_namespace
  repository = "https://${azurerm_container_registry.instance_acr.login_server}/helm/v1/repo" 
  chart      = var.charts[count.index].chart_name
  version    = var.charts[count.index].chart_version

  values = [for v in var.charts[count.index].values : "${v.name}=${v.value}"]
  set_sensitive = [for sv in var.charts[count.index].sensitive_values : "${sv.name}=${sv.value}"]
}
