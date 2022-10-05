Tradicional Linux (< Kernel 2.2) had type of process `privileged` (root uid 0) and `unprivileged` (uid != 0). Where Kernel did not check permission for privileged processes. 

From Kernel 2.2 it has changed to 

SUID bit


## Basic

Get Linux capabilities of a binary

```bash
getcap 

ls  /bin/* | xargs getcap
```

Get Linux capabilities of the process
```console
# get listining process
dev@ops:~$ ss -lntp
State    Recv-Q  Send-Q   Local Address:Port    Peer Address:Port  Process                                             
LISTEN   0       4096         127.0.0.1:46005        0.0.0.0:*      users:(("containerd",pid=6844,fd=14))              
LISTEN   0       4096     127.0.0.53%lo:53           0.0.0.0:*      users:(("systemd-resolve",pid=610,fd=14))          
LISTEN   0       128            0.0.0.0:22           0.0.0.0:*      users:(("sshd",pid=709,fd=3))                      
LISTEN   0       128               [::]:22              [::]:*      users:(("sshd",pid=709,fd=4))

# getting caps of containerd, pid=6844
getpcaps 6844

# getting caps of sshd, pid=709
getpcaps 709
#>709=ep


# all process's caps
ps -ef |awk {'print $2'} | xargs getpcaps

```

has ALL the capabilites permitted (p) and effective (e) from the start.
It means the capabilities will be put in the permitted set (p), and all permitted capabilities will be copied into the effective set (e).

The e is used for legacy programs (possibly most programs at the current time), that is programs that don't know about capabilities, so can not them-selves copy capabilities from permitted to effective.


https://www.kernel.org/doc/ols/2008/ols2008v1-pages-163-172.pdf
https://man7.org/linux/man-pages/man7/capabilities.7.html
https://materials.rangeforce.com/tutorial/2020/02/19/Linux-PrivEsc-Capabilities/ 


## Extended
getpcaps 1
getpcaps -iab 1
capsh --explain=40