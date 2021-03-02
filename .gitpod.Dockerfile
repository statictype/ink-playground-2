ARG VCS_REF=master
ARG BUILD_DATE
ARG REGISTRY_PATH=paritytech

FROM ${REGISTRY_PATH}/base-ci-linux:latest

# metadata
LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="${REGISTRY_PATH}/ink-ci-linux" \
	io.parity.image.description="Inherits from base-ci-linux:latest. \
rust nightly, clippy, rustfmt, miri, rust-src grcov, rust-covfix, cargo-contract, xargo, binaryen" \
	io.parity.image.source="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/Dockerfile" \
	io.parity.image.documentation="https://github.com/paritytech/scripts/blob/${VCS_REF}/\
dockerfiles/ink-ci-linux/README.md" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}"

WORKDIR /builds

ENV SHELL /bin/bash

RUN	set -eux; \
# The supported Rust nightly version must support the following components
# to allow for a functioning CI pipeline:
#
#  - cargo: General build tool.
#  - rustfmt: Rust formatting tool.
#  - clippy: Rust linter.
#  - miri: Rust interpreter with additional safety checks.
#
# We also need to install the wasm32-unknown-unknown target to test
# ink! smart contracts compilation for this target architecture.
#
# Only Rust nightly builds supporting all of the above mentioned components
# and targets can be used for this docker image.
#
# Installs the latest common nightly for the listed components,
# adds those components, wasm target and sets the profile to minimal
	rustup toolchain install nightly --target wasm32-unknown-unknown \
		--profile minimal --component rustfmt clippy miri rust-src; \
	rustup default nightly; \
# We require `xargo` so that `miri` runs properly
# We require `grcov` for coverage reporting and `rust-covfix` to improve it.
	cargo install grcov rust-covfix xargo cargo-contract; \
# `cargo-contract` requires `binaryen` for optimizing Wasm files
	apt-get -y update; \
	apt-get install -y --no-install-recommends binaryen; \
# versions
	rustup show; \
	cargo --version; \
	wasm-opt --version; \
	cargo-contract --version; \
# Clean up and remove compilation artifacts that a cargo install creates (>250M).
	rm -rf "${CARGO_HOME}/registry" "${CARGO_HOME}/git" /root/.cache/sccache; \
# apt clean up
	apt-get autoremove -y; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/*