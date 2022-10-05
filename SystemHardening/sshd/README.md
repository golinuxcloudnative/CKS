```bash
docker build -t cks:sshd . ; \
docker rm -f cks-sshd; \
docker run --name cks-sshd -dit -p 2222:22 cks:sshd

# log
docker logs cks-sshd

# connect
docker exec -it cks-sshd bash

# ssh 
ssh -p 2222 root@localhost
```








