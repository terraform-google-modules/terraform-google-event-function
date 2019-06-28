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
  type        = "string"
  default     = "256"
  description = "The amount of memory in megabytes allotted for the function to use."
}

variable "description" {
  type        = "string"
  default     = "Processes events."
  description = "The description of the function."
}

variable "entry_point" {
  type        = "string"
  description = "The name of a method in the function source which will be invoked when the function is executed."
}

variable "environment_variables" {
  type        = "map"
  default     = {}
  description = "A set of key/value environment variable pairs to assign to the function."
}

variable "event_trigger" {
  type        = "map"
  description = "A source that fires events in response to a condition in another service."
}

variable "labels" {
  type        = "map"
  default     = {}
  description = "A set of key/value label pairs to assign to the Cloud Function."
}

variable "name" {
  type        = "string"
  description = "The name to apply to any nameable resources."
}

variable "project_id" {
  type        = "string"
  description = "The ID of the project to which resources will be applied."
}

variable "region" {
  type        = "string"
  description = "The region in which resources will be applied."
}

variable "runtime" {
  type        = "string"
  description = "The runtime in which the function will be executed."
}

variable "source_directory" {
  type        = "string"
  description = "The pathname of the directory which contains the function source code."
}

variable "timeout_s" {
  type        = "string"
  default     = "60"
  description = "The amount of time in seconds allotted for the execution of the function."
}

variable "bucket_labels" {
  type        = "map"
  default     = {}
  description = "A set of key/value label pairs to assign to the function source archive bucket."
}

variable "service_account_email" {
  type        = "string"
  default     = ""
  description = "The service account to run the function as."
}

variable "bucket_name" {
  type        = "string"
  default     = ""
  description = "The name to apply to the bucket. Will default to a string of the function name."
}

variable "bucket_force_destroy" {
  type        = "string"
  default     = "false"
  description = "When deleting the GCS bucket containing the cloud function, delete all objects in the bucket first."
}

variable "event_trigger_failure_policy_retry" {
  type        = "string"
  default     = "false"
  description = "A toggle to determine if the function should be retried on failure."
}
