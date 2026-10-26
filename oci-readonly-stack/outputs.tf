output "tenancy_ocid" {
  value = var.tenancy_ocid
}

output "user_ocid" {
  value = oci_identity_user.workbench.id
}

output "fingerprint" {
  value = oci_identity_api_key.workbench.fingerprint
}

output "home_region" {
  value = local.home_region
}
