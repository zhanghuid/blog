### laravel homestead 7.0.1

#### 环境预设
```bash
运行 ssh-keygen
```

#### 安装`Vagrant 2.0.1`, `virtualBox 5.1.30`

#### 新建metadata.json
```json
{
    "name": "laravel/homestead",
    "versions": 
    [
        {
            "version": "5.0.1",
            "providers": [
                {
                  "name": "virtualbox",
                  "url": "homestead.box" # 路径为metadata.json的同级目录
                }
            ]
        }
    ]
}
```

#### 导入homestead.box
```bash
vagrant box add metadata.json
```


#### 安装全局安装homestead
```bash
composer global require laravel/homestead
```

#### 进入项目安装homestead
```bash
composer require laravel/homestead
```

#### 进入项目执行 `homestead make` （全局安装的homestead命令）
生成如下文件：
```bash
Homestead.yaml
after.sh
aliases
Vagrantfile
```

#### 在当前项目下运行 `vagrant up`
