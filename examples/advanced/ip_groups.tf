resource "azurerm_ip_group" "azure_dc" {
  name                = "ipg-azure-dcs"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  cidrs = ["10.0.0.10/32", "10.0.0.11/32"]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_ip_group" "onpremise_dc" {
  name                = "ipg-onprem-dcs"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  cidrs = []

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_ip_group" "dnsprivateresolver" {
  name                = "ipg-DNSPrivateResolver"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  cidrs = ["10.0.1.0/24"]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_ip_group" "application_lz" {
  name                = "ipg-application-landing-zone"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  cidrs = ["10.0.2.0/24"]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_ip_group" "platform" {
  name                = "ipg-platform"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  cidrs = ["10.0.2.0/24"]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_ip_group" "bastion" {
  name                = "ipg-bastion"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name

  cidrs = ["10.0.2.0/24"]

  lifecycle {
    ignore_changes = [tags]
  }
}