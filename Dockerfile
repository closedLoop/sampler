FROM ubuntu
MAINTAINER skruzel@astrocyte.io
RUN apt-get update
RUN apt-get install -y gnuplot python libpython2.7-dev default-jre default-jdk emacs postgresql postgresql-contrib git build-essential libnuma-dev bc unzip locales
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

RUN mkdir -p /data/sampler
VOLUME ["/data/sampler/"]
