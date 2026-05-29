OPENUSD_BUILDER_IMAGE ?= openusd-builder:local
OPENUSD_BUILDER_CONTEXT := openusd-builder

.PHONY: build-openusd-builder test-openusd-builder run-openusd-builder

build-openusd-builder:
	docker build -t $(OPENUSD_BUILDER_IMAGE) $(OPENUSD_BUILDER_CONTEXT)

test-openusd-builder:
	docker run --rm $(OPENUSD_BUILDER_IMAGE) smoke-test-openusd-builder

run-openusd-builder:
	docker run --rm -it -v "$(CURDIR):/workspace" $(OPENUSD_BUILDER_IMAGE) bash
