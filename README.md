# Platform Firewall Rules

[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-module-template.svg)](https://registry.terraform.io/modules/qbeyond/terraform-module-template/provider/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-module-template.svg)](https://github.com/qbeyond/terraform-module-template/blob/main/LICENSE)

---

This module creates a firewall rule collection group with standardized rules for platform. This includes rules from azure to azure services and exclude rules that are on customer or on-premise side. The standard ist defined by the q.beyond AG.

<!-- BEGIN_TF_DOCS -->
## Usage

It's very easy to use!
```hcl
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example-fw"
  location = local.location
}

resource "azurerm_virtual_network" "example" {
  name                = "vnet-example"
  address_space       = ["10.0.0.0/16"]
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "AzureFirewallSubnet" # Must be exact 'AzureFirewallSubnet'
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.0.0/16"]
}

resource "azurerm_public_ip" "example" {
  name                = "pip-example"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "example" {
  name                = "fw-example"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  firewall_policy_id = azurerm_firewall_policy.example.id

  ip_configuration {
    name                 = "ip-config"
    subnet_id            = azurerm_subnet.example.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_firewall_policy" "example" {
  name                = "fwp-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = local.location

  dns {
    proxy_enabled = true
  }
}

module "firewall_rules" {
  source = "../.."

  firewall_policy_id  = azurerm_firewall_policy.example.id
  resource_group_name = azurerm_resource_group.example.name

  responsibility   = "Platform"
  stage            = "prd"
  default_location = local.location

  ipg_azure_dc_id           = azurerm_ip_group.azure_dc.id
  ipg_onpremise_dc_id       = azurerm_ip_group.onpremise_dc.id
  ipg_aplication_lz_id      = azurerm_ip_group.aplication_lz.id
  ipg_dnsprivateresolver_id = azurerm_ip_group.dnsprivateresolver.id
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_location"></a> [default\_location](#input\_default\_location) | The default location used for this module. | `string` | n/a | yes |
| <a name="input_ipg_aplication_lz_id"></a> [ipg\_aplication\_lz\_id](#input\_ipg\_aplication\_lz\_id) | IP ranges for all application landing zones. | `string` | n/a | yes |
| <a name="input_ipg_azure_dc_id"></a> [ipg\_azure\_dc\_id](#input\_ipg\_azure\_dc\_id) | The ip addresses of the domain controller located in azure. | `string` | n/a | yes |
| <a name="input_ipg_dnsprivateresolver_id"></a> [ipg\_dnsprivateresolver\_id](#input\_ipg\_dnsprivateresolver\_id) | The ip address of the private dns resolver inbound endpoint. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the firewall policy and the azure firewall are located. | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | The stage that the resource is located in, e.g. prod, dev. | `string` | n/a | yes |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | For testing use this | `string` | `null` | no |
| <a name="input_ipg_onpremise_dc_id"></a> [ipg\_onpremise\_dc\_id](#input\_ipg\_onpremise\_dc\_id) | If the customer still operates domain controller on premise, provide these in this variable. | `string` | `null` | no |
| <a name="input_responsibility"></a> [responsibility](#input\_responsibility) | The responsibility means who is responsible for the rule collection, e.g. is this rule collection in this module used as general rule set for the firewall, other responsibilities would be the customer etc. | `string` | `"Platform"` | no |
## Outputs

No outputs.

## Resource types

| Type | Used |
|------|-------|
| [azurerm_firewall_policy_rule_collection_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | 1 |

**`Used` only includes resource blocks.** `for_each` and `count` meta arguments, as well as resource blocks of modules are not considered.

## Modules

No modules.

## Resources by Files

### main.tf

| Name | Type |
|------|------|
| [azurerm_firewall_policy_rule_collection_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
<!-- END_TF_DOCS -->

## Contribute

Please use Pull requests to contribute.

When a new Feature or Fix is ready to be released, create a new Github release and adhere to [Semantic Versioning 2.0.0](https://semver.org/lang/de/spec/v2.0.0.html).
