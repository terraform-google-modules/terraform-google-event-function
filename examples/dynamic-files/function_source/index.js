/**
 * Copyright 2019 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

const fs = require("fs");
const path = require("path");
const filePath = path.join(__dirname, "terraform_created_file.txt");

/**
 * Cloud function entrypoint
 *
 * @param {!Object} event Event payload and metadata.
 * @param {!Function} callback Callback function to signal completion.
 */
exports.fileContent = (data, context, callback) => {
  console.log("Received event");

  fs.readFile(filePath, { encoding: "utf-8" }, function(err, data) {
    if (!err) {
      callback(null, data);
    } else {
      callback(err);
    }
  });
};
