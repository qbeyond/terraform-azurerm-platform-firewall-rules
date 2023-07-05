resource "azurerm_ip_group" "ipg_azure_dc" {
  name                = "ipg-azure-dcs"
  location            = var.default_location
  resource_group_name = var.resource_group_name

  cidrs = var.ip_address_az_dc

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_ip_group" "ipg_onprem_dc" {
  name                = "ipg-onprem-dcs"
  location            = var.default_location
  resource_group_name = var.resource_group_name

  cidrs = var.ip_address_onprem_dc

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_ip_group" "ipg_DNSPrivateResolver" {
  name                = "ipg-DNSPrivateResolver"
  location            = var.default_location
  resource_group_name = var.resource_group_name

  cidrs = [var.ip_address_DNSPrivateResolver]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_ip_group" "ipg_aplication_lz" {
  name                = "ipg-application-landing-zone"
  location            = var.default_location
  resource_group_name = var.resource_group_name

  cidrs = var.ip_address_alz

  lifecycle {
    ignore_changes = [tags]
  }
}
