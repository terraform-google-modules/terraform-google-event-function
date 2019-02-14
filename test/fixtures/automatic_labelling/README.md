# Automatic Labelling

This test module invokes the
[Automatic Labelling example module][example-module] and
then creates an unlabelled Compute VM in order to test the automatic labelling
behaviour.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |
| region | The region in which resources will be applied. | string | n/a | yes |
| zone | The zone in which resources will be applied. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | The ID of the project to which resources are applied. |
| region | The region in which resources are applied. |
| zone | The zone in which resources are applied. |

[^]: (autogen_docs_end)

## Requirements

The following requirements must be met in order to invoke this module:

1. [IAM roles](#iam-roles).
1. [APIs](#apis).
1. [Example module requirements][example-module-requirements].

### IAM Roles

The Service Account which will be used to invoke this module must have the
following IAM roles:

- Compute Instance Admin

### APIs

The project against which this module will be invoked must have the following APIs enabled:

- Compute Engine API

The [Project Factory module][project-factory-module] can be used to provision projects with specific APIs activated.

[example-module]: ../../../examples/automatic_labelling
[example-module-requirements]: ../../../examples/automatic_labelling/README.md#Requirements
[project-factory-module]: https://github.com/terraform-google-modules/terraform-google-project-factory
