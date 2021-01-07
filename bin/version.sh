#!/bin/bash

echo "Tools:"

echo "AWS CLI: $(aws --version)"
echo "Terraform: $(terraform version)"
echo "KubeCtl: $(kubectl version --client)"
echo "Helm: $(helm version)"
echo "Ruby: $(ruby --version)"
echo "Python: $(python --version)"
echo "Go: $(go version)"
echo "Docker: $(docker version --format '{{.Client.Version}}')"
echo "DigitalOcean CLI: $(doctl version | head -1)"
echo "RKE: $(rke --version)"