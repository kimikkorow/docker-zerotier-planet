FROM ubuntu:20.04
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    GITHUB_PROXY=https://github.yuilier.eu.org/

ADD . /app

RUN cd /app && sh init.sh

WORKDIR /app/
CMD /bin/sh -c "zerotier-one -d; cd /opt/ztncui/src;npm start"
