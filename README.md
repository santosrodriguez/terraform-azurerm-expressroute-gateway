# Azure ExpressRoute Gateway

Creates an `azurerm_express_route_gateway` attached to an existing Azure Virtual WAN hub and returns its resource ID.

## Prerequisites

- An existing Azure resource group and Virtual WAN hub.
- Azure credentials with permission to create and manage the gateway.
- An AzureRM provider configuration in the calling Terraform configuration.

Resource group, hub, ExpressRoute circuit, and circuit connection creation are outside this module's scope.

## Provider setup

Provider requirements are declared in [`providers.tf`](./providers.tf):

| Provider | Source | Version constraint | Purpose |
| --- | --- | --- | --- |
| AzureRM | `hashicorp/azurerm` | `~> 4.0` | Create the ExpressRoute gateway. |
| AzureCAF | `aztfmod/azurecaf` | Not constrained | Generate the gateway name. |
| Random | `hashicorp/random` | Not constrained | Generate a four-letter lowercase name suffix. |

Configure AzureRM authentication and subscription settings in the calling Terraform configuration. The module does not declare a Terraform version constraint.

## Usage

Add this module block to a calling configuration at the repository root. Replace the example values with your existing resource group, region, and hub ID. The caller must already configure the AzureRM provider.

```hcl
module "expressroute_gateway" {
  source = "./expressroute-gateway"

  solution_name       = "connectivity"
  location            = "eastus"
  environment         = "prod"
  resource_group_name = "rg-connectivity-prod"
  virtual_hub_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-connectivity-prod/providers/Microsoft.Network/virtualHubs/vhub-eastus-prod"

  express_route_gateway_scale_units = 1

  tags = {
    environment = "prod"
    workload    = "connectivity"
  }
}

output "express_route_gateway_id" {
  value = module.expressroute_gateway.express_route_gateway_id
}
```

The `source` path is relative to the calling configuration. Adjust it if your caller is elsewhere.

Run these commands from the calling configuration directory to initialize, validate, and review the proposed deployment:

```shell
terraform init
terraform validate
terraform plan
```

## Inputs

| Name | Type | Default | Required | Description |
| --- | --- | --- | --- | --- |
| `solution_name` | `string` | None | Yes | Solution identifier included in the generated name. |
| `location` | `string` | None | Yes | Azure region for the gateway; also included in the generated name. |
| `environment` | `string` | None | Yes | Environment identifier, such as `dev`, `test`, or `prod`, included in the generated name. |
| `resource_group_name` | `string` | None | Yes | Existing resource group in which to create the gateway. |
| `virtual_hub_id` | `string` | None | Yes | Resource ID of the existing Virtual WAN hub. |
| `express_route_gateway_scale_units` | `number` | `1` | No | Number of gateway scale units. Each scale unit provides 2 Gbps of aggregate throughput. |
| `tags` | `map(string)` | `{}` | No | Tags applied when the gateway is created. Subsequent tag changes are ignored. |

See the [AzureRM ExpressRoute gateway documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway) for gateway arguments and scale-unit details.

## Outputs

| Name | Description |
| --- | --- |
| `express_route_gateway_id` | Azure resource ID of the ExpressRoute gateway. |

## Naming and tags

AzureCAF generates the name using the `azurerm_express_route_gateway` resource type. The module supplies `solution_name`, `location`, `environment`, and a four-letter random suffix as naming suffixes. AzureCAF applies its resource naming rules to those values.

The gateway has `lifecycle.ignore_changes = [tags]`. Tags are set during creation, but later edits to the `tags` input or tags in Azure do not cause Terraform to update the gateway's tags.
