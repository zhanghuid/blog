file="/etc/apt/sources.list.bak"
if [ ! -f "$file" ]; then
    echo '修改中。。。\n'
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
    block="
deb http://mirrors.cloud.tencent.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.cloud.tencent.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.cloud.tencent.com/ubuntu/ xenial-updates main restricted universe multiverse
#deb http://mirrors.cloud.tencent.com/ubuntu/ xenial-proposed main restricted universe multiverse
#deb http://mirrors.cloud.tencent.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.cloud.tencent.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.cloud.tencent.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.cloud.tencent.com/ubuntu/ xenial-updates main restricted universe multiverse
#deb-src http://mirrors.cloud.tencent.com/ubuntu/ xenial-proposed main restricted universe multiverse
#deb-src http://mirrors.cloud.tencent.com/ubuntu/ xenial-backports main restricted universe multiverse
    "
    sudo echo "$block" > "/tmp/sources.list"
    sudo mv /tmp/sources.list /etc/apt/sources.list ##修改成功了
else
    echo '已经是腾讯的了\n'
fi

sudo apt update
sudo apt upgrade -y
sudo apt autoremove
