package = your-package-name

env = OPENSSL_INCLUDE_DIR="/usr/local/opt/openssl/include"
cargo = $(env) cargo
debug-env = RUST_BACKTRACE=1 RUST_LOG=$(package)=debug
debug-cargo = $(env) $(debug-env) cargo
export CI_REGISTRY_IMAGE ?= "registry.gitlab.com/bitemyapp/totto"

build:
	$(cargo) build

version:
	rustc --version
	cargo --version

build-release: version
	$(cargo) build --release

## Build docker image
build-image: version
	@docker build -t "${CI_REGISTRY_IMAGE}:totto" .

## Push docker image to registry
push:
	@docker push "${CI_REGISTRY_IMAGE}:totto"

run-docker:
	docker run -t "${CI_REGISTRY_IMAGE}:totto"

clippy:
	$(cargo) clippy

run: build
	./target/debug/$(package)

install:
	$(cargo) install --force

test:
	$(cargo) test

test-debug:
	$(debug-cargo) test -- --nocapture

fmt:
	$(cargo) fmt

watch:
	$(cargo) watch

# You need nightly for rustfmt at the moment
dev-deps:
	$(cargo) install fmt
	$(cargo) install clippy
	$(cargo) install rustfmt-nightly

.PHONY : build build-release run install test test-debug fmt watch dev-deps

