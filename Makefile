package = totto

env = OPENSSL_INCLUDE_DIR=/usr/local/opt/openssl/include
cargo = $(env) cargo
debug-env = RUST_BACKTRACE=1 RUST_LOG=$(package)=debug
debug-cargo = $(env) $(debug-env) cargo
export CI_REGISTRY_IMAGE ?= registry.gitlab.com/bitemyapp/totto
export CI_PIPELINE_ID ?= ${shell date +"%Y-%m-%d-%s"}

build:
	$(cargo) build

version:
	rustc --version
	cargo --version

build-release: version
	$(cargo) build --release

build-static-release:
	cargo build --target x86_64-unknown-linux-musl --release

## Build docker image
build-image:
	@docker build -t "${CI_REGISTRY_IMAGE}:pipeline-${CI_PIPELINE_ID}" .
	@docker tag "${CI_REGISTRY_IMAGE}:pipeline-${CI_PIPELINE_ID}" "${CI_REGISTRY_IMAGE}:pipeline-current"

## Push docker image to registry
push:
	@docker push "${CI_REGISTRY_IMAGE}:pipeline-${CI_PIPELINE_ID}"
	@docker push "${CI_REGISTRY_IMAGE}:pipeline-current"

run-docker:
	docker run -t "${CI_REGISTRY_IMAGE}:pipeline-current"

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

