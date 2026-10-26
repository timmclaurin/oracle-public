# OCI read-only onboarding stack

An Oracle Cloud Infrastructure Resource Manager stack that gives CherryRoad Workbench read-only access to your Fusion environments.

## What it creates

All resources are created in your tenancy's home region:

- Group `WorkbenchReadOnly`
- User `workbench-readonly`, added to that group
- An API key on that user, made from the Workbench public key you paste in
- Policy `WorkbenchReadOnly` with two statements:
  - `Allow group WorkbenchReadOnly to read fusion-family in tenancy`
  - `Allow group WorkbenchReadOnly to inspect compartments in tenancy`

## Only a public key

The stack takes only a PEM **public** key, and the input check rejects anything that contains `PRIVATE KEY`. It doesn't hold, create, or output any private key or password. Its outputs are the tenancy OCID, the user OCID, the key fingerprint, and the home region.

## Deploy

Download `oci-readonly-stack.zip` from the latest release. In the OCI Console, open **Resource Manager > Stacks > Create stack**, upload the zip, paste your public key, then run **Apply**.

## Revoke access

Open the stack in Resource Manager and run **Destroy**. That deletes the policy, the API key, the user, and the group, which ends Workbench's access.
