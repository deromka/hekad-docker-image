FROM golang:1.5.1
MAINTAINER Roman Dembitsky <romande@gmail.com>



# Labels
LABEL description="hekad image" \
      image_version="v0.10.0b1-1"

# ENV

ENV REFRESHED_AT $DATE

ENV HEKAD_VERSION v0.10.0b1

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y cmake python-sphinx protobuf-compiler debhelper && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN git clone -b ${HEKAD_VERSION} --depth 1 https://github.com/mozilla-services/heka.git /heka

WORKDIR /heka
RUN /bin/bash -c 'source build.sh'

RUN for i in decoders encoders filters modules; do \
        mkdir -p /usr/share/heka/lua_${i} && \
        cp /heka/sandbox/lua/${i}/* /usr/share/heka/lua_${i}; \
    done && \
    cp /heka/build/heka/lib/luasandbox/modules/* /usr/share/heka/lua_modules

EXPOSE 4881 5565

WORKDIR /scripts
COPY run-hekad.sh /scripts/run-hekad.sh
COPY hekad.toml.j2 /scripts/hekad.toml.j2
COPY use-arguments.sh /scripts/use-arguments.sh
COPY evaluate-template-file.py /scripts/evaluate-template-file.py

RUN chmod 755 /scripts/*


ENTRYPOINT ["/scripts/run-hekad.sh"]