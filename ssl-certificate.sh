#!/bin/bash
openssl req \
    -x509 \
    -newkey rsa:2048 \
    -keyout server.key.pem \
    -out server.cert.pem \
    -days 730 \
    -nodes \
    -subj "/C=DK/ST=None/L=Copenhagen/O=codetalk/OU=IT/CN=codetalk.io"
