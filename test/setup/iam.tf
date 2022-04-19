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
  int_required_roles = [
    "roles/cloudfunctions.developer",
    "roles/storage.admin",
    "roles/compute.admin",
    "roles/pubsub.admin",
    "roles/logging.configWriter",
    "roles/source.admin",
    "roles/iam.serviceAccountUser",
    "roles/secretmanager.admin",
  ]

  int_required_folder_roles = [
    "roles/owner",
    "roles/resourcemanager.projectCreator",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.folderIamAdmin",
    "roles/billing.projectManager",
  ]

  int_required_folder_cloud_function_roles = [
    "roles/owner",
  ]
}

resource "google_service_account" "int_test" {
  project      = module.project.project_id
  account_id   = "ci-account"
  display_name = "ci-account"
}

resource "google_project_iam_member" "int_test" {
  count = length(local.int_required_roles)

  project = module.project.project_id
  role    = local.int_required_roles[count.index]
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_folder_iam_member" "int_test_folder" {
  count = length(local.int_required_folder_roles)

  folder = google_folder.ci_event_func_subfolder.name
  role   = local.int_required_folder_roles[count.index]
  member = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_folder_iam_member" "int_test_sub_folder_cloud_function" {
  count = length(local.int_required_folder_cloud_function_roles)

  folder = google_folder.ci_event_func_subfolder.name
  role   = local.int_required_folder_cloud_function_roles[count.index]
  member = "serviceAccount:${module.project.project_id}@appspot.gserviceaccount.com"
}

resource "google_service_account_key" "int_test" {
  service_account_id = google_service_account.int_test.id
}
