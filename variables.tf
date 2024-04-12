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

variable "ipg_azure_dc_id" {
  type        = string
  description = "The ip addresses of the domain controller located in azure. If the value is not provided, this network rule collection will not be created."
  default     = null
}

variable "ipg_onpremise_dc_id" {
  type        = string
  description = "If the customer still operates domain controller on premise, provide these in this variable."
  default     = null
}

variable "ipg_dnsprivateresolver_id" {
  type        = string
  description = "The ip address of the private dns resolver inbound endpoint. If the value is not provided, this network rule collection will not be created"
  default     = null
}

variable "ipg_application_lz_id" {
  type        = string
  description = "IP ranges for all application landing zones."
}

variable "ipg_platform_id" {
  type        = string
  description = "IP ranges for the whole platform service, defined by the azure landing zone core modules."
}

variable "bastion_config" {
  type = object({
    ipg_bastion_id = string
    ipg_rdp_access_ids = optional(list(string), [])
    ipg_ssh_access_ids = optional(list(string), [])
  })
  default = null 
  description = <<-DOC
  ```
    ipg_bastion_id: If the customer uses bastion, provide the bastion ip-group in this variable.
    ipg_rdp_access_ids: If RDP access is needed, provide vm ip-groups in this variable. Every ip-group provided in this list, will be accessible by bastion via RDP.
    ipg_ssh_access_ids: If SSH access is needed, provide vm ip-groups in this variable. Every ip-group provided in this list, will be accessible by bastion via SSH.     
  ```
  DOC
}