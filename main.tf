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

resource "google_pubsub_topic" "main" {
  name    = "${var.name}"
  project = "${var.project_id}"
}

resource "google_logging_project_sink" "main" {
  name                   = "${var.name}"
  destination            = "pubsub.googleapis.com/${google_pubsub_topic.main.id}"
  filter                 = "${var.log_export_filter}"
  project                = "${var.project_id}"
  unique_writer_identity = true
}

data "google_iam_policy" "main" {
  binding {
    role    = "roles/pubsub.publisher"
    members = ["${google_logging_project_sink.main.writer_identity}"]
  }
}

resource "google_pubsub_topic_iam_policy" "main" {
  topic       = "${google_pubsub_topic.main.name}"
  project     = "${var.project_id}"
  policy_data = "${data.google_iam_policy.main.policy_data}"
}

resource "google_cloudfunctions_function" "main" {
  name                  = "${var.name}"
  source_archive_bucket = "${google_storage_bucket.main.name}"
  source_archive_object = "${google_storage_bucket_object.main.name}"
  description           = "${var.function_description}"
  available_memory_mb   = "${var.function_available_memory_mb}"
  timeout               = "${var.function_timeout_s}"
  entry_point           = "${var.function_entry_point}"

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = "${google_pubsub_topic.main.name}"

    failure_policy {
      retry = "${var.function_event_trigger_failure_policy_retry}"
    }
  }

  labels                = "${var.function_labels}"
  runtime               = "${var.function_runtime}"
  environment_variables = "${var.function_environment_variables}"
  project               = "${var.project_id}"
  region                = "${var.region}"
}

data "archive_file" "main" {
  type        = "zip"
  output_path = "${pathexpand("${var.function_source_directory}.zip")}"
  source_dir  = "${pathexpand("${var.function_source_directory}")}"
}

resource "google_storage_bucket" "main" {
  name          = "${var.name}"
  force_destroy = "true"
  location      = "${var.function_source_archive_bucket_location}"
  project       = "${var.project_id}"
  storage_class = "REGIONAL"
  labels        = "${var.function_source_archive_bucket_labels}"
}

resource "google_storage_bucket_object" "main" {
  name                = "event_function.zip"
  bucket              = "${google_storage_bucket.main.name}"
  source              = "${data.archive_file.main.output_path}"
  content_disposition = "attachment"
  content_encoding    = "gzip"
  content_type        = "application/zip"
}
