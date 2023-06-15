FROM ubuntu:latest
RUN apt update --yes && apt upgrade --yes && apt install openjdk-19-jre wget --yes
RUN wget https://github.com/google/bundletool/releases/download/1.14.1/bundletool-all-1.14.1.jar
CMD [ "bash" ]
