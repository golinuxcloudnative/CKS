# Owerview 
Least privilege principle: give someone or run an app with fewer privileges as possible.


# Minimize host OS footprint (reduce attack surface)
## SSH Hardening
Config to auth using key pair. Do not use rsa lower than 
```
# create a key
ssh-keygen -t ed25519 -C user@email.com -f ˜./.ssh/id_ed25519
# check if the ssh agent is running
eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/id_ed25519
```

# Minimize IAM roles
# Minimize external access to the network
- Limit access to Node server.
- Only admins should have acces to node servers
- External access should be through VPN
- 
# Appropriately use kernel hardening tools such as AppArmor, seccomp