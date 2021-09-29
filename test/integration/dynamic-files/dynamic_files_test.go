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

	// import the blueprints test framework modules for testing and assertions
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

// name the function as Test*
func TestDynamicFiles(t *testing.T) {
	// initialize Terraform test from the blueprint test framework
	bpt := tft.NewTFBlueprintTest(t)

	// define and write a custom verifier for this test case call the default verify for confirming no additional changes
	bpt.DefineVerify(func(assert *assert.Assertions) {
		// perform default verification ensuring Terraform reports no additional changes on an applied blueprint
		bpt.DefaultVerify(assert)

		// gather custom attributes for tests
		project := bpt.GetStringOutput("project_id")
		region := bpt.GetStringOutput("region")
		functionName := bpt.GetStringOutput("function_name")
		randomFileString := bpt.GetStringOutput("random_file_string")

		op := gcloud.Run(t,
			fmt.Sprintf("functions call %s", functionName),
			gcloud.WithCommonArgs([]string{"--data", "{}", "--format", "json", "--project", project, "--region", region}),
		)
		// assert values that are contained in the expected output
		assert.Contains(op.Get("result").String(), randomFileString, "contains random string")
	})

	bpt.Test()
}
