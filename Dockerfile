##############################################################################
# Docker file to build UnrealIRCd container images
# Based on Alpine Linux - https://github.com/gliderlabs/docker-alpine
##############################################################################
FROM debian:latest
MAINTAINER ckl@codetalk.io

# Set the correct locale environment
ENV LC_ALL C

# Install necessary packages and clean up afterwards
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && apt-get install -yq \
        build-essential \
        curl \
        libssl-dev \
        libcurl4-openssl-dev \
        libgcrypt11-dev \
        zlib1g \
        zlib1g-dev \
        zlibc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

# Add script to generate the SSL certificate and execute it
COPY ssl-certificate.sh /tmp/
RUN /tmp/ssl-certificate.sh \
    && mv server.cert.pem /etc/unrealircd/ \
    && mv server.key.pem /etc/unrealircd/

# Copy configuration files into place
COPY unrealircd-config /etc/unrealircd/

# Expose IRC ports for plain and SSL connections
EXPOSE 6667
EXPOSE 6697

CMD ["/usr/bin/unrealircd", "-F"]
