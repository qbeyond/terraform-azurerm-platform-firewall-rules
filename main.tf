resource "azurerm_firewall_policy_rule_collection_group" "policy_collection" {
  name               = "rcg-${local.responsibility}"
  firewall_policy_id = var.firewall_policy_id
  priority           = 100

  network_rule_collection {
    name     = "rc-DomainController-${var.stage}"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "rl-alz-to-dc-inbound"
      protocols             = ["TCP", "UDP"]
      source_ip_groups      = [azurerm_ip_group.ipg_aplication_lz.id]
      destination_ip_groups = [azurerm_ip_group.ipg_azure_dc.id, azurerm_ip_group.ipg_onprem_dc.id]
      destination_ports = [
        "53", "88", "123", "135", "137", "138", "139",
        "389", "445", "464", "636", "3268", "3269", "9389"
      ]
    }
  }

  network_rule_collection {
    name     = "rc-DNSPrivateResolver-${var.stage}"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "rl-dnsresolver-to-dc-inbound"
      protocols             = ["Any"]
      source_ip_groups      = [azurerm_ip_group.ipg_azure_dc.id]
      destination_ip_groups = [azurerm_ip_group.ipg_DNSPrivateResolver.id]
      destination_ports     = ["*"]
    }
  }

  network_rule_collection {
    name     = "rc-internet_outbound-${var.stage}"
    priority = 300
    action   = "Allow"

    rule {
      name              = "rl-alz-to-kms-outbound"
      protocols         = ["TCP"]
      source_ip_groups  = [azurerm_ip_group.ipg_aplication_lz.id]
      destination_fqdns = ["kms.core.windows.net", "azkms.core.windows.net"]
      destination_ports = ["1688"]
    }

    rule {
      name                  = "rl-icmp_all-outbound"
      protocols             = ["ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }

    rule {
      name             = "backup-monitoring-outbound"
      protocols        = ["TCP"]
      source_ip_groups = [azurerm_ip_group.ipg_aplication_lz.id]
      destination_addresses = ["AzureBackup",
        "AzureMonitor",
        "AzureActiveDirectory",
        "Storage",
        "GuestAndHybridManagement"
      ]
      destination_ports = ["443"]
    }

    rule {
      name                  = "update-management-outbound"
      protocols             = ["TCP"]
      source_ip_groups      = [azurerm_ip_group.ipg_aplication_lz.id]
      destination_addresses = ["AzureUpdateDelivery", "AzureFrontDoor.FirstParty"]
      destination_ports     = ["80", "443"]
    }
  }
}
