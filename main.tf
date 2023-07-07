resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "rcg-${var.responsibility}"
  firewall_policy_id = var.firewall_policy_id
  priority           = 100

  network_rule_collection {
    name     = "rc-DomainController-${var.stage}"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "allow-alz-to-dc-inbound"
      protocols             = ["TCP", "UDP"]
      source_ip_groups      = [var.ipg_application_lz_id]
      destination_ip_groups = var.ipg_onpremise_dc_id != null ? [var.ipg_azure_dc_id, ipg_onpremise_dc_id] : [var.ipg_azure_dc_id]
      destination_ports = [
        "53", "88", "123", "135", "137", "138", "139",
        "389", "445", "464", "636", "3268", "3269", "9389"
      ]
    }
  }

  network_rule_collection {
    name     = "rc-DNSPrivateResolver-${var.stage}"
    priority = 110
    action   = "Allow"

    rule {
      name                  = "allow-dc-to-dnsresolver-inbound"
      protocols             = ["Any"]
      source_ip_groups      = var.ipg_onpremise_dc_id != null ? [var.ipg_azure_dc_id, ipg_onpremise_dc_id] : [var.ipg_azure_dc_id]
      destination_ip_groups = [var.ipg_dnsprivateresolver_id]
      destination_ports     = ["*"]
    }
  }

  network_rule_collection {
    name     = "rc-internet_outbound-${var.stage}"
    priority = 120
    action   = "Allow"

    rule {
      name              = "allow-alz-to-kms-outbound"
      protocols         = ["TCP"]
      source_ip_groups  = var.ipg_onpremise_dc_id != null ? [var.ipg_application_lz_id, var.ipg_azure_dc_id, var.ipg_onpremise_dc_id] : [var.ipg_application_lz_id, var.ipg_azure_dc_id]
      destination_fqdns = ["kms.core.windows.net", "azkms.core.windows.net"]
      destination_ports = ["1688"]
    }

    rule {
      name                  = "allow-icmp_all-everywhere"
      protocols             = ["ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }

    rule {
      name             = "allow-backup-monitoring-outbound"
      protocols        = ["TCP"]
      source_ip_groups = var.ipg_onpremise_dc_id != null ? [var.ipg_application_lz_id, var.ipg_azure_dc_id, var.ipg_onpremise_dc_id] : [var.ipg_application_lz_id, var.ipg_azure_dc_id]
      destination_addresses = ["AzureBackup",
        "AzureMonitor",
        "AzureActiveDirectory",
        "Storage",
        "GuestAndHybridManagement"
      ]
      destination_ports = ["443"]
    }

    rule {
      name                  = "allow-update-management-outbound"
      protocols             = ["TCP"]
      source_ip_groups      = var.ipg_onpremise_dc_id != null ? [var.ipg_application_lz_id, var.ipg_azure_dc_id, var.ipg_onpremise_dc_id] : [var.ipg_application_lz_id, var.ipg_azure_dc_id]
      destination_addresses = ["AzureUpdateDelivery", "AzureFrontDoor.FirstParty"]
      destination_ports     = ["80", "443"]
    }
  }
}
