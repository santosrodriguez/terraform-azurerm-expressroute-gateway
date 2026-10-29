variable "express_route_gateway_scale_units" {
  description = "Number of scale units for the Virtual WAN ExpressRoute gateway. Each scale unit provides 2 Gbps of aggregate throughput."
  type        = number
  default     = 1
}

variable "virtual_hub_id" {
  description = "The ID of the Virtual Hub to which the ExpressRoute gateway will be attached."
  type        = string
}

variable "solution_name" {
  description = "The name of the solution, used as a prefix for resource naming."
  type        = string
}

variable "location" {
  description = "The location/region where resources will be deployed."
  type        = string
}

variable "environment" {
  description = "The environment for the deployment (e.g., dev, test, prod)."
  type        = string
}


variable "resource_group_name" {
  description = "The name of the resource group where the ExpressRoute gateway will be deployed."
  type        = string
}
variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

