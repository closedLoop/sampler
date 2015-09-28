FROM ubuntu
MAINTAINER skruzel@astrocyte.io
RUN apt-get update
RUN apt-get install -y gnuplot python libpython2.7-dev default-jre default-jdk emacs postgresql postgresql-contrib git build-essential libnuma-dev bc unzip locales
RUN apt-get install -y cmake
RUN locale-gen en_US en_US.UTF-8 && dpkg-reconfigure locales

ENV USER=root
WORKDIR /root
#RUN git clone https://github.com/closedLoop/sampler.git
ADD . sampler
WORKDIR /root/sampler
# ENV DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash

RUN ["/bin/bash", "-c", "make dep"]
RUN ["/bin/bash", "-c", "make"]
RUN ["/bin/bash", "-c", "make test"]

RUN mkdir -p /data/graph
RUN mkdir -p /data/out
VOLUME ["/data/graph/"]
VOLUME ["/data/out/"]

ENTRYPOINT ["./dw", "gibbs", "-w /data/graph/graph.weights", "-v /data/graph/graph.variables", "-f /data/graph/graph.factors", "-e /data/graph/graph.edges", "-m /data/graph/graph.meta", "-o /data/out"]
CMD ["-i 500",  "-s 1", "-l 1000"]

