FROM node
RUN apt update && apt upgrade --yes && apt install iputils-ping jq --yes
RUN npm install -g eas-cli
RUN git config --global --add safe.directory /source
CMD [ "bash" ]
