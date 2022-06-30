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


/**
* This allows users of the module to pass in any local_file resources
* that we'll wait to exist before creating the archive.
* This allows for us to delay the archive creation when terraform itself
* is creating files. See this issue for more details
* https://github.com/terraform-providers/terraform-provider-archive/issues/11
*/

locals {
  logging = var.log_bucket == null ? [] : [
    {
      log_bucket        = var.log_bucket
      log_object_prefix = var.log_object_prefix
    }
  ]
}

resource "null_resource" "dependent_files" {
  triggers = {
    for file in var.source_dependent_files :
    pathexpand(file.filename) => file.id
  }
}

data "null_data_source" "wait_for_files" {
  inputs = {
    # This ensures that this data resource will not be evaluated until
    # after the null_resource has been created.
    dependent_files_id = null_resource.dependent_files.id

    # This value gives us something to implicitly depend on
    # in the archive_file below.
    source_dir = pathexpand(var.source_directory)
  }
}

data "archive_file" "main" {
  type        = "zip"
  output_path = pathexpand("${var.source_directory}.zip")
  source_dir  = data.null_data_source.wait_for_files.outputs["source_dir"]
  excludes    = var.files_to_exclude_in_source_dir
}


resource "google_storage_bucket" "main" {
  count                       = var.create_bucket ? 1 : 0
  name                        = coalesce(var.bucket_name, var.name)
  force_destroy               = var.bucket_force_destroy
  location                    = var.region
  project                     = var.project_id
  storage_class               = "REGIONAL"
  labels                      = var.bucket_labels
  uniform_bucket_level_access = true

  dynamic "logging" {
    for_each = local.logging == [] ? [] : local.logging
    content {
      log_bucket        = logging.value.log_bucket
      log_object_prefix = logging.value.log_object_prefix
    }
  }

}

resource "google_storage_bucket_object" "main" {
  name                = "${data.archive_file.main.output_md5}-${basename(data.archive_file.main.output_path)}"
  bucket              = var.create_bucket ? google_storage_bucket.main[0].name : var.bucket_name
  source              = data.archive_file.main.output_path
  content_disposition = "attachment"
  content_encoding    = "gzip"
  content_type        = "application/zip"
}

// todo(bharathkkb): remove workaround after https://github.com/hashicorp/terraform-provider-google/issues/11383
// Also: https://github.com/hashicorp/terraform/issues/28925 (when this functions project is created)
data "google_project" "nums" {
  for_each   = toset(compact([for item in var.secret_environment_variables : lookup(item, "project_id", "")]))
  project_id = each.value
}

data "google_project" "default" {
  count      = length(var.secret_environment_variables) > 0 ? 1 : 0
  project_id = var.project_id
}

resource "google_cloudfunctions_function" "main" {
  name                          = var.name
  description                   = var.description
  available_memory_mb           = var.available_memory_mb
  max_instances                 = var.max_instances
  timeout                       = var.timeout_s
  entry_point                   = var.entry_point
  ingress_settings              = var.ingress_settings
  trigger_http                  = var.trigger_http
  vpc_connector_egress_settings = var.vpc_connector_egress_settings
  vpc_connector                 = var.vpc_connector

  dynamic "event_trigger" {
    for_each = var.trigger_http != null ? [] : [1]

    content {
      event_type = var.event_trigger["event_type"]
      resource   = var.event_trigger["resource"]

      failure_policy {
        retry = var.event_trigger_failure_policy_retry
      }
    }
  }

  dynamic "secret_environment_variables" {
    for_each = { for item in var.secret_environment_variables : item.key => item }

    content {
      key        = secret_environment_variables.value["key"]
      project_id = try(data.google_project.nums[secret_environment_variables.value["project_id"]].number, data.google_project.default[0].number)
      secret     = secret_environment_variables.value["secret_name"]
      version    = lookup(secret_environment_variables.value, "version", "latest")
    }
  }

  labels                      = var.labels
  runtime                     = var.runtime
  environment_variables       = var.environment_variables
  source_archive_bucket       = var.create_bucket ? google_storage_bucket.main[0].name : var.bucket_name
  source_archive_object       = google_storage_bucket_object.main.name
  project                     = var.project_id
  region                      = var.region
  service_account_email       = var.service_account_email
  build_environment_variables = var.build_environment_variables
}
