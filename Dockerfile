##############################################################################
# Docker file to build UnrealIRCd container images
# Based on Alpine Linux - https://github.com/gliderlabs/docker-alpine
##############################################################################
FROM debian:latest
MAINTAINER ckl@codetalk.io

# Set the correct locale environment
ENV LC_ALL C

# Install necessary packages and clean up afterwards
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        curl \
        libssl-dev \
        libcurl4-openssl-dev \
        libgcrypt11-dev
        zlib1g \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add script to generate the SSL certificate
COPY ssl-certificate.sh /etc/unrealircd

# Download, configure and make UnrealIRCd from source
RUN curl https://www.unrealircd.org/downloads/Unreal3.2.10.4.tar.gz | tar xz \
    && cd /Unreal3.2.10.4 \
    && ./configure \
        --enable-ssl=/etc/ssl/localcerts/ \
        --with-showlistmodes \
        --with-listen=5 \
        --with-dpath=/etc/unrealircd/ \
        --with-spath=/usr/bin/unrealircd \
        --with-nick-history=2000 \
        --with-sendq=3000000 \
        --with-bufferpool=18 \
        --with-permissions=0600 \
        --with-fd-setsize=1024 \
        --enable-dynamic-linking \
    && make \
    && make install \
    && mkdir -p /usr/lib64/unrealircd/modules \
    && mv /etc/unrealircd/modules/* /usr/lib64/unrealircd/modules/ \
    && rm -rf /Unreal3.2.10.4
    && cd /etc/unrealircd
    && ssl-certificate.sh

# Copy configuration files into place
COPY unrealircd-config/ircd.motd /etc/unrealircd/
COPY unrealircd-config/*.conf /etc/unrealircd/
COPY unrealircd-config/config/ /etc/unrealircd/config
COPY unrealircd-config/aliases/ /etc/unrealircd/aliases

# Expose IRC ports for plain and SSL connections
EXPOSE 6667
EXPOSE 6697

#CMD ["/usr/bin/unrealircd", "-F"]
#CMD ["/bin/bash"]
