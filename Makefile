IMAGE = afreisinger/gatsby
PLATFORMS = linux/amd64,linux/arm64
NODE_VERSION = $(shell grep "^FROM" Dockerfile | head -n 1 | sed 's/.*://;s/-.*//')
IMAGE_LATEST = $(IMAGE):latest
IMAGE_VERSION = $(IMAGE):$(NODE_VERSION)

# ANSI color codes
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[0;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

.PHONY: all
all: build

.PHONY: build
build:
	@printf "$(BLUE)Starting Docker build...$(NC)\n"
	@printf "$(GREEN)Building Docker image for platforms: $(PLATFORMS) with tags: $(IMAGE_LATEST) and $(IMAGE_VERSION)$(NC)\n"
	@if ! docker buildx inspect dev-builder >/dev/null 2>&1; then \
		printf "$(YELLOW)Creating and using buildx builder...$(NC)\n"; \
		docker buildx create --name dev-builder --use; \
		docker buildx inspect --bootstrap; \
	fi
# docker buildx build --platform $(PLATFORMS) -t $(IMAGE_LATEST) -t $(IMAGE_VERSION) --progress=plain --output=type=local,dest=./output .
	docker buildx build --progress plain --platform $(PLATFORMS) -t $(IMAGE_LATEST) -t $(IMAGE_VERSION) --push .

.PHONY: build-no-cache
build-no-cache:
	@printf "$(BLUE)Starting Docker build...$(NC)\n"
	@printf "$(GREEN)Building Docker image for platforms: $(PLATFORMS) with tags: $(IMAGE_LATEST) and $(IMAGE_VERSION)$(NC)\n"
	@if ! docker buildx inspect dev-builder >/dev/null 2>&1; then \
		printf "$(YELLOW)Creating and using buildx builder...$(NC)\n"; \
		docker buildx create --name dev-builder --use; \
		docker buildx inspect --bootstrap; \
	fi
	docker buildx build --platform $(PLATFORMS) -t $(IMAGE_LATEST) -t $(IMAGE_VERSION) --progress=plain --no-cache --push .

.PHONY: push
push:
	@printf "$(BLUE)Pushing Docker image $(IMAGE_LATEST) and $(IMAGE_VERSION) to registry...$(NC)\n"
	docker push $(IMAGE_LATEST)
	docker push $(IMAGE_VERSION)

.PHONY: clean
clean:
	@printf "$(RED)Removing buildx builder$(NC)\n"
	docker buildx rm dev-builder

.PHONY: rebuild
rebuild: clean build

