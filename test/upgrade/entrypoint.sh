#!/usr/bin/env bash

# Copyright 2018 Google LLC All Rights Reserved.
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

# THIS FILE DOES NOT WORK
set -e

export SHELL="/bin/bash"
export KUBECONFIG="/root/.kube/config"
mkdir -p /go/src/agones.dev/ /root/.kube/
ln -s /workspace /go/src/agones.dev/agones
cd /go/src/agones.dev/agones/test/upgrade

if [ "$1" = 'local' ]
then
  gcloud auth login
fi
gcloud container clusters get-credentials $TEST_CLUSTER_NAME --region=$TEST_CLUSTER_LOCATION --project=$TEST_PROJECT_ID

echo kubectl apply -f permissions.yaml
kubectl apply -f permissions.yaml
echo kubectl apply -f versionMap.yaml
kubectl apply -f versionMap.yaml

# TODO: Replace image: us-docker.pkg.dev/igooch-gke-dev/agonesrepo/upgrade-test-controller:$TAG
# in upgradeTest.yaml with the commit tag (i.e. 1.44.0-dev-d3956c8) and pass the same $TAG as
# environment variable for main.go `DevVersion = os.Getenv("DevVersion")`
echo PARENT_COMMIT_SHA $PARENT_COMMIT_SHA
VERSION="1.45.0-dev-$(shell git rev-parse --short=7 HEAD)"
echo VERSION $VERSION

echo kubectl apply -f upgradeTest.yaml
kubectl apply -f upgradeTest.yaml

echo Wait for job upgrade-test-runner to complete or fail
timeout 15m bash -c 'until status=$(kubectl get job upgrade-test-runner -o jsonpath='{.status.conditions[0].type}') | [ "$status" = "Complete" ] || [ "$status" = "Failed" ]; do sleep 10; done'

echo Finished waiting for Job upgrade-test-runner with status "$status"
# TODO: fail (exit 1) if status is failed after timeout
