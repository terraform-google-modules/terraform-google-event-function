# event_source_logging_project_sink

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| destination | The destination of the sink. | string | n/a | yes |
| filter | The filter to apply when exporting logs. | string | n/a | yes |
| name | The name to apply to any nameable resources. | string | n/a | yes |
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the sink. |
| writer\_identity | The identity associated with the sink which must be authorized to write to the destination. |

[^]: (autogen_docs_end)
