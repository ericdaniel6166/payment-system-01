.PHONY: maven-install docker-build docker-push docker-image-rm docker-up docker-down

SERVICES_MAVEN_INSTALL := \
	starter-service-01 \
	channel-sync-service-01 \
	sales-channel-service-01 \
	payment-service-01


maven-install:
	@echo "Maven install for: $(SERVICES_MAVEN_INSTALL)"
	@set -e; \
	for dir in $(SERVICES_MAVEN_INSTALL); do \
		echo "\n>>> Building $$dir"; \
		( cd ../$$dir && ./mvnw clean install -Dmaven.test.skip ); \
	done
	@echo "\n✅ All modules built"

# ⇩ Pass the tag at the CLI:  make docker-build TAG=1.2.3
#   Defaults to “latest” when you omit it.
TAG ?= latest
FROM_TAG  ?= latest      # old tag
USER      ?=             # e.g. abc   (NO slash)

# Optional: prepend a registry, e.g. “mycorp.registry.io/”
REGISTRY ?=

# Optional: prepend a registry, e.g. “mycorp.registry.io/”
REGISTRY ?=

SERVICES := \
	channel-sync-service-01 \
	sales-channel-service-01 \
	payment-service-01

docker-build:
	@set -e; \
	for dir in $(SERVICES); do \
		echo "\n>>> Building $${dir}:${TAG}"; \
		( cd ../$${dir} && \
		  docker build -t $(REGISTRY)$${dir}:$(TAG) . ); \
	done
	@echo "\n✅  All images built & tagged as '${TAG}'"


# Build a prefix once: “abc/” when USER is set, otherwise empty
USER_PREFIX := $(if $(USER),$(USER)/,)

docker-tag:
	@set -e; \
	for img in $(SERVICES); do \
		echo "🏷️  Tagging $$img:$(FROM_TAG) → $(USER_PREFIX)$$img:$(TAG)"; \
		docker tag $$img:$(FROM_TAG) $(USER_PREFIX)$$img:$(TAG); \
	done
	@echo "\n✅  All images retagged with ‘$(TAG)’"

# Build the registry prefix *once*; adds the trailing slash only if REGISTRY is set
REGISTRY_PREFIX := $(if $(REGISTRY),$(REGISTRY)/,)

docker-push:
	@set -e; \
	for img in $(SERVICES); do \
		echo "🛰️  Pushing $(REGISTRY_PREFIX)$(USER)/$$img:$(TAG)"; \
		docker push $(REGISTRY_PREFIX)$(USER)/$$img:$(TAG); \
	done
	@echo "\n✅  All images pushed to $(if $(REGISTRY),$(REGISTRY), Docker Hub) under ‘$(USER)’ with tag ‘$(TAG)’"
# --------------------------------------------------------------------

docker-image-rm:
	docker image ls --filter "reference=*-01" -q | xargs -r docker image rm

docker-up:
	docker compose -f ./compose.docker.yml up -d

docker-down:
	docker compose -f ./compose.docker.yml down -v
