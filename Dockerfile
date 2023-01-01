FROM debian:11-slim AS download-env

# wget to download
# unzip to unzip
# ca-certificates to make wget work with HTTPS
RUN apt-get update && apt-get install --no-install-recommends -y wget unzip ca-certificates

# We download 
# Releases here: https://github.com/OpenTTD/OpenGFX/releases
ARG OPENGFX_VERSION="7.1"
RUN wget -q -O /tmp/opengfx.zip "https://cdn.openttd.org/opengfx-releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip"
RUN unzip -p /tmp/opengfx.zip "opengfx-${OPENGFX_VERSION}.tar" >/tmp/opengfx.tar && rm -f /tmp/opengfx.zip

# Releases here: https://github.com/OpenTTD/OpenTTD/releases
ARG OPENTTD_VERSION="12.2"
RUN wget -q -O /tmp/openttd.deb "https://cdn.openttd.org/openttd-releases/${OPENTTD_VERSION}/openttd-${OPENTTD_VERSION}-linux-debian-bullseye-amd64.deb"



FROM debian:11-slim

# gdebi-core to install the .deb (gdebi-core does not have graphical UI install)
# ARG dependencies="gdebi-core wget unzip ca-certificates"
ARG dependencies="gdebi-core"
RUN apt-get update && apt-get install --no-install-recommends -y $dependencies

RUN mkdir -p /usr/share/games/openttd/baseset/
# We don't actually have to extract the tar archive, since openttd can read it
# RUN tar -xf /tmp/opengfx.tar --directory /usr/share/games/openttd/baseset/ && rm -f /tmp/opengfx.tar
COPY --from=download-env /tmp/opengfx.tar /usr/share/games/openttd/baseset/

COPY --from=download-env /tmp/openttd.deb /tmp/openttd.deb
RUN gdebi --non-interactive /tmp/openttd.deb && rm -f /tmp/openttd.deb


RUN apt-get remove -yqq $dependencies
RUN apt-get autoremove -yqq && apt-get autoclean -yqq
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN mkdir /app
RUN mkdir /app/data
RUN mkdir /app/config

ENV XDG_DATA_HOME=/app/data
ENV XDG_CONFIG_HOME=/app/config
ENV LOAD_TYPE=directory
ENV LOAD_FROM=/app/data/openttd/save/autosave

EXPOSE 3979/tcp
EXPOSE 3979/udp

COPY run-server.sh /app/
ENTRYPOINT [ "/app/run-server.sh" ]
CMD ["-D", "0.0.0.0:3979" ]
