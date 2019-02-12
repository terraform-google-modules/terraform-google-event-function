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

provider "archive" {
  version = "~> 1.1"
}

provider "google" {
  version = "~> 1.20"
}

provider "random" {
  version = "~> 2.0"
}

resource "random_pet" "main" {
  separator = "-"
}

module "event_function" {
  source = "../../"

  function_available_memory_mb = "128"
  function_description         = "Labels resource with owner information."
  function_entry_point         = "labelResource"

  function_environment_variables = {
    LABEL_KEY = "principal-email"
  }

  function_event_trigger_failure_policy_retry = "true"

  function_labels {
    module = "simple-example"
  }

  function_runtime = "nodejs6"

  function_source_archive_bucket_labels {
    module = "simple-example"
  }

  function_source_archive_bucket_location = "US-EAST1"
  function_source_directory               = "${path.module}/function_source"
  function_timeout_s                      = "30"

  log_export_filter = "${
    join(
      " AND ",
      list(
        "protoPayload.@type=\"type.googleapis.com/google.cloud.audit.AuditLog\"",
        "protoPayload.methodName:insert",
        "operation.first=true",
      )
    )
  }"

  name       = "${random_pet.main.id}"
  project_id = "${var.project_id}"
  region     = "${var.region}"
}
