# Automatic Labelling from Localhost

This example demonstrates how to use the
[root module][root-module] and the
[event-project-log-entry submodule][event-project-log-entry-submodule]
to configure a system
which responds to Compute VM creation events by deleting any VM instances created with disks not encrypted using a customer-managed encryption key.

## Usage

To provision this example, populate `terraform.tfvars` with the [required variables](#inputs) and run the following commands within
this directory:

- `terraform init` to initialize the directory
- `terraform plan` to generate the execution plan
- `terraform apply` to apply the execution plan
- `terraform destroy` to destroy the infrastructure

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The ID of the project to which resources will be applied. | `string` | n/a | yes |
| region | The region in which resources will be applied. | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

The following sections describe the requirements which must be met in
order to invoke this module. The requirements of the
[root module][root-module-requirements] and the
[event-project-log-entry submodule][event-project-log-entry-submodule-requirements]
must also be met.

### Software Dependencies

The following software dependencies must be installed on the system
from which this module will be invoked:

- [Terraform][terraform-site] v0.12

### IAM Roles

The Service Account which will be used to invoke this module must have
the following IAM roles:

- Pub/Sub Admin: `roles/pubsub.admin`
- Storage Admin: `roles/storage.admin`
- Cloud Functions Developer: `roles/cloudfunctions.developer`
- Logging Config Writer: `roles/logging.configWriter`

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

- Compute Engine API: `compute.googleapis.com`

[event-project-log-entry-submodule-requirements]: ../../modules/event-project-log-entry/README.md#requirements
[event-project-log-entry-submodule]: ../../modules/event-project-log-entry
[root-module-requirements]: ../../README.md#requirements
[root-module]: ../..
[terraform-site]: https://terraform.io/
