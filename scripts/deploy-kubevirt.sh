#!/usr/bin/env bash

set -e
set -x

export SHARED_DIR=$(mktemp -d)
source $GH/dhiller/kubevirt-testing/hack/kubevirt-testing.sh

deploy_latest_cdi_release
deploy_release 1.0.1
wait_on_all_ready
