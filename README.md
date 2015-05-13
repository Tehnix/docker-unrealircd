# Getting Started
First thing first, there are two things that must be done:

1) `cp sample-config unrealircd-config` and customize it to your need
2) `cp sample-ssl-certificate.sh ssl-certificate.sh` and change the information to want you want

# Building and Running
Now, you're ready to build the Docker image

```bash
docker build -t ircd .
```

and then run the IRCd with,

```bash
docker run -i -P -t ircd
```

You should be ready to go! :)

# FAQ

Q: UnrealIRCd stops after "Inizializing SSL."?

A: You're missing your server.cert.pem for the SSL connections.

---

Q: Where does UnrealIRCd log?

A: It logs to /var/log/ircd.log. This can be changed in the file `include/config.h` before building the IRCd.