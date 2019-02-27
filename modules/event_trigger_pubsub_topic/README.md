# event_trigger_pubsub_topic

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The name to apply to any nameable resources. | string | n/a | yes |
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |
| publisher\_member | The identity which will be authorized to publish to the topic. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| event\_type | The type of event to trigger the Cloud Functions function. |
| name | The name of the topic. |
| uri | The universal resource identifier of the topic. |

[^]: (autogen_docs_end)
