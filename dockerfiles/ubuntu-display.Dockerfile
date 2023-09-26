FROM ubuntu:latest

# taken from:
# https://stackoverflow.com/questions/16296753/can-you-run-gui-applications-in-a-linux-docker-container

RUN apt update && apt upgrade --yes && apt install sudo

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/developer
    # echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    # chmod 0440 /etc/sudoers.d/developer && \

RUN usermod -a -G sudo developer
RUN echo 'developer:developer' | chpasswd

USER developer

ENV HOME /home/developer
CMD /usr/bin/bash
