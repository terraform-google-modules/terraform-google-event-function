# event_trigger_pubsub_topic

This submodule configures a Pub/Sub topic to be used as an event
trigger for the Cloud Functions function in the
[root module][root-module].

## Usage

The [automatic labelling example][automatic-labelling-example]
demonstrates how to use this module.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| labels | A set of key/value label pairs to assign to the topic. | map | `<map>` | no |
| name | The name to apply to the topic. | string | n/a | yes |
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |
| publisher\_member | The identity which will be authorized to publish to the topic. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| destination | The universal resource identifier of the topic. |
| event\_type | The type of event which will be observed by the function. |
| resource | The name of the topic from which the function will observe events. |

[^]: (autogen_docs_end)

## Requirements

The following requirements must be met in order to invoke this
submodule:

1. [IAM roles](#iam-roles).
1. [APIs](#apis).

### IAM Roles

The Service Account which will be used to invoke this module must have
the following IAM roles:

- Pub/Sub Admin

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

- Cloud Pub/Sub API

[root-module]: ../..
[automatic-labelling-example]: ../../examples/automatic_labelling
