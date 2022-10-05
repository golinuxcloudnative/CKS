FROM ubuntu:22.04

RUN apt update && apt -qq install sudo vim curl rsync ca-certificates jq -y

RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 ubuntu \
    && echo 'root:ubuntu' | chpasswd \ 
    && echo 'ubuntu:ubuntu' | chpasswd

COPY /etc/vim/vimrc.local /etc/vim/vimrc.local
COPY usr/share/vim/vimXX/colors/onedark.vim /usr/share/vim/vim82/colors/onedark.vim
COPY usr/share/vim/vimXX/autoload/onedark.vim /usr/share/vim/vim82/autoload/onedark.vim
