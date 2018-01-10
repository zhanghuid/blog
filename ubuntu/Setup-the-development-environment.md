### 初始化网络环境
---
#### 内容
- yarn镜像
- npm镜像
- composer镜像
- 软件源替换为阿里的
- 安装zsh

```bash
#!/bin/sh

# If you would like to do some extra provisioning you may
# add any commands you wish to this file and they will
# be run after the Homestead machine is provisioned.
echo '开始执行自定义命令\n'
#####中国镜像配置####################
registry=`yarn config get registry`
if [ "$registry"x == "https://registry.npm.taobao.org"x ]; then
    echo 'yarn镜像已经是淘宝镜像\n'
else
    yarn config set registry 'https://registry.npm.taobao.org'
    echo 'yarn镜像修改成功\n'
fi


echo '修改npm镜像\n'
registry=`npm config get registry`
if [ "${registry}x" == "https://registry.npm.taobao.orgx" ]; then
    echo 'npm镜像已经是淘宝镜像\n'
else
    npm --registry=https://registry.npm.taobao.org
    echo 'npm镜像修改成功\n'
fi

echo '修改composer镜像\n'
composer config -g repo.packagist composer https://packagist.phpcomposer.com

####软件安装与更新#############
echo '修改软件源为阿里的\n'
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
echo '安装zsh\n'
if command -v zsh >/dev/null 2>&1; then
  echo 'zsh已经安装\n'
else
  echo 'zsh，不存在的\n'
  sudo apt install zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi
echo '更新软件\n'
sudo apt update
sudo apt upgrade -y
sudo apt autoremove
echo '修改默认shell\n'###未生效哦，没有权限。。。
chsh -s /usr/bin/zsh
zsh
```

### 初始化开发环境
---
- Git
- PHP 7.1
- Nginx
- MySQL
- Sqlite3
- Composer
- Node 6 (With Yarn, PM2, Bower, Grunt, and Gulp)
- Redis
- Memcached
- Beanstalkd

