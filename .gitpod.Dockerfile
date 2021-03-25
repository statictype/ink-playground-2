FROM gitpod/workspace-full

USER gitpod

RUN rustup toolchain install nightly --target wasm32-unknown-unknown \
  --profile minimal --component rustfmt clippy miri rust-src && \
  rustup default nightly && \
  cargo install --features binaryen-as-dependency cargo-contract