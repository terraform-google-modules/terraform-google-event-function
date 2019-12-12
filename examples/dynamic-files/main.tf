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
  required_version = "~> 0.12.0"
}

resource "random_pet" "main" {
  length    = 2
  separator = "-"
}

resource "google_storage_bucket" "trigger_bucket" {
  name          = "${random_pet.main.id}-trigger"
  force_destroy = true
  location      = var.region
  project       = var.project_id
  storage_class = "REGIONAL"
}

resource "random_string" "random" {
  length  = 16
  special = false
}

resource "local_file" "file" {
  content  = random_string.random.result
  filename = "${path.module}/function_source/terraform_created_file.txt"
}

module "localhost_function" {
  source = "../.."

  description = "Returns back the random file content"
  entry_point = "fileContent"

  event_trigger = {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.trigger_bucket.name
  }

  name             = random_pet.main.id
  project_id       = var.project_id
  region           = var.region
  source_directory = "${path.module}/function_source"
  runtime          = "nodejs8"

  source_dependent_files = [local_file.file]
}

resource "null_resource" "wait_for_function" {
  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [module.localhost_function]
}
