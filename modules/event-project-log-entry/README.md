# Event Project Log Entry

This submodule configures a project-level Stackdriver Logging export to
act as an event which will trigger a Cloud Functions function configured
by the [root module][root-module] or the
[repository-function submodule][repository-function].

The export uses a provided filter to identify events of interest and
publishes them to a dedicated Pub/Sub topic. The target function
must be configured to subscribe to the topic in order to process each
export event.

## Usage

The
[automatic-labelling-from-localhost example][automatic-labelling-from-localhost] is a tested reference of how to use this submodule with the
[root module][root-module].

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| filter | The filter to apply when exporting logs. | `string` | n/a | yes |
| labels | A set of key/value label pairs to assign to any labelable resources. | `map(string)` | `{}` | no |
| name | The name to apply to any nameable resources. | `string` | n/a | yes |
| parent\_resource\_type | The GCP resource in which you create the log sink. The value must not be computed, and must be one of the following: 'project', 'folder', 'billing\_account', or 'organization'. | `string` | `"project"` | no |
| project\_id | The ID of the project to which resources will be applied. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| function\_event\_trigger | The information used to trigger the function when a log entry is exported to the topic. |

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

- Logs Configuration Writer: `roles/logging.configWriter`
- Pub/Sub Admin: `roles/pubsub.admin`
- Service Account User: `roles/iam.serviceAccountUser`

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

- Cloud Pub/Sub API: `pubsub.googleapis.com`
- Stackdriver Logging API: `logging.googleapis.com`

[automatic-labelling-from-localhost]: ../../examples/automatic-labelling-from-localhost
[repository-function]: ../repository-function
[root-module]: ../..
[terraform-site]: https://www.terraform.io/
[terraform-provider-gcp-site]: https://github.com/terraform-providers/terraform-provider-google
