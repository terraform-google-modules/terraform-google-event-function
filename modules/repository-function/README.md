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
|------|-------------|------|---------|:--------:|
| available\_memory\_mb | The amount of memory in megabytes allotted for the function to use. | `number` | `256` | no |
| description | The description of the function. | `string` | `"Processes events."` | no |
| entry\_point | The name of a method in the function source which will be invoked when the function is executed. | `string` | n/a | yes |
| environment\_variables | A set of key/value environment variable pairs to assign to the function. | `map(string)` | `{}` | no |
| event\_trigger | A source that fires events in response to a condition in another service. | `map(string)` | `{}` | no |
| event\_trigger\_failure\_policy\_retry | A toggle to determine if the function should be retried on failure. | `bool` | `false` | no |
| ingress\_settings | The ingress settings for the function. Allowed values are ALLOW\_ALL, ALLOW\_INTERNAL\_AND\_GCLB and ALLOW\_INTERNAL\_ONLY. Changes to this field will recreate the cloud function. | `string` | `"ALLOW_ALL"` | no |
| labels | A set of key/value label pairs to assign to any lableable resources. | `map(string)` | `{}` | no |
| name | The name to apply to any nameable resources. | `string` | n/a | yes |
| operation\_timeouts | Timeout setting to customize how long certain operations(create, update, delete) are allowed to take before being considered to have failed. | `map(string)` | `{}` | no |
| project\_id | The ID of the project to which resources will be applied. | `string` | n/a | yes |
| region | The region in which resources will be applied. | `string` | n/a | yes |
| runtime | The runtime in which the function will be executed. | `string` | `"nodejs6"` | no |
| service\_account\_email | The service account to run the function as. | `string` | `""` | no |
| source\_repository\_url | The URL of the repository which contains the function source code. | `string` | n/a | yes |
| timeout\_s | The amount of time in seconds allotted for the execution of the function. | `number` | `60` | no |
| trigger\_http | Wheter to use HTTP trigger instead of the event trigger. | `bool` | `null` | no |
| vpc\_connector | The VPC Network Connector that this cloud function can connect to. It should be set up as fully-qualified URI. The format of this field is projects/\*/locations/\*/connectors/\*. | `string` | `null` | no |
| vpc\_connector\_egress\_settings | The egress settings for the connector, controlling what traffic is diverted through it. Allowed values are ALL\_TRAFFIC and PRIVATE\_RANGES\_ONLY. If unset, this field preserves the previously set value. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| https\_trigger\_url | URL which triggers function execution. |
| name | The name of the function. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

The following sections describe the requirements which must be met in
order to invoke this module.

### Software Dependencies

The following software dependencies must be installed on the system
from which this module will be invoked:

- [Terraform][terraform-site] v0.12
- [Terraform Provider for Google Cloud Platform][terraform-provider-gcp-site] v2.5

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
[terraform-provider-gcp-site]: https://github.com/terraform-providers/terraform-provider-google
