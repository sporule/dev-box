# Dev Boxes


Example SSH Config file, private_key is the default ssh key to authenticate to the box with root account.

```
Host DevNode
    HostName localhost
    User root
    Port 10022
    IdentityFile C:\dev-box\private_key
    StrictHostKeyChecking no
    UserKnownHostsFile C:\No-exist.txt
```


# Dangerous

Do not use this image in public network without replacing the SSH Key.