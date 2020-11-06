# Devteds CloudCLI 

Package of commonly used CLI tools. Below are a few,

- AWS
- doctl (DigitalOcean CLI)
- Terraform
- kubectl
- Helm
- Ruby
- Python
- Git
- Go
- OpenSSH

## How to use?

You could download [cloudcli.sh](https://raw.githubusercontent.com/devteds/cloudcli/master/dist/cloudcli.sh), and run. See the instructions below.

```
curl -o /usr/local/bin/cloudcli https://raw.githubusercontent.com/devteds/cloudcli/master/dist/cloudcli.sh
chmod +x /usr/local/bin/cloudcli

cd <WORKDIR>

# Example Commands
cloudcli version

cloudcli exec helm version
cloudcli exec terraform version
cloudcli exec aws configure

# Work within CLI container (mounts current directory)
cloudcli ssh
> ls
> exit
```

**Can't use the script or using windows?**

If you are using windows, you might want to create a script similar to [cloudcli.sh](https://raw.githubusercontent.com/devteds/cloudcli/master/dist/cloudcli.sh). Below are a few examples of running this CLI using docker image instead of the wrapper script,

*Launch CLI container and SSH*

```
docker  run -it --rm \
  -v ${PWD}/.aws:/root/.aws:ro \
  -v ${PWD}/.helm:/root/.helm:rw \
  -v ${PWD}/.kube:/root/.kube:rw \
  -v ${PWD}/:/cloudcli-home/workspace/:rw \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e AWS_REGION=us-west-2 \
  devteds/cloudcli:latest

> terraform version
> helm version
> aws configure
> python --version
> exit  
```

*Launch CLI container and run a specific CLI command*

```
docker  run -it --rm \
  -v ${PWD}/.aws:/root/.aws:ro \
  -v ${PWD}/.helm:/root/.helm:rw \
  -v ${PWD}/.kube:/root/.kube:rw \
  -v ${PWD}/:/cloudcli-home/workspace/:rw \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e AWS_REGION=us-west-2 \
  devteds/cloudcli:latest \
  terraform version
```

## Image on Docker Hub

[devteds/cloudcli](https://hub.docker.com/r/devteds/cloudcli)
