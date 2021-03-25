FROM gitpod/workspace-full

USER gitpod

RUN bash -cl "rustup default stable \ rustup install nightly \ rustup component add rust-src --toolchain nightly \ rustup target add wasm32-unknown-unknown --toolchain stable \ 
  cargo install cargo-contract"