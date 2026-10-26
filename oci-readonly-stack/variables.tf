variable "tenancy_ocid" {
  type        = string
  description = "Tenancy OCID. Resource Manager fills it in."
}

variable "region" {
  type        = string
  description = "Region the stack runs in. Resource Manager fills it in."
}

variable "workbench_public_key" {
  type        = string
  description = "The public key from the Project Workbench customer pods page."

  validation {
    condition     = can(regex("-----BEGIN PUBLIC KEY-----", var.workbench_public_key)) && !can(regex("PRIVATE KEY", var.workbench_public_key))
    error_message = "Paste the PEM public key from Project Workbench, not a private key."
  }
}

variable "workbench_user_email" {
  type        = string
  default     = ""
  description = "Email for the workbench-readonly user. Leave empty unless your identity domain requires one."
}
