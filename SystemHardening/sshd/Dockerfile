FROM cks:base

RUN apt update && apt -qq install openssh-server sudo -y

RUN service ssh start

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]