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

data "archive_file" "main" {
  type        = "zip"
  output_path = "${pathexpand("${var.source_directory}.zip")}"
  source_dir  = "${pathexpand("${var.source_directory}")}"
}

resource "google_storage_bucket" "main" {
  name          = "${coalesce(var.bucket_name, var.name)}"
  location      = "${var.region}"
  project       = "${var.project_id}"
  storage_class = "REGIONAL"
  labels        = "${var.source_archive_bucket_labels}"
}

resource "google_storage_bucket_object" "main" {
  name                = "${basename(data.archive_file.main.output_path)}"
  bucket              = "${google_storage_bucket.main.name}"
  source              = "${data.archive_file.main.output_path}"
  content_disposition = "attachment"
  content_encoding    = "gzip"
  content_type        = "application/zip"
}

resource "google_cloudfunctions_function" "main" {
  name                = "${var.name}"
  description         = "${var.description}"
  available_memory_mb = "${var.available_memory_mb}"
  timeout             = "${var.timeout_s}"
  entry_point         = "${var.entry_point}"

  event_trigger {
    event_type = "${var.event_trigger["event_type"]}"
    resource   = "${var.event_trigger["resource"]}"
  }

  labels                = "${var.labels}"
  runtime               = "${var.runtime}"
  environment_variables = "${var.environment_variables}"
  source_archive_bucket = "${google_storage_bucket.main.name}"
  source_archive_object = "${google_storage_bucket_object.main.name}"
  project               = "${var.project_id}"
  region                = "${var.region}"
  service_account_email = "${var.service_account_email}"
}
