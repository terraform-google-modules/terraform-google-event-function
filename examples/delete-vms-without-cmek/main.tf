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

terraform {
  required_version = ">= 0.12"
}

provider "archive" {
}

provider "google" {
}

provider "random" {
}

resource "random_pet" "main" {
  separator = "-"
}

module "event_project_log_entry" {
  source = "../../modules/event-project-log-entry"

  filter     = "resource.type=\"gce_instance\" jsonPayload.event_subtype=\"compute.instances.insert\" jsonPayload.event_type=\"GCE_OPERATION_DONE\""
  name       = random_pet.main.id
  project_id = var.project_id
}

module "localhost_function" {
  source = "../.."

  description = "Deletes VMs created with disks not encrypted with CMEK"
  entry_point = "ReceiveMessage"
  runtime     = "go111"
  timeout_s   = "240"

  event_trigger    = module.event_project_log_entry.function_event_trigger
  name             = random_pet.main.id
  project_id       = var.project_id
  region           = var.region
  source_directory = "${path.module}/function_source"
}
