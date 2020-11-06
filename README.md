# Devteds CloudCLI

Docker image comes with the below tools,

- AWS
- doctl (DigitalOcean CLI)
- Terrafrom
- KubeCtl
- Helm
- Ruby
- Python
- Git

## How to use?

```
curl -o /usr/local/bin/cloudcli https://raw.githubusercontent.com/devteds/cloudcli/master/cloudcli.sh
chmod +x /usr/local/bin/cloudcli

cd <WORKDIR>

# Example Commands
cloudcli exec helm version
cloudcli exec terraform version
cloudcli exec aws configure

# Work within CLI container (mounts current directory)
cloudcli ssh
> ls
> exit
```
