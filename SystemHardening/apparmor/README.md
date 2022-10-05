- [Basic](#basic)
  - [Create profile](#create-profile)
- [How to use in](#how-to-use-in)
  - [Nerdctl](#nerdctl)
  - [Docker](#docker)
  - [Crictl](#crictl)
  - [Kubernetes](#kubernetes)
- [References](#references)

# Basic 
You need to have Apparmor enabled. Check if Kernel module is loaded.
```bash
cat /sys/kernel/security/lsm
> lockdown,capability,landlock,yama,apparmor
```

Check status

```bash
# check apparmor status
## Option 1 - it should show Y
cat /sys/module/apparmor/parameters/enabled
## Option 2 - cli
sudo aa-status
```

The profiles can be:
* enforced - monitor and enforce 
* complain - log the violations. Great for learning and developing a profile
* unconfined - there is no profile

Check the mode
```bash
/sys/module/apparmor/parameters/mode
```

List loaded profiles
```bash
cat /sys/kernel/security/apparmor/profiles
```

View events
```bash
journalctl -fx
```

Install utilities on Ubuntu
```bash
sudo apt install apparmor-easyprof apparmor-notify apparmor-utils certspotter
```

## Create profile
```bash
aa-genprof /path/to/bin
```

load a profile
 ```bash
 apparmor_parser /path/of/profile
 ```
unload a profile
 ```bash
 # option 1
 apparmor_parser -R /path/of/profile
 # permanent option
 ln -s /path/of/profile /etc/apparmor.d/disable/
 ```

# How to use in
## Nerdctl
```console
# list profiles
nerdctl apparmor ls
# show default profile nerdctl-profile
nerdctl apparmor inspect
# run container with default profile
nerdctl run --rm -d --name nginx-nerdctl nginx
nerdctl inspect nginx-nerdctl -f {{.AppArmorProfile}}
# run container with specific profile
nerdctl run -d --security-opt apparmor=docker-default --name nginx-nerdctl-profile nginx
nerdctl inspect nginx-nerdctl-profile -f {{.AppArmorProfile}}
```
## Docker
```console
# list profiles
root@lima-default:~# nerdctl apparmor ls
# show default profile nerdctl-profile
nerdctl apparmor inspect
# run container with default profile
docker run --rm -d --name nginx-docker nginx
docker inspect nginx-docker -f {{.AppArmorProfile}}
# run container with specific profile
docker run --rm -d --name nginx-docker-profile --security-opt apparmor=nerdctl-default nginx
docker inspect nginx-docker-profile -f {{.AppArmorProfile}}
```
## Crictl

## Kubernetes
It can be set by annotations in pod. `container.apparmor.security.beta.kubernetes.io/<container_name>: <profile_ref>`
where <profile_ref> can be:
* runtime/default to apply the runtime's default profile
* localhost/<profile_name> to apply the profile loaded on the host with the name <profile_name>
* unconfined to indicate that no profiles will be loaded

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: hello-apparmor
  annotations:
    # Tell Kubernetes to apply the AppArmor profile "k8s-apparmor-example-deny-write" in the hello container    
    container.apparmor.security.beta.kubernetes.io/hello: localhost/k8s-apparmor-example-deny-write
spec:
  containers:
  - name: hello
    image: busybox:1.28
    command: [ "sh", "-c", "echo 'Hello AppArmor!' && sleep 1h" ]
```


# References
* https://apparmor.net/
* https://ubuntu.com/tutorials/beginning-apparmor-profile-development#1-overview
* https://dockerlabs.collabnix.com/advanced/security/apparmor/
* https://kubernetes.io/docs/tutorials/security/apparmor/


