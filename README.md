# Platform Firewall Rules

[![GitHub tag](https://img.shields.io/github/tag/qbeyond/terraform-azurerm-platform-firewall-rules.svg)](https://registry.terraform.io/modules/qbeyond/terraform-azurerm-platform-firewall-rules/provider/latest)
[![License](https://img.shields.io/github/license/qbeyond/terraform-azurerm-platform-firewall-rules.svg)](https://github.com/qbeyond/terraform-azurerm-platform-firewall-rules/blob/main/LICENSE)

---

This module creates a firewall rule collection group with standardized rules for platform. This includes rules from azure to azure services and exclude rules that are customer or q.beyond specific. The standard ist defined by the q.beyond AG.

<!-- BEGIN_TF_DOCS -->
## Usage

It's very easy to use!
```hcl
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example-fwp"
  location = local.location
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
  stage               = "tst"

  ipg_application_lz_id = azurerm_ip_group.application_lz.id
  ipg_platform_id       = azurerm_ip_group.platform.id
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.7.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ipg_application_lz_id"></a> [ipg\_application\_lz\_id](#input\_ipg\_application\_lz\_id) | IP ranges for all application landing zones. | `string` | n/a | yes |
| <a name="input_ipg_platform_id"></a> [ipg\_platform\_id](#input\_ipg\_platform\_id) | IP ranges for the whole platform service, defined by the azure landing zone core modules. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which the firewall policy and the azure firewall are located. | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | The stage that the resource is located in, e.g. prod, dev. | `string` | n/a | yes |
| <a name="input_bastion_config"></a> [bastion\_config](#input\_bastion\_config) | <pre>ipg_bastion_id: If the customer uses bastion, provide the bastion ip-group in this variable.<br/>  ipg_rdp_access_ids: If RDP access is needed, provide vm ip-groups in this variable. Every ip-group provided in this list, will be accessible by bastion via RDP.<br/>  ipg_ssh_access_ids: If SSH access is needed, provide vm ip-groups in this variable. Every ip-group provided in this list, will be accessible by bastion via SSH.</pre> | <pre>object({<br/>    ipg_bastion_id     = string<br/>    ipg_rdp_access_ids = optional(list(string), [])<br/>    ipg_ssh_access_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_firewall_policy_id"></a> [firewall\_policy\_id](#input\_firewall\_policy\_id) | For testing use this | `string` | `null` | no |
| <a name="input_ipg_azure_dc_id"></a> [ipg\_azure\_dc\_id](#input\_ipg\_azure\_dc\_id) | The ip addresses of the domain controller located in azure. If the value is not provided, this network rule collection will not be created. | `string` | `null` | no |
| <a name="input_ipg_dnsprivateresolver_id"></a> [ipg\_dnsprivateresolver\_id](#input\_ipg\_dnsprivateresolver\_id) | The ip address of the private dns resolver inbound endpoint. If the value is not provided, this network rule collection will not be created | `string` | `null` | no |
| <a name="input_ipg_entra_connect_id"></a> [ipg\_entra\_connect\_id](#input\_ipg\_entra\_connect\_id) | IP ranges for entra id connect VMs. | `string` | `null` | no |
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
