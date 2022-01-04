# Spawn-based FMU complier and simulator. See the README in the
# projects repository <LINK TK>

FROM ubuntu:20.04
ENV MODELON_LICENSE_PATH /home/simulator
ENV SPAWN_VERSION v0.2.1
ENV SPAWN_FILE Spawn-0.2.1-5d127d5774-Linux

RUN apt update && apt install -y \
        libncurses5 \
		clang-8 \
		vim \
    	wget && \
    cd /opt && \
    wget https://github.com/NREL/Spawn/releases/download/${SPAWN_VERSION}/${SPAWN_FILE}.tar.gz && \
    tar xzf /opt/${SPAWN_FILE}.tar.gz && \
    mv /opt/${SPAWN_FILE}/ /opt/spawn && \
    ln -s /opt/spawn/bin/spawn /usr/local/bin/

COPY modelica-buildings /sim/modelica-buildings

# copy the examples into the container, these are also used in the tests
COPY examples /sim/examples

# If using Optimica, then copy license file here. The license must match 
# the mac address that is configured when launching this container
RUN mkdir /home/simulator
COPY README.md license.l* /home/simulator/

WORKDIR /sim
