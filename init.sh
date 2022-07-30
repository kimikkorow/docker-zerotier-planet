echo "更换腾讯源"
echo "deb https://mirrors.cloud.tencent.com/ubuntu/ jammy main restricted universe multiverse
deb-src https://mirrors.cloud.tencent.com/ubuntu/ jammy main restricted universe multiverse
deb https://mirrors.cloud.tencent.com/ubuntu/ jammy-security main restricted universe multiverse
deb-src https://mirrors.cloud.tencent.com/ubuntu/ jammy-security main restricted universe multiverse
deb https://mirrors.cloud.tencent.com/ubuntu/ jammy-updates main restricted universe multiverse
deb-src https://mirrors.cloud.tencent.com/ubuntu/ jammy-updates main restricted universe multiverse
deb https://mirrors.cloud.tencent.com/ubuntu/ jammy-proposed main restricted universe multiverse
deb-src https://mirrors.cloud.tencent.com/ubuntu/ jammy-proposed main restricted universe multiverse
deb https://mirrors.cloud.tencent.com/ubuntu/ jammy-backports main restricted universe multiverse
deb-src https://mirrors.cloud.tencent.com/ubuntu/ jammy-backports main restricted universe multiverse
"> /etc/apt/sources.list

echo "更新系统包，修改时区"
apt update
apt upgrade -y
apt install -y tzdata
ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} >/etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata
rm -rf /var/lib/apt/lists/*

echo "安装依赖中....."
apt update
apt install git python3 npm make curl wget -y

mkdir /usr/include/nlohmann/
cd /usr/include/nlohmann/ && wget ${GITHUB_PROXY}https://github.com/nlohmann/json/releases/download/v3.10.5/json.hpp

npm config set registry http://registry.npm.taobao.org && npm install -g node-gyp
curl -s https://install.zerotier.com | bash
cd /opt && git clone -v ${GITHUB_PROXY}https://github.com/key-networks/ztncui.git --depth 1
cd /opt && git clone -v ${GITHUB_PROXY}https://github.com/zerotier/ZeroTierOne.git --depth 1

cd /opt/ztncui/src
npm install
cp -pv ./etc/default.passwd ./etc/passwd
echo 'HTTP_PORT=3443' >.env
echo 'NODE_ENV=production' >>.env
echo 'HTTP_ALL_INTERFACES=true' >>.env

cd /var/lib/zerotier-one && zerotier-idtool initmoon identity.public >moon.json
cd /app/patch && python3 patch.py
cd /var/lib/zerotier-one && zerotier-idtool genmoon moon.json && mkdir moons.d && cp ./*.moon ./moons.d
cd /opt/ZeroTierOne/attic/world/ && sh build.sh
sleep 5s

cd /opt/ZeroTierOne/attic/world/ && ./mkworld
mkdir /app/bin -p && cp world.bin /app/bin/planet

service zerotier-one restart
