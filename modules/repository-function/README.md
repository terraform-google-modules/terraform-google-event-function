# Repository Function

This submodule configures a function sourced from a Cloud Source
Repositories repository to respond to a given event trigger.

Alternatively, the [root module][root-module] configures a function
sourced from a directory on localhost.

## Usage

The
[automatic-labelling-from-repository example][automatic-labelling-from-repository-example]
is a tested reference of how to use this submodule with the
[event-project-log-entry submodule][event-project-log-entry-submodule].

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| available\_memory\_mb | The amount of memory in megabytes allotted for the function to use. | number | `"256"` | no |
| description | The description of the function. | string | `"Processes events."` | no |
| entry\_point | The name of a method in the function source which will be invoked when the function is executed. | string | n/a | yes |
| environment\_variables | A set of key/value environment variable pairs to assign to the function. | map(string) | `<map>` | no |
| event\_trigger | A source that fires events in response to a condition in another service. | map(string) | n/a | yes |
| labels | A set of key/value label pairs to assign to any lableable resources. | map(string) | `<map>` | no |
| name | The name to apply to any nameable resources. | string | n/a | yes |
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |
| region | The region in which resources will be applied. | string | n/a | yes |
| runtime | The runtime in which the function will be executed. | string | `"nodejs6"` | no |
| source\_repository\_url | The URL of the repository which contains the function source code. | string | n/a | yes |
| timeout\_s | The amount of time in seconds allotted for the execution of the function. | number | `"60"` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | The name of the function. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

The following sections describe the requirements which must be met in
order to invoke this module.

### Software Dependencies

The following software dependencies must be installed on the system
from which this module will be invoked:

- [Terraform][terraform-site] v0.12
- [Terraform Provider for Google Cloud Platform][terraformm-provider-gcp-site] v2.5

### IAM Roles

The Service Account which will be used to invoke this module must have
the following IAM roles:

- Cloud Functions Developer: `roles/cloudfunctions.developer`

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

- Cloud Functions API: `cloudfunctions.googleapis.com`

[root-module]: ../..
[automatic-labelling-from-repository-example]: ../../examples/automatic-labelling-from-repository
[event-project-log-entry-submodule]: ../event-project-log-entry
[terraform-site]: https://www.terraform.io/
[terraformm-provider-gcp-site]: https://github.com/terraform-providers/terraform-provider-google