```bash
#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Check if user is root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }

# Configure
MYSQL_ROOT_PASSWORD=""
MYSQL_NORMAL_USER="estuser"
MYSQL_NORMAL_USER_PASSWORD=""

# Check if password is defined
if [[ "$MYSQL_ROOT_PASSWORD" == "" ]]; then
    echo "${CFAILURE}Error: MYSQL_ROOT_PASSWORD not define!!${CEND}";
    exit 1;
fi
if [[ "$MYSQL_NORMAL_USER_PASSWORD" == "" ]]; then
    echo "${CFAILURE}Error: MYSQL_NORMAL_USER_PASSWORD not define!!${CEND}";
    exit 1;
fi

# Force Locale

export LC_ALL="en_US.UTF-8"
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8

# Add www user and group
addgroup www
useradd -g www -d /home/www -c "www data" -m -s /usr/sbin/nologin www

# Update Package List

apt-get update

# Update System Packages

apt-get -y upgrade

# remove apache2
apt-get purge apache2 -y

# Install Some PPAs

apt-get install -y software-properties-common curl

apt-add-repository ppa:nginx/development -y
apt-add-repository ppa:chris-lea/redis-server -y
apt-add-repository ppa:ondrej/php -y

# Using the default Ubuntu 16 MySQL 7 Build
# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported
# apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5
# sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu/ xenial mysql-5.7" >> /etc/apt/sources.list.d/mysql.list'

curl --silent --location https://deb.nodesource.com/setup_6.x | bash -

# Update Package Lists

apt-get update

# Install Some Basic Packages

apt-get install -y build-essential dos2unix gcc git libmcrypt4 libpcre3-dev \
make python2.7-dev python-pip re2c supervisor unattended-upgrades whois vim libnotify-bin

# Set My Timezone

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Install PHP Stuffs

apt-get install -y --force-yes php7.1-cli php7.1 \
php-pgsql php-sqlite3 php-gd php-apcu \
php-curl php7.1-mcrypt \
php-imap php-mysql php-memcached php7.1-readline php-xdebug \
php-mbstring php-xml php7.1-zip php7.1-intl php7.1-bcmath php-soap

# Install Composer

curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# Add Composer Global Bin To Path
printf "\nPATH=\"$(composer config -g home 2>/dev/null)/vendor/bin:\$PATH\"\n" | tee -a ~/.profile

# Set Some PHP CLI Settings

sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini

# Install Nginx & PHP-FPM

apt-get install -y --force-yes nginx php7.1-fpm

# Setup Some PHP-FPM Options

sed -i "s/error_reporting = .*/error_reporting = E_ALL \& ~E_NOTICE \& ~E_STRICT \& ~E_DEPRECATED/" /etc/php/7.1/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = Off/" /etc/php/7.1/fpm/php.ini
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini
sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/fpm/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize = 50M/" /etc/php/7.1/fpm/php.ini
sed -i "s/post_max_size = .*/post_max_size = 50M/" /etc/php/7.1/fpm/php.ini
sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/fpm/php.ini
sed -i "s/listen =.*/listen = 127.0.0.1:9000/" /etc/php/7.1/fpm/pool.d/www.conf

# Setup Some fastcgi_params Options

cat > /etc/nginx/fastcgi_params << EOF
fastcgi_param	QUERY_STRING		\$query_string;
fastcgi_param	REQUEST_METHOD		\$request_method;
fastcgi_param	CONTENT_TYPE		\$content_type;
fastcgi_param	CONTENT_LENGTH		\$content_length;
fastcgi_param	SCRIPT_FILENAME		\$request_filename;
fastcgi_param	SCRIPT_NAME		\$fastcgi_script_name;
fastcgi_param	REQUEST_URI		\$request_uri;
fastcgi_param	DOCUMENT_URI		\$document_uri;
fastcgi_param	DOCUMENT_ROOT		\$document_root;
fastcgi_param	SERVER_PROTOCOL		\$server_protocol;
fastcgi_param	GATEWAY_INTERFACE	CGI/1.1;
fastcgi_param	SERVER_SOFTWARE		nginx/\$nginx_version;
fastcgi_param	REMOTE_ADDR		\$remote_addr;
fastcgi_param	REMOTE_PORT		\$remote_port;
fastcgi_param	SERVER_ADDR		\$server_addr;
fastcgi_param	SERVER_PORT		\$server_port;
fastcgi_param	SERVER_NAME		\$server_name;
fastcgi_param	HTTPS			\$https if_not_empty;
fastcgi_param	REDIRECT_STATUS		200;
EOF

# Set The Nginx & PHP-FPM User

sed -i "s/user www-data;/user www;/" /etc/nginx/nginx.conf
sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf

sed -i "s/user = www-data/user = www/" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "s/group = www-data/group = www/" /etc/php/7.1/fpm/pool.d/www.conf

sed -i "s/listen\.owner.*/listen.owner = www/" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "s/listen\.group.*/listen.group = www/" /etc/php/7.1/fpm/pool.d/www.conf
sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.1/fpm/pool.d/www.conf

service nginx restart
service php7.1-fpm restart

# Install Node

apt-get install -y nodejs
/usr/bin/npm install -g gulp
/usr/bin/npm install -g bower

# Install SQLite

apt-get install -y sqlite3 libsqlite3-dev

# Install MySQL

debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password ${MYSQL_ROOT_PASSWORD}"
debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password ${MYSQL_ROOT_PASSWORD}"
apt-get install -y mysql-server

# Configure MySQL Password Lifetime

echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf

mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "CREATE USER '${MYSQL_NORMAL_USER}'@'0.0.0.0' IDENTIFIED BY '${MYSQL_NORMAL_USER_PASSWORD}';"
mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL ON *.* TO '${MYSQL_NORMAL_USER}'@'127.0.0.1' IDENTIFIED BY '${MYSQL_NORMAL_USER_PASSWORD}' WITH GRANT OPTION;"
mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL ON *.* TO '${MYSQL_NORMAL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_NORMAL_USER_PASSWORD}' WITH GRANT OPTION;"
mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
service mysql restart

# Add Timezone Support To MySQL

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=${MYSQL_ROOT_PASSWORD} mysql

# Install A Few Other Things

apt-get install -y redis-server memcached beanstalkd

# Configure Supervisor

systemctl enable supervisor.service
service supervisor start

# Configure Beanstalkd

sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
/etc/init.d/beanstalkd start

# Enable Swap Memory

/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

clear
echo "--"
echo "--"
echo "It's Done."
echo "Mysql Root Password: ${MYSQL_ROOT_PASSWORD}"
echo "Mysql Normal User: ${MYSQL_NORMAL_USER}"
echo "Mysql Normal User Password: ${MYSQL_NORMAL_USER_PASSWORD}"
echo "--"
echo "--"
```

### 脚本引用如下
- [homestead-after](https://github.com/bluegeek/homestead-after)
- [laravel-ubuntu-init](https://github.com/summerblue/laravel-ubuntu-init)