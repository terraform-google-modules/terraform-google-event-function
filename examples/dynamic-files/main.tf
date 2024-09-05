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
  secret_key_name = "random_secret_key"
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
  count   = 2
  length  = 16
  special = false
}

resource "google_secret_manager_secret" "secret_key" {
  project   = var.project_id
  secret_id = local.secret_key_name

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "secret_key_version" {
  secret      = google_secret_manager_secret.secret_key.id
  secret_data = random_string.random[0].result
  depends_on = [
    google_secret_manager_secret.secret_key
  ]
}

resource "google_secret_manager_secret_iam_member" "iam_access_policy" {
  secret_id = google_secret_manager_secret.secret_key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${var.project_id}@appspot.gserviceaccount.com"
  depends_on = [
    google_secret_manager_secret.secret_key
  ]
}

resource "local_file" "file" {
  content  = random_string.random[1].result
  filename = "${path.module}/function_source/terraform_created_file.txt"
}

module "localhost_function" {
  source  = "terraform-google-modules/event-function/google"
  version = "~> 4.0"

  description = "Returns back the random file content"
  entry_point = "fileContent"

  event_trigger = {
    event_type = "google.storage.object.finalize"
    resource   = google_storage_bucket.trigger_bucket.name
  }

  secret_environment_variables = [
    {
      key         = "KEY"
      project_id  = var.project_id
      secret_name = local.secret_key_name
      version     = "1"
    }
  ]

  name             = random_pet.main.id
  project_id       = var.project_id
  region           = var.region
  source_directory = "${path.module}/function_source"
  runtime          = "nodejs10"
  max_instances    = 3000

  source_dependent_files = [local_file.file]
  depends_on             = [google_secret_manager_secret_version.secret_key_version]
}

resource "null_resource" "wait_for_function" {
  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [module.localhost_function]
}
