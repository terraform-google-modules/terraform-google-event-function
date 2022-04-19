# Automatic Labelling for folder projects

This example demonstrates how to use the
[root module][root-module] that will contain source
code files generated from Terraform itself and
environment variable stored in the Secrets Manager.

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

| Name | Description |
|------|-------------|
| function\_name | The name of the function created |
| project\_id | The project in which resources are applied. |
| random\_file\_string | The content of the terraform created file in the source directory. |
| random\_secret\_string | The value of the secret variable. |
| region | The region in which resources are applied. |

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

- [Terraform][terraform-site] v0.13

### IAM Roles

The Service Account which will be used to invoke this module must have
the following IAM roles:

- Logs Configuration Writer: `roles/logging.configWriter`
- Pub/Sub Admin: `roles/pubsub.admin`
- Service Account User: `roles/iam.serviceAccountUser`
- Secret Manager Admin: `roles/secretmanager.admin`

- Default AppSpot user: `roles/owner`
- Your user: `roles/resourcemanager.projectCreator`

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

- Cloud Pub/Sub API: `pubsub.googleapis.com`
- Stackdriver Logging API: `logging.googleapis.com`
- Secret Manager API: `secretmanager.googleapis.com`

[event-folder-log-entry-submodule-requirements]: ../../modules/event-folder-log-entry/README.md#requirements
[event-folder-log-entry-submodule]: ../../modules/event-folder-log-entry
[root-module-requirements]: ../../README.md#requirements
[root-module]: ../..
[terraform-site]: https://terraform.io/
