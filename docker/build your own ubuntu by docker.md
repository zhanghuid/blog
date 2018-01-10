### build workflow
---
#### 1，拉取ubuntu:16.04

```bash
docker pull ubuntu:16.04
```

#### 2，启动容器
```bash
docker run -it -d ubuntu:16.04
```

or 

```bash
docker run -it -d -v your_host_dir:container_dir ubuntu:16.04
```
example:`docker run -it -d -v f:\ubuntu\code\:/code ubuntu:16.04`

#### 3，进入容器
```bash
docker exec -it YOUR_CONTAINER_ID bash
```

#### 4，将镜像打包
```bash
docker save ubuntu > ubuntu_16.04.tar | gzip 
```

#### 5，在新的机器上载入镜像
```bash
docker load < ubuntu_16.04.tar.gz
```

#### 6，检查镜像状态
```bash
docker images
```


### other command
---
#### 停止镜像
```bash
docker stop YOUR_CONTAINER_ID
```

#### 命名容器
```bash
docker run -it -d --name YOUR_CONTAINER_NAME
```

#### 进入命名容器里
```bash
docker exec -it YOUR_CONTAINER_NAME bash
```
