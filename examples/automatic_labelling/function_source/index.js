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
const compute = google.compute("v1");

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
 * Fetches labels from a given Compute Engine instance.
 *
 * @param {!Object} authClient An authenticated client for GCP.
 * @param {!String} instance The identity of the instance on which to store
 * label.
 * @param {!String} project The identity of the project in which the instance
 * exists.
 * @param {!String} zone The zone in which the instance exists.
 * @param {!Function} callback A callback function to signal completion.
 */
fetchLabels = ({ authClient, instance, project, zone }, callback) => {
  console.log("Fetching labels");
  compute.instances.get(
    { auth: authClient, instance, project, zone }, (error, response) => {
      if (error) {
        console.error("Error while fetching labels");

        return callback(error);
      }

      const labels = response.data.labels || {};
      const labelFingerprint = response.data.labelFingerprint;

      console.log("Fetched labels:", labels, labelFingerprint);

      return callback(null, labels, labelFingerprint);
    });
};

/**
 * Stores labels on a given Compute Engine instance.
 *
 * @param {!Object} authClient An authenticated client for GCP.
 * @param {!String} instance The identity of the instance on which to store
 * label.
 * @param {!String} labelFingerprint The fingerprint of existing labels stored
 * on the instance.
 * @param {!Object} labels Labels to be stored on the instance.
 * @param {!String} project The identity of the project in which the instance
 * exists.
 * @param {!String} zone The zone in which the instance exists.
 * @param {!Function} callback A callback function to signal completion.
 */
storeLabels =
  ({ authClient, instance, labelFingerprint, labels, project, zone },
    callback) => {
    console.log("Storing labels");
    compute.instances.setLabels(
      {
        auth: authClient,
        instance,
        project,
        resource: { labels: labels, labelFingerprint: labelFingerprint }, zone
      },
      error => {
        if (error) {
          console.error("Error while storing labels");

          return callback(error);
        }
        console.log("Stored labels:", labels);

        return callback(null);
      });
  };

/**
 * Triggered from a message on a Cloud Pub/Sub topic.
 *
 * @param {!Object} event Event payload and metadata.
 * @param {!Function} callback Callback function to signal completion.
 */
exports.labelResource = (event, callback) => {
  const eventData =
    JSON.parse(Buffer.from(event.data.data, "base64").toString());

  console.log("Received event");
  console.log(eventData);
  authenticate((error, authClient) => {
    if (error) {
      return callback(error);
    }

    const instance = eventData.resource.labels.instance_id;
    const project = eventData.resource.labels.project_id;
    const zone = eventData.resource.labels.zone;

    fetchLabels(
      { authClient, instance, project, zone },
      (error, labels, labelFingerprint) => {
        if (error) {
          return callback(error);
        }

        const labelKey = process.env.LABEL_KEY;
        const principalEmail =
          eventData.protoPayload.authenticationInfo.principalEmail.split(
            "@")[0];

        storeLabels(
          {
            authClient,
            instance,
            labelFingerprint,
            labels:
              Object.assign(labels, { [labelKey]: principalEmail }),
            project,
            zone
          },
          callback);
      });
  });
};
