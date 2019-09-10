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

const { google } = require("googleapis");
const { auth } = google;
const crm = google.cloudresourcemanager("v1");

/**
 * Authenticates with Google Cloud Platform.
 *
 * @param {!Function} callback A callback function to signal completion.
 */
authenticate = callback => {
  console.log("Authenticating");
  auth.getApplicationDefault((error, authClient) => {
    if (error) {
      console.error("Error while authenticating");

      return callback(error);
    }
    console.log("Authenticated");

    return callback(null, authClient);
  });
};

/**
 * Fetches fields from a given project.
 *
 * @param {!Object} authClient An authenticated client for GCP.
 * label.
 * @param {!String} projectId The identity of the project to fetch fields for.
 * @param {!Function} callback A callback function to signal completion.
 */
fetchFields = ({ authClient, projectId }, callback) => {
  console.log("Fetching fields for " + projectId);
  crm.projects.get(
    { auth: authClient, projectId }, (error, response) => {
      if (error) {
        console.error("Error while fetching fields");

        return callback(error);
      }

      const fields = response.data || {};

      console.log("Fetched labels:", fields);

      return callback(null, fields);
    });
};

/**
 * Stores fields on a given project.
 *
 * @param {!Object} authClient An authenticated client for GCP.
 * @param {!Object} fields Fields to be stored on the project.
 * @param {!String} projectId The identity of the project to save fields to.
 * @param {!Function} callback A callback function to signal completion.
 */
storeFields =
  ({ authClient, fields, projectId },
    callback) => {
    console.log("Storing fields for " + projectId);
    crm.projects.update(
      {
        auth: authClient,
        projectId,
        resource: fields
      },
      error => {
        if (error) {
          console.error("Error while storing fields");

          return callback(error);
        }
        console.log("Stored fields:", fields);

        return callback(null);
      });
  };

/**
 * Triggered from a message on a Cloud Pub/Sub topic.
 *
 * @param {!Object} event Event payload and metadata.
 * @param {!Function} callback Callback function to signal completion.
 */
exports.labelResource = (data, context, callback)=> {
  const eventData =
    JSON.parse(Buffer.from(data.data, "base64").toString());

  console.log("Received event");
  console.log(eventData);
  authenticate((error, authClient) => {
    if (error) {
      return callback(error);
    }

    const projectId = eventData.resource.labels.project_id;

    fetchFields(
      { authClient, projectId },
      (error, fields, labelFingerprint) => {
        if (error) {
          return callback(error);
        }

        const labelKey = process.env.LABEL_KEY;
        const labelValue = process.env.LABEL_VALUE;

        storeFields(
          {
            authClient,
            fields: {
              name: fields.name,
              parent: fields.parent,
              labels:
                Object.assign(fields.labels || {}, { [labelKey]: labelValue })
            },
            projectId
          },
          callback);
      });
  });
};
