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

output "destination" {
  description = "The universal resource identifier of the topic."
  value       = "pubsub.googleapis.com/${google_pubsub_topic.main.id}"
}

output "event_type" {
  description = "The type of event which will be observed by the function."
  value       = "google.pubsub.topic.publish"
}

output "resource" {
  description = "The name of the topic from which the function will observe events."
  value       = "${google_pubsub_topic.main.name}"
}
