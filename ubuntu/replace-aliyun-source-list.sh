file="/etc/apt/sources.list.bak"
if [ ! -f "$file" ]; then
    echo '修改中。。。\n'
    sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
    block="
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
    "
    sudo echo "$block" > "/tmp/sources.list"
    sudo mv /tmp/sources.list /etc/apt/sources.list ##修改成功了
else
    echo '已经是阿里的了\n' ##已经是阿里的了
fi

apt-get clean all
apt-get update
