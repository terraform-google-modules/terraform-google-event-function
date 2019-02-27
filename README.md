# terraform-google-event-function

This module configures a system which responds to filtered Stackdriver
Logging events by invoking a Cloud Functions function.

A project-level Stackdriver Logging export uses a provided filter to
identify events of interest and publish them to a dedicated Pub/Sub
topic. A Cloud Functions function subscribes to the topic and uses
provided source code to process each event. The source code is
retrieved from an archive which is created locally and stored in a
Storage bucket.

## Usage

The [examples directory](examples) contains tested references of how to
use this module.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| function\_available\_memory\_mb | The amount of memory in megabytes allotted for the function to use. | string | `"256"` | no |
| function\_description | The description of the function. | string | `"Processes log export events provided through a Pub/Sub topic subscription."` | no |
| function\_entry\_point | The name of a method in the function source which will be invoked when the function is executed. | string | n/a | yes |
| function\_environment\_variables | A set of key/value environment variable pairs to assign to the function. | map | `<map>` | no |
| function\_event\_trigger\_failure\_policy\_retry | A toggle to determine if the function should be retried on failure. | string | `"false"` | no |
| function\_labels | A set of key/value label pairs to assign to the function. | map | `<map>` | no |
| function\_runtime | The runtime in which the function will be executed. | string | `"nodejs6"` | no |
| function\_source\_archive\_bucket\_labels | A set of key/value label pairs to assign to the function source archive bucket. | map | `<map>` | no |
| function\_source\_directory | The contents of this directory will be archived and used as the function source. | string | n/a | yes |
| function\_timeout\_s | The amount of time in seconds allotted for the execution of the function. | string | `"60"` | no |
| log\_export\_filter | The filter to apply when exporting logs to the Pub/Sub topic. | string | n/a | yes |
| name | The name to apply to any nameable resources. | string | n/a | yes |
| project\_id | The ID of the project to which resources will be applied. | string | n/a | yes |
| region | The region in which resources will be applied. | string | n/a | yes |

[^]: (autogen_docs_end)

## Requirements

The following requirements must be met in order to invoke this module:

1. [Software dependencies](#software-dependencies).
2. [IAM roles](#iam-roles).
3. [APIs](#apis).

### Software Dependencies

The following software dependencies must be installed on the system
from which this module will be invoked:

- [Terraform][terraform-site] v0.11.x
- [Google Terraform provider][terraform-provider-google-site] v1.20.0

### IAM Roles

The Service Account which will be used to invoke this module must have
the following IAM roles:

- Cloud Functions Developer
- Compute Viewer
- Logs Configuration Writer
- Pub/Sub Admin
- Service Account User
- Storage Admin

### APIs

The project against which this module will be invoked must have the
following APIs enabled:

- Cloud Functions API
- Cloud Pub/Sub API
- Google Cloud Storage

The [Project Factory module][project-factory-module-site] can be used to
provision projects with specific APIs activated.

## Testing

The [fixtures directory](test/fixtures) and
[integration directory](test/integration) comprise Terraform
modules and InSpec tests used to verify the behaviour of this module.

### Testing Software Dependencies

The following software dependencies must be installed on the system
from which the tests will be invoked:

- [Ruby][ruby-site] v2.5
- [Bundler][bundler-site] v1.17

### Integration Tests

Integration tests are invoked using [Kitchen][kitchen-site],
[Kitchen-Terraform][kitchen-terraform-site], and [InSpec][inspec-site].

Kitchen instances are configured in the
[Kitchen configuration file](kitchen.yml). The instances use the modules
in [fixtures directory](test/fixtures) to invoke identically named
modules in the [examples directory](examples) and test this module.

#### Integration Tests Configuration

Each Kitchen instance requires a variable file named `terraform.tfvars`
to be created and populated in the associated test fixture. For
convenience, a [sample variable file][sameple-variable-file] is
available.

A key file for a Service Account with the required
[IAM roles](#iam-roles) must be downloaded from the GCP console and
placed in the root directory of this repository. The key file must be
renamed to `credentials.json`.

#### Integration Tests Execution

Run `make test_integration_docker` to execute all of the Kitchen
instances in a non-interactive manner within a Docker container.

Alternatively, the Kitchen instances can be invoked interactively:

1. Run `make docker_run` to start the Docker container. The root
   directory of this repository will be mounted in the Docker container
   at `/cft/workdir/`.
1. Run `kitchen create` to initialize all Kitchen instances, or run
   `kitchen create <INSTANCE_NAME>` to initialize a specific Kitchen
   instance.
1. Run `kitchen converge` to apply all Kitchen instances, or run
   `kitchen converge <INSTANCE_NAME>` to apply a specific Kitchen
   instance.
1. Run `kitchen verify` to test all Kitchen instances, or run
   `kitchen verify <INSTANCE_NAME>` to test a specific Kitchen instance.
1. Run `kitchen destroy` to destroy all Kitchen instances, or run
   `kitchen destroy <INSTANCE_NAME>` to destroy a specific Kitchen
   instance.

## Linting

Linters are available for most of the filetypes in this repository.

### Linting Software Dependencies

The following software dependencies must be installed on the system
from which the linting will be invoked:

- [flake8][flake8-site].
- [ShellCheck][shellcheck-site].
- [terrafom validate][terraform-validate-site].

### Linting Execution

Run `make check --silent` to execute all of the linters.

Alternatively, the linters  can be invoked individually.

- Run `make check_python` to lint Python files.
- Run `make check_shell` to lint Shell files.
- Run `make check_terraform` to lint Terraform files.

## Documentation

The documentation of inputs and outputs for modules in this repository
is automatically generated in each module's `README.md` based on the
contents of the relevant `.tf` files.

### Documentation Software Dependencies

The following software dependencies must be installed on the system
from which the documentation will be generated:

- [terraform-docs][terraform-docs-site] v0.6.0

### Generation

Run `make generate_docs` to update the documentation.

[bundler-site]: https://bundler.io/
[flake8-site]: https://pypi.org/project/flake8/
[gofmt-site]: https://golang.org/cmd/gofmt/
[hadolint-site]: https://github.com/hadolint/hadolint/
[inspec-site]: https://inspec.io/
[kitchen-site]: https://kitchen.ci/
[kitchen-terraform-site]: https://github.com/newcontext-oss/kitchen-terraform/
[project-factory-module-site]: https://github.com/terraform-google-modules/terraform-google-project-factory/
[ruby-site]: https://ruby-lang.org/
[sample-variable-file]: test/fixtures/shared/terraform.tfvars.sample
[shellcheck-site]: https://www.shellcheck.net/
[terraform-docs-site]: https://github.com/segmentio/terraform-docs/releases/
[terraform-provider-google-site]: https://github.com/terraform-providers/terraform-provider-google/
[terraform-site]: https://www.terraform.io/
[terraform-validate-site]: https://www.terraform.io/docs/commands/validate.html
