# Automatic Labelling

This example module invokes the [root module][root-module] to configure a system
which responds to Compute VM creation events by labelling them with the
principal email address of the account responsible for causing the events.

## Requirements

The following requirements must be met in order to invoke this module:

1. [IAM roles](#iam-roles).
1. [APIs](#apis).
1. [Root module requirements][root-module-requirements].

### IAM Roles

The Service Account which will be used to invoke this module requires no additional IAM roles.

### APIs

The project against which this module will be invoked requires no additional APIs enabled.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |
| region | The region in which resources will be applied. | string | n/a | yes |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

[root-module]: ../..
[root-module-requirements]: ../../README.md#requirements
