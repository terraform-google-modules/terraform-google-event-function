# Event Function

This module configures a system which responds to events by invoking a
Cloud Functions function.

The root module configures a function sourced from a directory on
localhost to respond to a given event trigger. The source directory is
compressed and uploaded as a Cloud Storage bucket object which will be
leveraged by the function.

Alternatively, the
[repository-function submodule][repository-function-submodule]
configures a function sourced from a Cloud Source Repositories
repository.

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't [upgraded](https://www.terraform.io/upgrade-guides/0-12.html) and need a Terraform 0.11.x-compatible version of this module, the last released version intended for Terraform 0.11.x
is [0.1.0](https://registry.terraform.io/modules/terraform-google-modules/event-function/google/0.1.0).


## Usage

The
[automatic-labelling-from-localhost example][automatic-labelling-from-localhost-example]
is a tested reference of how to use the root module with the
[event-project-log-entry submodule][event-project-log-entry-submodule].

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| available\_memory\_mb | The amount of memory in megabytes allotted for the function to use. | number | `"256"` | no |
| bucket\_force\_destroy | When deleting the GCS bucket containing the cloud function, delete all objects in the bucket first. | bool | `"false"` | no |
| bucket\_labels | A set of key/value label pairs to assign to the function source archive bucket. | map(string) | `<map>` | no |
| bucket\_name | The name to apply to the bucket. Will default to a string of the function name. | string | `""` | no |
| description | The description of the function. | string | `"Processes events."` | no |
| entry\_point | The name of a method in the function source which will be invoked when the function is executed. | string | n/a | yes |
| environment\_variables | A set of key/value environment variable pairs to assign to the function. | map(string) | `<map>` | no |
| event\_trigger | A source that fires events in response to a condition in another service. | map(string) | n/a | yes |
| event\_trigger\_failure\_policy\_retry | A toggle to determine if the function should be retried on failure. | bool | `"false"` | no |
| labels | A set of key/value label pairs to assign to the Cloud Function. | map(string) | `<map>` | no |
| name | The name to apply to any nameable resources. | string | n/a | yes |
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |
| region | The region in which resources will be applied. | string | n/a | yes |
| runtime | The runtime in which the function will be executed. | string | n/a | yes |
| service\_account\_email | The service account to run the function as. | string | `""` | no |
| source\_directory | The pathname of the directory which contains the function source code. | string | n/a | yes |
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
- [Terraform Provider for Archive][terraform-provider-archive-site]
  v1.2
- [Terraform Provider for Google Cloud Platform][terraform-provider-gcp-site] v2.5

### IAM Roles

The Service Account which will be used to invoke this module must have
the following IAM roles:

- Cloud Functions Developer: `roles/cloudfunctions.developer`
- Storage Admin: `roles/storage.admin`

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

- Cloud Functions API: `cloudfunctions.googleapis.com`
- Cloud Storage API: `storage-component.googleapis.com`

The [Project Factory module][project-factory-module-site] can be used to
provision projects with specific APIs activated.

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[automatic-labelling-from-localhost-example]: examples/automatic-labelling-from-localhost
[event-project-log-entry-submodule]: modules/event-project-log-entry
[repository-function-submodule]: modules/repository-function
[project-factory-module-site]: https://github.com/terraform-google-modules/terraform-google-project-factory/
[terraform-provider-gcp-site]: https://github.com/terraform-providers/terraform-provider-google/
[terraform-site]: https://www.terraform.io/
