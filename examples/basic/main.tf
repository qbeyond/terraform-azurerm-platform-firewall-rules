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
  ipg_application_lz_id     = azurerm_ip_group.application_lz.id
  ipg_dnsprivateresolver_id = azurerm_ip_group.dnsprivateresolver.id
  ipg_platform_id           = azurerm_ip_group.platform.id
}
