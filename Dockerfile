FROM debian:11-slim

# gdebi to install the .deb
# wget to download
# unzip to unzip
# ca-certificates to make wget work with HTTPS
ARG dependencies="gdebi wget unzip ca-certificates"
RUN apt-get update && apt-get install --no-install-recommends -y $dependencies

ARG OPENTTD_VERSION="12.2"
ARG OPENGFX_VERSION="0.6.1"

RUN wget -q -O /tmp/openttd.deb "https://cdn.openttd.org/openttd-releases/${OPENTTD_VERSION}/openttd-${OPENTTD_VERSION}-linux-debian-bullseye-amd64.deb"
RUN gdebi --non-interactive /tmp/openttd.deb

RUN wget -q -O /tmp/opengfx.zip "https://cdn.openttd.org/opengfx-releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip"
RUN mkdir -p /usr/share/games/openttd/baseset/
RUN unzip -p /tmp/opengfx.zip "opengfx-${OPENGFX_VERSION}.tar" >/tmp/opengfx.tar && rm -f /tmp/opengfx.zip
RUN tar -xf /tmp/opengfx.tar --directory /usr/share/games/openttd/baseset/ && rm -f /tmp/opengfx.tar

RUN apt-get remove -yqq $dependencies
RUN apt-get autoremove -yqq && apt-get autoclean -yqq
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN mkdir /app
RUN mkdir /app/data
RUN mkdir /app/config

ENV XDG_DATA_HOME=/app/data
ENV XDG_CONFIG_HOME=/app/config
ENV LOAD_TYPE=directory
ENV LOAD_FROM=/app/data/save/autosave

EXPOSE 3979/tcp
EXPOSE 3979/udp

COPY run-server.sh /app/
ENTRYPOINT [ "/app/run-server.sh" ]
CMD ["-D", "0.0.0.0:3979" ]
