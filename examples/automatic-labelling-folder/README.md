# Automatic Labelling for folder projects

This example demonstrates how to use the
[root module][root-module] and the
[event-folder-log-entry submodule][event-folder-log-entry-submodule]
to configure a system
which responds to project creation events by labelling them with test label.

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
| folder\_id | The ID of the folder to look for changes. | `string` | n/a | yes |
| project\_id | The ID of the project to which resources will be applied. | `string` | n/a | yes |
| region | The region in which resources will be applied. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | The ID of the project to which resources are applied. |
| region | The region in which resources are applied. |
| test\_project\_id | The ID of the project to test. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

The following sections describe the requirements which must be met in
order to invoke this module. The requirements of the
[root module][root-module-requirements] and the
[event-folder-log-entry submodule][event-folder-log-entry-submodule-requirements]
must also be met.

### Software Dependencies

The following software dependencies must be installed on the system
from which this module will be invoked:

- [Terraform][terraform-site] v0.12

### IAM Roles

The Service Account which will be used to invoke this module must have
the following IAM roles:

- Logs Configuration Writer: `roles/logging.configWriter`
- Pub/Sub Admin: `roles/pubsub.admin`
- Service Account User: `roles/iam.serviceAccountUser`

- Default AppSpot user: `roles/owner`
- Your user: `roles/resourcemanager.projectCreator`

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

- Cloud Pub/Sub API: `pubsub.googleapis.com`
- Stackdriver Logging API: `logging.googleapis.com`

[event-folder-log-entry-submodule-requirements]: ../../modules/event-folder-log-entry/README.md#requirements
[event-folder-log-entry-submodule]: ../../modules/event-folder-log-entry
[root-module-requirements]: ../../README.md#requirements
[root-module]: ../..
[terraform-site]: https://terraform.io/
