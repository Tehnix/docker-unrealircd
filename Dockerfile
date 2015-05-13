##############################################################################
# Docker file to build UnrealIRCd container images
# Based on Alpine Linux - https://github.com/gliderlabs/docker-alpine
##############################################################################
FROM gliderlabs/alpine:3.1
MAINTAINER Tehnix

# Set the correct locale environment
ENV LC_ALL C

RUN apk add --update \
    curl \
    #c-ares-dev \
    #c-ares \
    gcc \
    g++ \
    make \
    openssl-dev \
    #openssl \
    #pkgconfig \
    #sed \
    zlib-dev \
    #zlib \
    && rm -rf /var/cache/apk/*

# Download, configure and make UnrealIRCd from source
RUN curl https://www.unrealircd.org/downloads/Unreal3.2.10.3.tar.gz | tar xz && \
    cd Unreal3.2.10.3 && \
    ./configure \
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
      --enable-dynamic-linking && \
    make && \
    make install && \
    mkdir -p /usr/lib64/unrealircd/modules && \
    mv /etc/unrealircd/modules/* /usr/lib64/unrealircd/modules/ && \
    rm -rf Unreal3.2.10.3

# Expose IRC ports for plain and SSL connections
EXPOSE 6667
EXPOSE 6697

CMD ["/usr/bin/unrealircd", "-F"]
