FROM gitpod/workspace-full

USER gitpod

RUN bash -cl "rustup component add rust-src --toolchain nightly \
  rustup target add wasm32-unknown-unknown --toolchain stable \ 
  rustup toolchain install nightly \
  cargo install cargo-contract"