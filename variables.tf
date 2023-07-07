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

variable "ipg_azure_dc_id" {
  type        = string
  description = "The ip addresses of the domain controller located in azure."
}

variable "ipg_onpremise_dc_id" {
  type        = string
  description = "If the customer still operates domain controller on premise, provide these in this variable."
  default     = null
}

variable "ipg_dnsprivateresolver_id" {
  type        = string
  description = "The ip address of the private dns resolver inbound endpoint."
}

variable "ipg_application_lz_id" {
  type        = string
  description = "IP ranges for all application landing zones."
}
