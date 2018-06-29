package = totto

env = PKG_CONFIG_ALLOW_CROSS=1 #OPENSSL_INCLUDE_DIR=/usr/local/opt/openssl/include
cargo = $(env) cargo
rustc = $(env) rustc
debug-env = RUST_BACKTRACE=1 RUST_LOG=$(package)=debug
debug-cargo = $(env) $(debug-env) cargo
export CI_REGISTRY_IMAGE ?= registry.gitlab.com/kerscher/totto
export CI_BUILD_REF_SLUG ?= untrusted
export CI_BUILD_LIB_TYPE ?= unknown
export CI_PIPELINE_ID ?= $(shell date +"%Y-%m-%d-%s")
export DOCKER_IMAGE_CURRENT ?= ${CI_REGISTRY_IMAGE}:${CI_BUILD_LIB_TYPE}_${CI_BUILD_REF_SLUG}_${CI_PIPELINE_ID}
export DOCKER_IMAGE_LATEST ?= ${CI_REGISTRY_IMAGE}:${CI_BUILD_LIB_TYPE}_latest

build:
	$(cargo) build

version:
	@$(rustc) --version
	@$(cargo) --version

build-dynamic-release:
	$(cargo) build --release

build-static-release:
	$(cargo) build --target x86_64-unknown-linux-musl --release

build-dynamic-image:
	@docker build -t "${DOCKER_IMAGE_CURRENT}" -f ./etc/docker/dynamic/Dockerfile .
	@docker tag "${DOCKER_IMAGE_CURRENT}" "${DOCKER_IMAGE_LATEST}"

build-static-image:
	@docker build -t "${DOCKER_IMAGE_CURRENT}" -f ./etc/docker/static/Dockerfile .
	@docker tag "${DOCKER_IMAGE_CURRENT}" "${DOCKER_IMAGE_LATEST}"

push:
	@docker push "${DOCKER_IMAGE_CURRENT}"
	@docker push "${DOCKER_IMAGE_LATEST}"

run-docker:
	docker run -t "${DOCKER_IMAGE_LATEST}"

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

.PHONY : build version build-dynamic-release build-static-release build-dynamic-image build-static-image push run-docker clippy run install test test-debug fmt watch dev-deps
