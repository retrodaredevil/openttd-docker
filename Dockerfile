FROM debian:11-slim AS download-env

# wget to download
# unzip to unzip
# ca-certificates to make wget work with HTTPS
RUN apt-get update && apt-get install --no-install-recommends -y wget unzip xz-utils ca-certificates

# We download 
# Releases here: https://github.com/OpenTTD/OpenGFX/releases
ARG OPENGFX_VERSION="7.1"
RUN wget -q -O /tmp/opengfx.zip "https://cdn.openttd.org/opengfx-releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip"
RUN unzip -p /tmp/opengfx.zip "opengfx-${OPENGFX_VERSION}.tar" >/tmp/opengfx.tar && rm -f /tmp/opengfx.zip

# Releases here: https://github.com/OpenTTD/OpenTTD/releases
ARG OPENTTD_VERSION="13.3"
RUN wget -q -O /tmp/openttd.tar.xz "https://cdn.openttd.org/openttd-releases/${OPENTTD_VERSION}/openttd-${OPENTTD_VERSION}-linux-generic-amd64.tar.xz"
RUN tar -xf /tmp/openttd.tar.xz -C /tmp && mv /tmp/openttd-${OPENTTD_VERSION}-linux-generic-amd64 /tmp/openttd


FROM debian:11-slim


RUN mkdir -p /usr/share/games/openttd/baseset/
# We don't actually have to extract the tar archive, since openttd can read it
# RUN tar -xf /tmp/opengfx.tar --directory /usr/share/games/openttd/baseset/ && rm -f /tmp/opengfx.tar
COPY --from=download-env /tmp/opengfx.tar /usr/share/games/openttd/baseset/

COPY --from=download-env /tmp/openttd /opt/openttd

RUN mkdir /app /app/data /app/config

ENV XDG_DATA_HOME=/app/data
ENV XDG_CONFIG_HOME=/app/config
ENV LOAD_TYPE=directory
ENV LOAD_FROM=/app/data/openttd/save/autosave

EXPOSE 3979/tcp
EXPOSE 3979/udp

COPY run-server.sh /app/
ENTRYPOINT [ "/app/run-server.sh" ]
CMD ["-D", "0.0.0.0:3979" ]
