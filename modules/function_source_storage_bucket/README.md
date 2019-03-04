# function_source_storage_bucket

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| function\_source\_directory | The pathname of the directory which contains the function source code to be uploaded to the bucket. | string | n/a | yes |
| labels | A set of key/value label pairs to assign to the bucket. | map | `<map>` | no |
| name | The name to apply to any nameable resources. | string | n/a | yes |
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |
| region | The region in which resources will be applied. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| function\_source\_archive\_bucket | The name of the bucket which contains the source archive object. |
| function\_source\_archive\_object | The name of the object which is the function source archive. |

[^]: (autogen_docs_end)
