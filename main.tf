
resource "random_string" "suffix" {
  length = 4
  upper = false
  special = false
  numeric = false
}

resource "azurecaf_name" "name" {
  resource_type = "azurerm_express_route_gateway"
  suffixes = [ var.solution_name, var.location, var.environment, random_string.suffix.result ]
}




resource "azurerm_express_route_gateway" "this" {
  name                = azurecaf_name.name.result
  resource_group_name = var.resource_group_name
  location            = var.location

  virtual_hub_id = var.virtual_hub_id
  scale_units    = var.express_route_gateway_scale_units

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
