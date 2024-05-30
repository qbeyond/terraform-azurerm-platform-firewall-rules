resource "azurerm_firewall_policy_rule_collection_group" "this" {
  name               = "rcg-${var.responsibility}"
  firewall_policy_id = var.firewall_policy_id
  priority           = 100

  network_rule_collection {
    name     = "rc-internet_outbound-${var.stage}"
    priority = 100
    action   = "Allow"

    rule {
      name              = "allow-alz-to-kms-outbound"
      protocols         = ["TCP"]
      source_ip_groups  = [var.ipg_application_lz_id, var.ipg_platform_id]
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
      source_ip_groups = [var.ipg_application_lz_id, var.ipg_platform_id]
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
      source_ip_groups      = [var.ipg_application_lz_id, var.ipg_platform_id]
      destination_addresses = ["AzureUpdateDelivery", "AzureFrontDoor.FirstParty"]
      destination_ports     = ["80", "443"]
    }
  }

  dynamic "network_rule_collection" {
    for_each = var.ipg_azure_dc_id == null ? [] : [var.ipg_azure_dc_id]
    content {
      name     = "rc-DomainController-${var.stage}"
      priority = 105
      action   = "Allow"

      rule {
        name                  = "allow-alz-to-dc-inbound"
        protocols             = ["TCP", "UDP"]
        source_ip_groups      = [var.ipg_application_lz_id]
        destination_ip_groups = var.ipg_onpremise_dc_id != null ? [var.ipg_azure_dc_id, var.ipg_onpremise_dc_id] : [var.ipg_azure_dc_id]
        destination_ports = [
          "53", "88", "123", "135", "137", "138", "139",
          "389", "445", "464", "636", "3268", "3269", "9389", "49152-65535"
        ]
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = var.ipg_dnsprivateresolver_id == null ? [] : [var.ipg_dnsprivateresolver_id]
    content {
      name     = "rc-DNSPrivateResolver-${var.stage}"
      priority = 110
      action   = "Allow"

      rule {
        name                  = "allow-dc-to-dnsresolver-inbound"
        protocols             = ["UDP", "TCP"]
        source_ip_groups      = var.ipg_onpremise_dc_id != null ? [var.ipg_azure_dc_id, var.ipg_onpremise_dc_id] : [var.ipg_azure_dc_id]
        destination_ip_groups = [var.ipg_dnsprivateresolver_id]
        destination_ports     = ["53"]
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = var.bastion_config == null ? [] : [var.bastion_config.ipg_bastion_id]
    content {
      name     = "rc-Bastion-${var.stage}"
      priority = 115
      action   = "Allow"

      dynamic "rule" {
        for_each = var.bastion_config.ipg_rdp_access_ids
        content {
          # The regex outputs the name of the ip group from id.
          name                  = "allow-bastion-to-${regex(".+\\/(.+)?", rule.value)[0]}-rdp"
          protocols             = ["TCP"]
          source_ip_groups      = [network_rule_collection.value]
          destination_ip_groups = [rule.value]
          destination_ports     = ["3389"]
        }
      }

      dynamic "rule" {
        for_each = var.bastion_config.ipg_ssh_access_ids
        content {
          # The regex outputs the name of the ip group from id.
          name                  = "allow-bastion-to-${regex(".+\\/(.+)?", rule.value)[0]}-ssh"
          protocols             = ["TCP"]
          source_ip_groups      = [network_rule_collection.value]
          destination_ip_groups = [rule.value]
          destination_ports     = ["22"]
        }
      }
    }
  }

  application_rule_collection {
    name     = "rc-application_internet_outbound-${var.stage}"
    priority = 150
    action   = "Allow"

    rule {
      name                  = "allow-update-management-outbound"
      source_ip_groups      = [var.ipg_application_lz_id, var.ipg_platform_id]
      destination_fqdn_tags = ["WindowsUpdate"]
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
    }

    rule {
      name             = "allow-certificate-verification-outbound"
      source_ip_groups = [var.ipg_application_lz_id, var.ipg_platform_id]
      destination_fqdns = [
        "mscrl.microsoft.com",
        "*.verisign.com",
        "*.entrust.net",
        "crl3.digicert.com",
        "*.crl3.digicert.com",
        "crl4.digicert.com",
        "*.crl4.digicert.com",
        "*.digicert.cn",
        "ocsp.digicert.com",
        "*.ocsp.digicert.com",
        "*.www.d-trust.net",
        "*.root-c3-ca2-2009.ocsp.d-trust.net",
        "*.crl.microsoft.com",
        "*.oneocsp.microsoft.com",
        "*.ocsp.msocsp.com"
      ]
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  dynamic "application_rule_collection" {
    for_each = var.ipg_entra_connect_id == null ? [] : [var.ipg_entra_connect_id]
    content {
      name     = "rc-application_entra_connect_outbound-${var.stage}"
      priority = 155
      action   = "Allow"

      rule {
        name             = "allow-entra-connect-outbound"
        source_ip_groups = [var.ipg_entra_connect_id]
        destination_fqdns = [
          "*.management.core.windows.net",
          "*.graph.windows.net",
          "secure.aadcdn.microsoftonline-p.com",
          "*.microsoftonline.com",
          "*.blob.core.windows.net",
          "*.aadconnecthealth.azure.com",
          "*.adhybridhealth.azure.com",
          "management.azure.com",
          "policykeyservice.dc.ad.msft.net",
          "login.windows.net",
          "www.office.com", # Used for discovery purposes during registration
          "aadcdn.msftauth.net",
          "aadcdn.msauth.net",
          "autoupdate.msappproxy.net",
          "www.microsoft.com",
          "*.registration.msappproxy.net",       # used for SSO registration
          "*.passwordreset.microsoftonline.com", # used for password writeback
          "*.servicebus.windows.net"             # used for password writeback
        ]
        protocols {
          type = "Http"
          port = 80
        }
        protocols {
          type = "Https"
          port = 443
        }
      }
    }
  }
}
