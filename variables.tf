/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "available_memory_mb" {
  type        = number
  default     = 256
  description = "The amount of memory in megabytes allotted for the function to use."
}

variable "description" {
  type        = string
  default     = "Processes events."
  description = "The description of the function."
}

variable "entry_point" {
  type        = string
  description = "The name of a method in the function source which will be invoked when the function is executed."
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "A set of key/value environment variable pairs to assign to the function."
}

variable "event_trigger" {
  type        = map(string)
  default     = {}
  description = "A source that fires events in response to a condition in another service."
}

variable "trigger_http" {
  type        = bool
  default     = null
  description = "Wheter to use HTTP trigger instead of the event trigger."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the Cloud Function."
}

variable "name" {
  type        = string
  description = "The name to apply to any nameable resources."
}

variable "project_id" {
  type        = string
  description = "The ID of the project to which resources will be applied."
}

variable "region" {
  type        = string
  description = "The region in which resources will be applied."
}

variable "runtime" {
  type        = string
  description = "The runtime in which the function will be executed."
}

variable "secret_environment_variables" {
  type        = list(map(string))
  default     = []
  description = "A list of maps which contains key, project_id, secret_name (not the full secret id) and version to assign to the function as a set of secret environment variables."
}

variable "source_directory" {
  type        = string
  description = "The pathname of the directory which contains the function source code."
}

variable "source_dependent_files" {
  type = list(object({
    filename = string
    id       = string
  }))
  description = "A list of any Terraform created `local_file`s that the module will wait for before creating the archive."
  default     = []
}

variable "files_to_exclude_in_source_dir" {
  type        = list(string)
  description = "Specify files to ignore when reading the source_dir"
  default     = []
}

variable "timeout_s" {
  type        = number
  default     = 60
  description = "The amount of time in seconds allotted for the execution of the function."
}

variable "max_instances" {
  type        = number
  default     = 0
  description = "The maximum number of parallel executions of the function."
}

variable "bucket_labels" {
  type        = map(string)
  default     = {}
  description = "A set of key/value label pairs to assign to the function source archive bucket."
}

variable "service_account_email" {
  type        = string
  default     = ""
  description = "The service account to run the function as."
}

variable "build_service_account" {
  type        = string
  default     = ""
  description = "The self-provided service account to use to build the function. The format of this field is projects/{project}/serviceAccounts/{serviceAccountEmail}"
}

variable "bucket_name" {
  type        = string
  default     = ""
  description = "The name to apply to the bucket. Will default to a string of the function name."
}

variable "create_bucket" {
  type        = bool
  default     = true
  description = "Whether to create a new bucket or use an existing one. If false, `bucket_name` should reference the name of the alternate bucket to use."
}

variable "bucket_force_destroy" {
  type        = bool
  default     = false
  description = "When deleting the GCS bucket containing the cloud function, delete all objects in the bucket first."
}

variable "event_trigger_failure_policy_retry" {
  type        = bool
  default     = false
  description = "A toggle to determine if the function should be retried on failure."
}

variable "ingress_settings" {
  type        = string
  default     = "ALLOW_ALL"
  description = "The ingress settings for the function. Allowed values are ALLOW_ALL, ALLOW_INTERNAL_AND_GCLB and ALLOW_INTERNAL_ONLY. Changes to this field will recreate the cloud function."
}

variable "vpc_connector_egress_settings" {
  type        = string
  default     = null
  description = "The egress settings for the connector, controlling what traffic is diverted through it. Allowed values are ALL_TRAFFIC and PRIVATE_RANGES_ONLY. If unset, this field preserves the previously set value."
}

variable "vpc_connector" {
  type        = string
  default     = null
  description = "The VPC Network Connector that this cloud function can connect to. It should be set up as fully-qualified URI. The format of this field is projects/*/locations/*/connectors/*."
}

variable "log_bucket" {
  type        = string
  default     = null
  description = "Log bucket"
}

variable "log_object_prefix" {
  type        = string
  default     = null
  description = "Log object prefix"
}

variable "build_environment_variables" {
  type        = map(string)
  default     = {}
  description = "A set of key/value environment variable pairs available during build time."
}

variable "docker_registry" {
  type        = string
  default     = null
  description = "Docker Registry to use for storing the function's Docker images. Allowed values are CONTAINER_REGISTRY (default) and ARTIFACT_REGISTRY."
}

variable "docker_repository" {
  type        = string
  default     = null
  description = "User managed repository created in Artifact Registry optionally with a customer managed encryption key. If specified, deployments will use Artifact Registry."
}


variable "kms_key_name" {
  type        = string
  default     = null
  description = "Resource name of a KMS crypto key (managed by the user) used to encrypt/decrypt function resources."
}
