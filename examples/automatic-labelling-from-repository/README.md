# Automatic Labelling from Repository

This example demonstrates how to use the
[repository-function submodule][repository-function-submodule] and the
[event-project-log-entry submodule][event-project-log-entry-submodule]
to configure a system
which responds to Compute VM creation events by labelling them with the
principal email address of the account responsible for causing the events.

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
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |
| region | The region in which resources will be applied. | string | n/a | yes |
| subnetwork | The name or self_link of the subnetwork to create compute instance in. | string | `""` | no |
| zone | The zone in which resources will be applied. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| compute\_instance\_name | The name of the unlabelled Compute instance. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

The following sections describe the requirements which must be met in
order to invoke this module. The
[repository-function submodule requirements][repository-function-submodule-requirements]
and the
[event-project-log-entry submodule requirements][event-project-log-entry-submodule-requirements]
must also be met.

### Software Dependencies

The following software dependencies must be installed on the system
from which this module will be invoked:

- [Terraform][terraform-site] v0.12

### IAM Roles

The Service Account which will be used to invoke this module must have
the following IAM roles:

- Compute Instance Admin (v1): `roles/compute.instanceAdmin.v1`
- Source Repository Admin: `roles/source.admin`

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

- Cloud Source Repositories API: `sourcerepo.googleapis.com`
- Compute Engine API: `compute.googleapis.com`

[event-project-log-entry-submodule-requirements]: ../../modules/event-project-log-entry/README.md#requirements
[event-project-log-entry-submodule]: ../../modules/event-project-log-entry
[repository-function-submodule-requirements]: ../../modules/repository-function/README.md#requirements
[repository-function-submodule]: ../../modules/repository-function
[terraform-site]: https://terraform.io/
