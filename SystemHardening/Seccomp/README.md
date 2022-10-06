# Basic

Trace a command `strace ls -l`

> `execve("/usr/bin/ls", ["ls", "-l"], 0xffffe60cada8 /* 20 vars */) = 0`
> * execve - syscall that executes the program
> * /usr/bin/ls - command path
> * ["ls", "-l"] - args
> * 0xffffe60cada8 /* 20 vars */) - 20 env vars
> * = 0 - no errors


Trace a process `strace -p PID`


# AquaSec Tracee

```bash
docker run \
  --name tracee --rm -it \
  --pid=host --cgroupns=host --privileged \
  -v /etc/os-release:/etc/os-release-host:ro \
  -e LIBBPFGO_OSRELEASE_FILE=/etc/os-release-host \
  aquasec/tracee:latest
```





