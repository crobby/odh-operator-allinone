#! /bin/bash

# Copyright 2020 Red Hat, Inc. and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e -o pipefail

ODHPROJECT=${ODH_CR_NAMESPACE:-"opendatahub"}

kubectl create namespace ${ODH_CR_NAMESPACE} || echo "${ODH_CR_NAMESPACE} project already exists."

# Apply the ODH CR, 30 tries over 15 min
retry=30
while [[ $retry -gt 0 ]]; do
  kubectl -n ${ODH_CR_NAMESPACE} apply -f opendatahub.yaml
  if [ $? -eq 0 ]; then
    retry=-1
    echo "Attempt to create the ODH CR failed.  This is expected during operator installation."
    echo "Attempts remaining: $retry"
  fi
  retry=$(( retry - 1))
  sleep 30s
done

echo "Exiting..."