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
  separator = "-"
}

module "event_project_log_entry" {
  source  = "terraform-google-modules/event-function/google//modules/event-project-log-entry"
  version = "~> 3.0"

  filter     = "protoPayload.@type=\"type.googleapis.com/google.cloud.audit.AuditLog\" protoPayload.methodName:insert operation.first=true"
  name       = random_pet.main.id
  project_id = var.project_id
  labels     = {}
}

module "localhost_function" {
  source  = "terraform-google-modules/event-function/google"
  version = "~> 3.0"

  description = "Labels resource with owner information."
  entry_point = "labelResource"

  environment_variables = {
    LABEL_KEY = "principal-email"
  }

  event_trigger    = module.event_project_log_entry.function_event_trigger
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

resource "google_compute_instance" "main" {
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  machine_type = "f1-micro"
  name         = "unlabelled-${random_pet.main.id}"
  zone         = var.zone

  lifecycle {
    ignore_changes = [
      labels,
    ]
  }

  network_interface {
    subnetwork = var.subnetwork
  }

  project = var.project_id

  depends_on = [null_resource.wait_for_function]
}
