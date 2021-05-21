#!/usr/bin/env bash
set -e

CLOUDCLI_DOCKER_IMAGE=devteds/cloudcli:1.0.1

DOT_AWS="${DOT_AWS:-$PWD/.cloudcli/aws}"
DOT_HELM="${DOT_HELM:-$PWD/.cloudcli/helm}"
DOT_KUBE="${DOT_KUBE:-$PWD/.cloudcli/kube}"
DOT_SSH="${DOT_SSH:-$PWD/.cloudcli/ssh}"
DOT_DOCTL="${DOT_DOCTL:-$PWD/.cloudcli/doctl}"
AWS_REGION="${AWS_REGION:-us-west-2}"
HOSTNAME_ALIAS="${HOSTNAME_ALIAS:-devteds-cloudcli}"
PORT_FORWARDS=""
REMOTE_USER="${REMOTE_USER:-$USER}"

show_help() {
  echo "
Usage: 
  cloudcli ssh|version|exec [OPTIONS] [COMMAND]

Examples:
  cloudcli ssh -h
  cloudcli ssh -p 8085:8000 -p 8086:8001
  cloudcli exec aws s3 ls
  cloudcli exec kubectl get po
  cloudcli version"
  exit 1
}

show_ssh_usage() {
  echo "
Usage: 
  cloudcli ssh [OPTIONS]

Options:
  -p <host-port:port>     Port forward from host-to-container
  -u <remote-user>        Remote/ssh user
  -h                      Help

Examples:
  cloudcli ssh
  cloudcli ssh -p 8085:8000 -p 8086:8001"  
}

[ ! -n "$1" ] && show_help

function docker_run {
  CMD=$1
  docker  run -it --rm \
    -v ${DOT_AWS}:/root/.aws:rw \
    -v ${DOT_HELM}:/root/.helm:rw \
    -v ${DOT_KUBE}:/root/.kube:rw \
    -v ${DOT_SSH}:/root/.ssh:rw \
    -v ${DOT_DOCTL}:/root/.config:rw \
    -v ${PWD}/:/cloudcli-home/workspace/:rw \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e HOSTNAME_ALIAS=${HOSTNAME_ALIAS} \
    -e AWS_REGION=${AWS_REGION} \
    -e REMOTE_USER=${REMOTE_USER} \    
    $PORT_FORWARDS \
    $CLOUDCLI_DOCKER_IMAGE \
    $CMD
}

function cli_exec {
  docker_run "$CLOUDCLI_CMD"
}

function parse_ssh_opts {
  while [ "$1" != "" ]; do
      case $1 in
          -p | --port-forward )
              shift
              PORT_FORWARDS="$PORT_FORWARDS -p $1 "
          ;;
          -u | --remote-user )
              shift
              REMOTE_USER=$1
          ;;          
        -h | --help )    show_ssh_usage
            exit
        ;;          
      esac
      shift
  done
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
  parse_ssh_opts $CLOUDCLI_CMD
  docker_run
elif [ "$CLOUDCLI_CMD_TYPE" = "version" ]; then
  docker_run "/cloudcli-home/bin/version.sh"
else show_help
fi
