REGISTRY ?= docker.io
TAG ?= v1

IMAGE := $(REGISTRY)/hgrange/java-grpc-connector-template:$(TAG)

ifeq ($(shell uname -s),Darwin)
	# gnu-sed, can be installed using homebrew
	SED_EXE := gsed
else
	SED_EXE := sed
endif

docker-login:
	docker login $(REGISTRY) -u "$$REGISTRY_USERNAME" -p "$$REGISTRY_PASSWORD"

docker-build:
	chmod ug+x container/import-certs.sh
	docker build -f container/Dockerfile -t $(IMAGE) .

docker-push:
	podman push $(IMAGE)

.PHONY: format
format:
	mvn formatter:format

.PHONY: lint-check
lint-check:
	mvn pmd:check formatter:validate -Dpmd.printFailingErrors=true

.PHONY: test
test:
	mvn test
