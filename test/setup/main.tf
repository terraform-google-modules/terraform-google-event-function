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
  project_name   = "ci-event-function"
  subfolder_name = "${local.project_name}-${random_id.folder_rand.hex}"
}

resource "random_id" "folder_rand" {
  byte_length = 2
}

resource "google_folder" "ci_event_func_subfolder" {
  display_name = local.subfolder_name
  parent       = "folders/${var.folder_id}"
}

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 15.0"

  name                    = local.project_name
  random_project_id       = true
  org_id                  = var.org_id
  folder_id               = var.folder_id
  billing_account         = var.billing_account
  default_service_account = "keep"

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "storage-api.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "storage-component.googleapis.com",
    "sourcerepo.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
  ]
}

module "network" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id   = module.project.project_id
  network_name = "test-network"

  subnets = [{
    subnet_name   = "test-subnet-01"
    subnet_ip     = "10.10.10.0/24"
    subnet_region = var.region
  }]
}
