#!/bin/bash
set -eou pipefail

SCRIPT_ROOT=$(realpath $(dirname "${BASH_SOURCE[0]}")) # adjust as needed to go to root directory
SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")
pushd $SCRIPT_ROOT

echo SCRIPT_ROOT=$SCRIPT_ROOT

# http://redsymbol.net/articles/bash-exit-traps/
function cleanup() {
  popd
}
trap cleanup EXIT

log_level=
if [ -n "${GITHUB_ACTION:-}" ]; then
	log_level=--v=3
fi

declare -a api_dirs=( \
	$HOME/go/src/kmodules.xyz/client-go \
	$HOME/go/src/kmodules.xyz/monitoring-agent-api \
	$HOME/go/src/kmodules.xyz/objectstore-api \
	$HOME/go/src/kmodules.xyz/offshoot-api \
	$HOME/go/src/kmodules.xyz/prober \
)

for dir in "${api_dirs[@]}"; do
	echo
	echo "processing $dir"
	cd $dir
	set -x
	gen-api-reference-docs $log_level \
	  -config=$SCRIPT_ROOT/api-docs-generator-config.json \
	  -api-dir=./api \
	  -out-dir=$SCRIPT_ROOT/content
	set +x
done

declare -a dirs=( \
	$HOME/go/src/kmodules.xyz/custom-resources \
	$HOME/go/src/kubedb.dev/apimachinery \
	$HOME/go/src/kubevault.dev/apimachinery \
	$HOME/go/src/stash.appscode.dev/apimachinery \
	$HOME/go/src/kubeform.dev/provider-alicloud-api \
	$HOME/go/src/kubeform.dev/provider-aws-api \
	$HOME/go/src/kubeform.dev/provider-azurerm-api \
	$HOME/go/src/kubeform.dev/provider-civo-api \
	$HOME/go/src/kubeform.dev/provider-datadog-api \
	$HOME/go/src/kubeform.dev/provider-digitalocean-api \
	$HOME/go/src/kubeform.dev/provider-dynatrace-api \
	$HOME/go/src/kubeform.dev/provider-ec-api \
	$HOME/go/src/kubeform.dev/provider-equinixmetal-api \
	$HOME/go/src/kubeform.dev/provider-google-api \
	$HOME/go/src/kubeform.dev/provider-grafana-api \
	$HOME/go/src/kubeform.dev/provider-hcloud-api \
	$HOME/go/src/kubeform.dev/provider-ibm-api \
	$HOME/go/src/kubeform.dev/provider-linode-api \
	$HOME/go/src/kubeform.dev/provider-mongodbatlas-api \
	$HOME/go/src/kubeform.dev/provider-newrelic-api \
	$HOME/go/src/kubeform.dev/provider-oci-api \
	$HOME/go/src/kubeform.dev/provider-ovh-api \
	$HOME/go/src/kubeform.dev/provider-pagerduty-api \
	$HOME/go/src/kubeform.dev/provider-rediscloud-api \
	$HOME/go/src/kubeform.dev/provider-upcloud-api \
	$HOME/go/src/kubeform.dev/provider-vsphere-api \
	$HOME/go/src/kubeform.dev/provider-vultr-api \
	$HOME/go/src/kubeform.dev/provider-wavefront-api \
)

for dir in "${dirs[@]}"; do
	echo
	echo "processing $dir"
	cd $dir
	set -x
	gen-api-reference-docs $log_level \
	  -config=$SCRIPT_ROOT/api-docs-generator-config.json \
	  -api-dir=./apis \
	  -out-dir=$SCRIPT_ROOT/content
	set +x
done
