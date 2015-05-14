#!/bin/bash
openssl req \
    -x509 \
    -newkey rsa:2048 \
    -keyout server.key.pem \
    -out server.cert.pem \
    -days 730 \
    -nodes \
    -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com"
