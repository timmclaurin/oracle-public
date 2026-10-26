provider "oci" {
  region = var.region
}

data "oci_identity_region_subscriptions" "home" {
  tenancy_id = var.tenancy_ocid

  filter {
    name   = "is_home_region"
    values = [true]
  }
}

locals {
  home_region = data.oci_identity_region_subscriptions.home.region_subscriptions[0].region_name
}

# IAM writes are accepted only in the home region.
provider "oci" {
  alias  = "home"
  region = local.home_region
}

resource "oci_identity_group" "workbench" {
  provider       = oci.home
  compartment_id = var.tenancy_ocid
  name           = "WorkbenchReadOnly"
  description    = "Project Workbench read-only access to Fusion environments"
}

resource "oci_identity_user" "workbench" {
  provider       = oci.home
  compartment_id = var.tenancy_ocid
  name           = "workbench-readonly"
  description    = "Project Workbench read-only scanner"
  email          = var.workbench_user_email == "" ? null : var.workbench_user_email
}

resource "oci_identity_user_group_membership" "workbench" {
  provider = oci.home
  group_id = oci_identity_group.workbench.id
  user_id  = oci_identity_user.workbench.id
}

resource "oci_identity_api_key" "workbench" {
  provider  = oci.home
  user_id   = oci_identity_user.workbench.id
  key_value = var.workbench_public_key
}

resource "oci_identity_policy" "workbench" {
  provider       = oci.home
  compartment_id = var.tenancy_ocid
  name           = "WorkbenchReadOnly"
  description    = "Project Workbench reads Fusion environments and lists compartments"
  statements     = jsondecode(file("${path.module}/statements.json"))

  # The statements name the group, so it has to exist before the policy.
  depends_on = [oci_identity_group.workbench]
}
