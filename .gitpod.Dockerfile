FROM gitpod/workspace-full

USER gitpod

RUN rustup component add rust-src --toolchain nightly \
  rustup target add wasm32-unknown-unknown --toolchain nightly \ 
  rustup toolchain install nightly \
  cargo install cargo-contract --vers 0.10.0 --force --locked