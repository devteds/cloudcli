CLI_VERSION = 1.0.0
REPOSITORY = devteds/cloudcli

build:
	docker build -t ${REPOSITORY}:${CLI_VERSION} .
		
push:
	docker push ${REPOSITORY}:${CLI_VERSION}
	docker tag ${REPOSITORY}:${CLI_VERSION} ${REPOSITORY}:latest
	docker push ${REPOSITORY}:latest
