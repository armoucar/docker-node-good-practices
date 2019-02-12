FROM ubuntu
MAINTAINER David Weinstein <david@bitjudo.com>

ENV DEBIAN_FRONTEND noninteractive

# install our dependencies and nodejs
RUN apt-get update
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y curl
RUN apt-get install -y gnupg2

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# use changes to package.json to force Docker not to use the cache
# when we change our application's nodejs dependencies:
ADD package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/

# From here we load our application's code in, therefore the previous docker
# "layer" thats been cached will be used if possible
WORKDIR /opt/app
ADD . /opt/app

EXPOSE 3000

CMD ["node", "server.js"]
