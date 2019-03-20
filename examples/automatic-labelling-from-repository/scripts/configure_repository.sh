#!/usr/bin/env bash

# Copyright 2019 Google LLC
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

set -e
set -x

cp -R "$REPOSITORY_DIRECTORY" "$REPOSITORY_COPY_DIRECTORY"
cd "$REPOSITORY_COPY_DIRECTORY"
git init
git config user.name "Terraform"
git config user.email "terraform@example.com"
git config credential.'https://source.developers.google.com'.helper gcloud.sh
git remote add google "$REMOTE_URL"
git add -A
git commit -m "Initial commit"
git push -u google master
