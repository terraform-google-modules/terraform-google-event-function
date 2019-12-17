# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id         = attribute('project_id')
region             = attribute('region')
function_name      = attribute('function_name')
random_file_string = attribute('random_file_string')

control "gcloud" do
  title "gcloud configuration"

  describe command("gcloud --project=#{project_id} functions call #{function_name} --region #{region} --data '{}' --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "terraform's file string" do
      it "should be returned" do
        expect(data).to include(
          "result" => random_file_string
        )
      end
    end
  end
end
