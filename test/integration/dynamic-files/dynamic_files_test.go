// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// define test package name
package dynamic_files

import (
	"fmt"
	"testing"
	"time"

	// import the blueprints test framework modules for testing and assertions
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestDynamicFiles(t *testing.T) {
	RetryableTransientErrors := map[string]string{
		".*Error code 13, message: Gen1 operation for function .* failed: Failed to configure trigger providers/cloud.storage/eventTypes/object.change.*": "Retry Cloud Function Creation",
	}

	bpt := tft.NewTFBlueprintTest(t,
		tft.WithRetryableTerraformErrors(RetryableTransientErrors, 3, 30*time.Second),
	)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		// gather custom attributes for tests
		project := bpt.GetStringOutput("project_id")
		region := bpt.GetStringOutput("region")
		functionName := bpt.GetStringOutput("function_name")
		randomFileString := bpt.GetStringOutput("random_file_string")
		randomSecretString := bpt.GetStringOutput("random_secret_string")

		// call the function directly
		op := gcloud.Run(t,
			fmt.Sprintf("functions call %s", functionName),
			gcloud.WithCommonArgs([]string{"--data", "{}", "--format", "json", "--project", project, "--region", region}),
		)
		// assert file random string and secret random string is contained in function response
		assert.Contains(op.Get("result").String(), randomFileString, "contains file random string")
		assert.Contains(op.Get("result").String(), randomSecretString, "contains secret random string")
	})

	bpt.Test()
}
