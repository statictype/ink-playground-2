FROM gitpod/workspace-full

USER gitpod

RUN bash -cl "rustup target add wasm32-unknown-unknown --toolchain stable \ 
  cargo install cargo-contract"