# Dev Box


Example SSH Config file, private_key is the default ssh key to authenticate to the box with root account.

```
Host DevNode
    HostName localhost
    User sporule
    Port 10022
    UserKnownHostsFile C:\No-exist.txt
```

# Dangerous

You will need to update username and password in dev-box.env.
VSCode tunnel is activated at start up, you will need to check the unique link from the logs to authenticate to obtain permission

