# Dev Boxes


Example SSH Config file, private_key is the default ssh key to authenticate to the box with root account.

```
Host DevNode
    HostName localhost
    User sporule
    Port 10022
    UserKnownHostsFile C:\No-exist.txt
```

# Dangerous

You will need to update username and password in dev-box.env
VSCode tunnel is activated at start up, you will need to authenticate to obtain permission
Do not use this image in public network without replacing the SSH Key.
Now it supports the individual users rather than root account.
