# Getting Started
First thing first, there are two things that must be done:

1. `$ cp sample-config unrealircd-config`
2. `$ cp sample-ssl-certificate.sh ssl-certificate.sh`

After this, you might wanna take a look at both the `ssl-certificate.sh` script and the config files. While the defaults will work, it will probably be more interesting to have your own custom information there.

### Network Operator

Finally, if you want to create a network operator, you can copy the `sample-oper.conf` into the newly created `unrealircd-config/config/` folder. It will automatically pick up any files that end up `*.conf` in that folder, so you can keep each oper in their own file, if desired.

Please do remember to change the default nickname and password!


# Building and Running
Now, you're ready to build the Docker image

```bash
$ docker build -t ircd .
```

and then run the IRCd with,

```bash
$ docker run -d -p 6667:6667 -p 6697:6697 ircd
```

This maps the internal ports to the same external points and starts the `unrealircd` process in the foreground. You should now be all set! :)


# Making Sure It Works
You can either try to connect with your IRC client, or just throw a quick _telnet_ command after it,


```bash
telnet 127.0.0.1 6667
```


# FAQ
**Q:** UnrealIRCd stops after "Inizializing SSL."?

**A:** You're missing your server.cert.pem for the SSL connections, make sure the `ssl-certificate.sh` script ran (and that you remembered to create it).

---

**Q:** Where are the UnrealIRCd logs?

**A:** It logs to /var/log/ircd.log.

---

**Q:** I get a `/bin/sh: 1: ssl-certificate.sh: Permission denied` error when building?

**A:** Your ssl-certificate.sh script is probably not executable, so you need to run `chmod +x ssl-certificate.sh` on it.
