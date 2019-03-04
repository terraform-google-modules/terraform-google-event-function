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

output "function_source_archive_bucket" {
  description = "The name of the bucket which contains the source archive object."
  value       = "${google_storage_bucket.main.name}"
}

output "function_source_archive_object" {
  description = "The name of the object which is the function source archive."
  value       = "${google_storage_bucket_object.main.output_name}"
}
