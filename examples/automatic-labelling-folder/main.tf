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

resource "random_pet" "main" {
  length    = 2
  separator = "-"
}

module "event_folder_log_entry" {
  source = "../../modules/event-folder-log-entry"

  filter     = <<EOF
resource.type="project" AND
protoPayload.serviceName="cloudresourcemanager.googleapis.com" AND
protoPayload.methodName="CreateProject"
EOF
  name       = random_pet.main.id
  project_id = var.project_id
  folder_id  = var.folder_id
}

module "localhost_function" {
  source = "../.."

  description = "Labels resource with owner information."
  entry_point = "labelResource"

  environment_variables = {
    FOLDER_ID   = var.folder_id
    LABEL_KEY   = "test"
    LABEL_VALUE = "foobar"
  }

  event_trigger    = module.event_folder_log_entry.function_event_trigger
  name             = random_pet.main.id
  project_id       = var.project_id
  region           = var.region
  source_directory = "${path.module}/function_source"
  runtime          = "nodejs10"
  max_instances    = 3000
}

resource "null_resource" "wait_for_function" {
  provisioner "local-exec" {
    command = "sleep 60"
  }

  depends_on = [module.localhost_function]
}

resource "random_pet" "project_id" {
  length    = 1
  separator = "-"
  prefix    = random_pet.main.id
}

resource "google_project" "test" {
  name       = random_pet.project_id.id
  project_id = random_pet.project_id.id
  folder_id  = var.folder_id

  lifecycle {
    ignore_changes = [
      labels,
    ]
  }

  depends_on = [null_resource.wait_for_function]
}

resource "google_project_iam_member" "test_project_iam" {
  project = google_project.test.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${var.project_id}@appspot.gserviceaccount.com"
}
