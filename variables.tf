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
  description = "The name of the rule collection group. If not provided it will name the group standarized Platform."
  default     = null
}

variable "stage" {
  type        = string
  description = "value"
}

variable "default_location" {
  type        = string
  description = "The default location used for this module."
  nullable    = false
}

variable "ip_address_az_dc" {
  type        = set(string)
  description = "value"
  validation {
    condition = alltrue(
      [for value in var.ip_address_az_dc : can(regex("^(\\d{1,3}[.]){3}(\\d{1,3}[/]\\d{1,3}){1}$", value))]
    )
    error_message = "The provided ip address does not match the syntax of ddd.ddd.ddd.ddd/ddd"
  }
}

#TODO:
variable "ip_address_onprem_dc" {
  type        = set(string)
  description = "value"
  validation {
    condition = alltrue(
      [for value in var.ip_address_onprem_dc : can(regex("^(\\d{1,3}[.]){3}(\\d{1,3}[/]\\d{1,3}){1}$", value))]
    )
    error_message = "The provided ip address does not match the syntax of ddd.ddd.ddd.ddd/ddd"
  }
}

variable "ip_address_alz" {
  type        = set(string)
  description = "value"
  validation {
    condition = alltrue(
      [for value in var.ip_address_alz : can(regex("^(\\d{1,3}[.]){3}(\\d{1,3}[/]\\d{1,3}){1}$", value))]
    )
    error_message = "The provided ip address does not match the syntax of ddd.ddd.ddd.ddd/ddd"
  }
}

variable "ip_address_DNSPrivateResolver" {
  type        = string
  description = "The ip address of the private dn resolver for the ip group."
  validation {
    condition     = can(regex("^(\\d{1,3}[.]){3}(\\d{1,3}[/]\\d{1,3}){1}$", var.ip_address_DNSPrivateResolver))
    error_message = "The provided ip address does not match the syntax of ddd.ddd.ddd.ddd/ddd"
  }
}
