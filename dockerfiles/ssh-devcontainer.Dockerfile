FROM ubuntu:rolling
WORKDIR /source
# I use openssh in my dev container because I ssh into it. I cannot use
# vscode dev containers extensions because I run docker on another machine and
# although I can ssh into that machine, it's running NixOS, therefore vscode cannot
# ssh into it with remote ssh extension, to then from there run dev containers extension into docker.
# I have to ssh directly into a container running on different host.
# (vscode remote ssh extension tries to download vscode-server on remote host that runs docker and fails)
# TODO: fix that (the fix will be in https://github.com/robert-dorna/dotfiles) so that I
# can simplify this (remote ssh login) and use devcontainer.json
RUN apt update && apt upgrade --yes && apt install \
  openssh-server sudo curl git gcc g++ neovim python3 python3-pip python3-venv python3-poetry nodejs npm --yes
# RUN useradd -rm -d /home/developer -s /bin/bash -g root -u 1000 -G sudo developer
RUN echo 'ubuntu:ubuntu' | chpasswd
EXPOSE 22
# RUN mkdir /var/run/sshd
CMD ["/usr/sbin/sshd", "-D"]
