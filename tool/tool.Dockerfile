FROM ubuntu:focal

RUN apt update

### Front
RUN apt install -y git curl
RUN apt update
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install -y nodejs
RUN corepack enable
RUN mkdir /home/front

COPY ./front-verification-tool /home/front
RUN cd /home/front && yarn install

### Back
RUN mkdir /home/back

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN apt update
RUN DEBIAN_FRONTEND="noninteractive" apt install gcc -y
RUN DEBIAN_FRONTEND="noninteractive" apt install pkg-config libssl-dev -y
# RUN rustup default nightly

## SOLC-VERIFY
RUN apt update && DEBIAN_FRONTEND="noninteractive" apt install -y \
  cmake \
  curl \
  git \
  libboost-filesystem-dev \
  libboost-program-options-dev \
  libboost-system-dev \
  libboost-test-dev \
  python3-pip \
  software-properties-common \
  unzip \
  wget

RUN pip3 install psutil

RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
  && dpkg -i packages-microsoft-prod.deb \
  && apt update \
  && apt install -y apt-transport-https \
  && apt update \
  && apt install -y dotnet-sdk-3.1

# Get boogie
RUN dotnet tool install --global boogie --version 2.8.18
ENV PATH="${PATH}:/root/.dotnet/tools"

# Get and compile solc-verify
RUN git clone https://github.com/SRI-CSL/solidity.git \
  && cd solidity \
  && git checkout 0.7 \
  && mkdir -p build \
  && cd build \
  && cmake .. -DUSE_Z3=Off -DUSE_CVC4=Off \
  && make \
  && make install

RUN wget https://github.com/ethereum/solidity/releases/download/v0.5.17/solc-static-linux
RUN mv solc-static-linux /home/solc-static-linux-0.5.17
RUN chmod +x /home/solc-static-linux-0.5.17

RUN curl --silent "https://api.github.com/repos/Z3Prover/z3/releases/36678822" | grep browser_download_url | grep -E 'ubuntu' | cut -d '"' -f 4 | wget -qi - -O z3.zip \
  && unzip -p z3.zip '*bin/z3' > /usr/local/bin/z3 \
  && chmod a+x /usr/local/bin/z3

COPY ./verification-tool /home/back
RUN cd /home/back && cargo build

RUN mkdir /home/back/contracts/input
RUN chmod -R 777 /home/back/contracts

EXPOSE 3000
EXPOSE 8000


COPY run.sh /home

RUN apt update
RUN apt install -y sed
RUN sed -i 's/\r$//' /home/run.sh
RUN chmod +x ./home/run.sh

RUN ls /home

CMD ./home/run.sh
