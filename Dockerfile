FROM kimikkorow/ubuntu20.04:python3-npm
ENV TZ=Asia/Shanghai \
    DEBIAN_FRONTEND=noninteractive \
    GITHUB_PROXY=https://ghproxy.com/

ADD . /app

RUN cd /app && sh init.sh

WORKDIR /app/
CMD /bin/sh -c "zerotier-one -d; cd /opt/ztncui/src;npm start"
