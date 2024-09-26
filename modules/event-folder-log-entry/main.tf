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

locals {
  destination_uri = "pubsub.googleapis.com/projects/${var.project_id}/topics/${local.topic_name}"
  topic_name      = element(concat(google_pubsub_topic.main[*].name, [""]), 0)
}

module "log_export" {
  source  = "terraform-google-modules/log-export/google"
  version = "~> 9.0"

  destination_uri        = local.destination_uri
  filter                 = var.filter
  log_sink_name          = var.name
  parent_resource_id     = var.folder_id
  include_children       = var.include_children
  parent_resource_type   = "folder"
  unique_writer_identity = "true"
}

resource "google_pubsub_topic" "main" {
  name    = var.name
  labels  = var.labels
  project = var.project_id
}

resource "google_pubsub_topic_iam_member" "main" {
  topic   = google_pubsub_topic.main.name
  project = var.project_id
  member  = module.log_export.writer_identity
  role    = "roles/pubsub.publisher"
}
