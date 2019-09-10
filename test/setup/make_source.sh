#!/usr/bin/env bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id=$(terraform output project_id)
region=$(terraform output region)
zone=$(terraform output zone)
sub_folder_id=$(terraform output sub_folder_id)

{
  echo "#!/usr/bin/env bash"
  echo "export TF_VAR_project_id='$project_id'"
  echo "export TF_VAR_region='$region'"
  echo "export TF_VAR_zone='$zone'"
  echo "export TF_VAR_folder_id='$sub_folder_id'"
} > ../source.sh

sa_json=$(terraform output sa_key)
# shellcheck disable=SC2086
echo "export SERVICE_ACCOUNT_JSON='$(echo $sa_json | base64 --decode)'" >> ../source.sh


