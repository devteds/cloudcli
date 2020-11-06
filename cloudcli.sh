#!/usr/bin/env bash
set -e

CLOUDCLI_DOCKER_IMAGE=devteds/cloudcli:1.0.0

DOT_AWS="${DOT_AWS:-$PWD/.aws}"
DOT_HELM="${DOT_HELM:-$PWD/.helm}"
DOT_KUBE="${DOT_KUBE:-$PWD/.kube}"
AWS_REGION="${AWS_REGION:-us-west-2}"
HOSTNAME_ALIAS="${HOSTNAME_ALIAS:-devteds-cloudcli}"

show_help() {
  echo "
Usage: 
  cloudcli exec|ssh [COMMAND]

Examples:
  cloudcli exec aws s3 ls
  cloudcli exec kubectl apply -f MANIFEST.YAML"
  exit 1
}

[ ! -n "$1" ] && show_help

function docker_run {
  CMD=$1
  docker  run -it --rm \
    -v ${DOT_AWS}:/root/.aws:ro \
    -v ${DOT_HELM}:/root/.helm:rw \
    -v ${DOT_KUBE}:/root/.kube:rw \
    -v ${PWD}/:/cloudcli-home/workspace/:rw \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e HOSTNAME_ALIAS=${HOSTNAME_ALIAS} \
    -e AWS_REGION=${AWS_REGION} \
    $CLOUDCLI_DOCKER_IMAGE \
    $CMD
}

function cli_exec {
  docker_run "$CLOUDCLI_CMD"
}

CLOUDCLI_CMD_TYPE=$1
shift
CLOUDCLI_CMD="$@"

if [ "$CLOUDCLI_CMD_TYPE" = "exec" ]; then
  if [ -z "$CLOUDCLI_CMD" ]; then
    echo "Need a command to execute"
    show_help
  fi
  docker_run "$CLOUDCLI_CMD"
elif [ "$CLOUDCLI_CMD_TYPE" = "ssh" ]; then
  docker_run
else show_help
fi
