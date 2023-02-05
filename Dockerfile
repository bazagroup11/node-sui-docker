FROM rust:1.65.0 AS chef

USER root

WORKDIR /

RUN apt-get update\
  && apt-get install -y --no-install-recommends\
  tzdata\
  ca-certificates\
  build-essential\
  pkg-config\
  cmake \
  sudo

RUN sudo apt-get update
RUN sudo apt install -y curl
RUN sudo apt-get install -y git
RUN sudo apt-get install -y libssl-dev
RUN sudo apt-get install -y libclang-dev 

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -y | sh
RUN rustup update stable

RUN sudo apt-get -y install cmake

RUN git clone https://github.com/MystenLabs/sui.git
RUN cd sui 
RUN git init 

RUN git remote add upstream https://github.com/MystenLabs/sui &&\
  git fetch upstream &&\
  git checkout --track upstream/devnet

RUN cp crates/sui-config/data/fullnode-template.yaml fullnode.yaml

RUN curl -fLJO https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob

# EXPOSE 9000

RUN cargo run --release --bin sui-node -- --config-path fullnode.yaml