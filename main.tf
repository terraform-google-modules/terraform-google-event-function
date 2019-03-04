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

resource "google_cloudfunctions_function" "source_archive" {
  count = "${
    var.source_archive_bucket != "" && var.source_archive_object != "" && var.source_repository_url == "" ? 1 : 0
  }"

  name                = "${var.name}"
  description         = "${var.function_description}"
  available_memory_mb = "${var.function_available_memory_mb}"
  timeout             = "${var.function_timeout_s}"
  entry_point         = "${var.function_entry_point}"

  event_trigger {
    event_type = "${var.function_event_trigger_event_type}"
    resource   = "${var.function_event_trigger_resource}"

    failure_policy {
      retry = "${var.function_event_trigger_failure_policy_retry}"
    }
  }

  labels                = "${var.function_labels}"
  runtime               = "${var.function_runtime}"
  environment_variables = "${var.function_environment_variables}"
  source_archive_bucket = "${var.source_archive_bucket}"
  source_archive_object = "${var.source_archive_object}"
  project               = "${var.project_id}"
  region                = "${var.region}"
}

resource "google_cloudfunctions_function" "source_repository" {
  count = "${
    var.source_repository_url != "" && var.source_archive_bucket == "" && var.source_archive_object == "" ? 1 : 0
  }"

  name                = "${var.name}"
  description         = "${var.function_description}"
  available_memory_mb = "${var.function_available_memory_mb}"
  timeout             = "${var.function_timeout_s}"
  entry_point         = "${var.function_entry_point}"

  event_trigger {
    event_type = "${var.function_event_trigger_event_type}"
    resource   = "${var.function_event_trigger_resource}"

    failure_policy {
      retry = "${var.function_event_trigger_failure_policy_retry}"
    }
  }

  labels                = "${var.function_labels}"
  runtime               = "${var.function_runtime}"
  environment_variables = "${var.function_environment_variables}"

  source_repository {
    url = "${var.source_repository_url}"
  }

  project = "${var.project_id}"
  region  = "${var.region}"
}
