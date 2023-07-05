variable "firewall_policy_id" {
  type        = string
  description = "For testing use this"
  default     = null
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the firewall policy and the azure firewall are located."
  nullable    = false
}

variable "responsibility" {
  type        = string
  description = "The responsibility means who is responsible for the rule collection, e.g. is this rule collection in this module used as general rule set for the firewall, other responsibilities would be the customer etc."
  default     = "Platform"
}

variable "stage" {
  type        = string
  description = "The stage that the resource is located in, e.g. prod, dev."
}

variable "default_location" {
  type        = string
  description = "The default location used for this module."
  nullable    = false
}

variable "ip_address_azure_dc" {
  type        = set(string)
  description = "The ip addresses of the domain controller located in azure. As standard the alz should only located in azure."
  validation {
    condition = alltrue(
      [for value in var.ip_address_az_dc : can(regex("^(\\d{1,3}[.]){3}(\\d{1,3}[/]\\d{1,3}){1}$", value))]
    )
    error_message = "The provided ip address does not match the syntax of ddd.ddd.ddd.ddd/ddd"
  }
}

variable "ip_address_onpremises_dc" {
  type        = set(string)
  description = "If the customer still operates domain controller on premise, provide these in this variable."
  validation {
    condition = alltrue(
      [for value in var.ip_address_onprem_dc : can(regex("^(\\d{1,3}[.]){3}(\\d{1,3}[/]\\d{1,3}){1}$", value))]
    )
    error_message = "The provided ip address does not match the syntax of ddd.ddd.ddd.ddd/ddd"
  }
}

variable "ip_address_alz" {
  type        = set(string)
  description = "The application landing zone are ip ranges of applications that need to be added to the firewall rule set."
  validation {
    condition = alltrue(
      [for value in var.ip_address_alz : can(regex("^(\\d{1,3}[.]){3}(\\d{1,3}[/]\\d{1,3}){1}$", value))]
    )
    error_message = "The provided ip address does not match the syntax of ddd.ddd.ddd.ddd/ddd"
  }
}

variable "ip_address_dnsprivateresolver" {
  type        = string
  description = "The ip address of the private dns resolver for the ip group."
  validation {
    condition     = can(regex("^(\\d{1,3}[.]){3}(\\d{1,3}[/]\\d{1,3}){1}$", var.ip_address_DNSPrivateResolver))
    error_message = "The provided ip address does not match the syntax of ddd.ddd.ddd.ddd/ddd"
  }
}
