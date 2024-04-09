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

  responsibility   = "Platform"
  stage            = "prd"
  default_location = local.location

  ipg_dnsprivateresolver_id = azurerm_ip_group.dnsprivateresolver.id
  ipg_azure_dc_id           = azurerm_ip_group.azure_dc.id
  ipg_application_lz_id     = azurerm_ip_group.application_lz.id
  ipg_platform_id           = azurerm_ip_group.platform.id
  bastion_config = {
    ipg_bastion_id     = azurerm_ip_group.bastion.id
    ipg_rdp_access_ids = [azurerm_ip_group.application_lz.id]
    ipg_ssh_access_ids = [azurerm_ip_group.application_lz.id]
  }
}
