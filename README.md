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
This module is meant for use with Terraform 0.13+ and tested using Terraform 1.0+.
If you find incompatibilities using Terraform `>=0.13`, please open an issue.

If you haven't [upgraded][terraform-0.13-upgrade] and need a Terraform
0.12.x-compatible version of this module, the last released version
intended for Terraform 0.12.x is [v1.6.0](https://registry.terraform.io/modules/terraform-google-modules/-event-function/google/v1.6.0).

## Usage

The
[automatic-labelling-from-localhost example][automatic-labelling-from-localhost-example]
is a tested reference of how to use the root module with the
[event-project-log-entry submodule][event-project-log-entry-submodule].

## Terraform Created Source Files

If you have `local_file` Terraform resources that need to be included in the function's archive include them in the optional `source_dependent_files`.

This will tell the module to wait until those files exist before creating the archive.

Example can also be seen in `examples/dynamic-files`

```hcl
resource "local_file" "file" {
  content  = "some content"
  filename = "${path.module}/function_source/terraform_created_file.txt"
}

module "localhost_function" {
  ...

  source_dependent_files = [local_file.file]
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| available\_memory\_mb | The amount of memory in megabytes allotted for the function to use. | `number` | `256` | no |
| bucket\_force\_destroy | When deleting the GCS bucket containing the cloud function, delete all objects in the bucket first. | `bool` | `false` | no |
| bucket\_labels | A set of key/value label pairs to assign to the function source archive bucket. | `map(string)` | `{}` | no |
| bucket\_name | The name to apply to the bucket. Will default to a string of the function name. | `string` | `""` | no |
| build\_environment\_variables | A set of key/value environment variable pairs available during build time. | `map(string)` | `{}` | no |
| create\_bucket | Whether to create a new bucket or use an existing one. If false, `bucket_name` should reference the name of the alternate bucket to use. | `bool` | `true` | no |
| description | The description of the function. | `string` | `"Processes events."` | no |
| docker\_registry | Docker Registry to use for storing the function's Docker images. Allowed values are CONTAINER\_REGISTRY (default behavior) and ARTIFACT\_REGISTRY | `string` | `null` | no |
| docker\_repository | User managed repository created in Artifact Registry optionally with a customer managed encryption key. If specified, deployments will use Artifact Registry. This is the repository to which the function docker image will be pushed after it is built by Cloud Build. If unspecified, Container Registry will be used by default, unless specified otherwise by other means. | `string` | `null` | no |
| entry\_point | The name of a method in the function source which will be invoked when the function is executed. | `string` | n/a | yes |
| environment\_variables | A set of key/value environment variable pairs to assign to the function. | `map(string)` | `{}` | no |
| event\_trigger | A source that fires events in response to a condition in another service. | `map(string)` | `{}` | no |
| event\_trigger\_failure\_policy\_retry | A toggle to determine if the function should be retried on failure. | `bool` | `false` | no |
| files\_to\_exclude\_in\_source\_dir | Specify files to ignore when reading the source\_dir | `list(string)` | `[]` | no |
| ingress\_settings | The ingress settings for the function. Allowed values are ALLOW\_ALL, ALLOW\_INTERNAL\_AND\_GCLB and ALLOW\_INTERNAL\_ONLY. Changes to this field will recreate the cloud function. | `string` | `"ALLOW_ALL"` | no |
| kms\_key\_name | Resource name of a KMS crypto key (managed by the user) used to encrypt/decrypt function resources. It must match the pattern projects/{project}/locations/{location}/keyRings/{key\_ring}/cryptoKeys/{crypto\_key}. If specified, you must also provide an artifact registry repository using the docker\_repository field that was created with the same KMS crypto key. | `string` | `null` | no |
| labels | A set of key/value label pairs to assign to the Cloud Function. | `map(string)` | `{}` | no |
| log\_bucket | Log bucket | `string` | `null` | no |
| log\_object\_prefix | Log object prefix | `string` | `null` | no |
| max\_instances | The maximum number of parallel executions of the function. | `number` | `0` | no |
| name | The name to apply to any nameable resources. | `string` | n/a | yes |
| project\_id | The ID of the project to which resources will be applied. | `string` | n/a | yes |
| region | The region in which resources will be applied. | `string` | n/a | yes |
| runtime | The runtime in which the function will be executed. | `string` | n/a | yes |
| secret\_environment\_variables | A list of maps which contains key, project\_id, secret\_name (not the full secret id) and version to assign to the function as a set of secret environment variables. | `list(map(string))` | `[]` | no |
| service\_account\_email | The service account to run the function as. | `string` | `""` | no |
| source\_dependent\_files | A list of any Terraform created `local_file`s that the module will wait for before creating the archive. | <pre>list(object({<br>    filename = string<br>    id       = string<br>  }))</pre> | `[]` | no |
| source\_directory | The pathname of the directory which contains the function source code. | `string` | n/a | yes |
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

- [Terraform](https://www.terraform.io/downloads.html) >= 0.13.0
- [Terraform Provider for Archive][terraform-provider-archive-site]
- [Terraform Provider for Google Cloud Platform][terraform-provider-gcp-site]

### IAM Roles

The Service Account which will be used to invoke this module must have
the following IAM roles:

- Cloud Functions Developer: `roles/cloudfunctions.developer`
- Storage Admin: `roles/storage.admin`
- Secret Manager Accessor: `roles/secretmanager.secretAccessor`

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

- Cloud Functions API: `cloudfunctions.googleapis.com`
- Cloud Storage API: `storage-component.googleapis.com`
- Secret Manager API: `secretmanager.googleapis.com`

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
[terraform-0.13-upgrade]: https://www.terraform.io/upgrade-guides/0-13.html
