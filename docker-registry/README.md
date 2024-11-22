
#### 使用Docker-compose+WebUI

```yaml
version: '2.0'
services:
  registry:
    image: registry:2.7
    volumes:
      - .:/var/lib/registry
    ports:
      - 5000:5000
    restart: always
    networks:
      - registry-ui-net

  ui:
    image: joxit/docker-registry-ui:latest
    restart: always
    ports:
      - 80:80
    environment:
      - REGISTRY_TITLE=My Private Docker Registry
      - NGINX_PROXY_PASS_URL=http://registry:5000
      - SINGLE_REGISTRY=true
    depends_on:
      - registry
    networks:
      - registry-ui-net

networks:
  registry-ui-net:

```



###### 下面将用`192.168.1.97:5000`举例



#### 在Docker客户端添加私有仓库列表

1. 打开或创建`daemon.json`配置文件。在Linux上，它通常位于`/etc/docker/daemon.json`，在Windows上，它通常位于`C:\ProgramData\docker\config\daemon.json`。
2. 添加以下内容到`daemon.json`文件中：

```json
{
  "insecure-registries": ["192.168.1.97:5000"]
}
```

保存文件，并重启Docker服务，以使更改生效。

方法二：为私有仓库配置TLS/SSL证书 您可以为私有仓库配置TLS/SSL证书，以启用安全的HTTPS连接。这将确保Docker客户端与私有仓库之间的通信是加密和安全的。

1. 获取有效的TLS/SSL证书并将其放置在Docker客户端上。通常，这是由私有仓库提供的。
2. 在Docker客户端上配置证书位置。您可以在`daemon.json`文件中添加类似以下内容：

```json
{
  "insecure-registries": ["192.168.1.97:5000"],
  "registry-mirrors": [],
  "tls": true,
  "tlscacert": "/path/to/ca.crt",
  "tlscert": "/path/to/client.crt",
  "tlskey": "/path/to/client.key"
}
```

确保将`/path/to/ca.crt`，`/path/to/client.crt`和`/path/to/client.key`替换为您实际的TLS证书文件路径保存文件，并重启Docker服务，以使更改生效。



#### 推送和拉取镜像

推送镜像

```bash
# 修改现有镜像Tag
docker tag mariadb:latest 192.168.1.97:5000/mariadb:11
# 推送到私有仓库
docker push 192.168.1.97:5000/mariadb:11
```

拉取镜像

```bash
docker pull 192.168.1.97:5000/mariadb:11
```





#### 批量标记和上传

tag_and_push.sh

```bash
#!/bin/bash

PRIVATE_REGISTRY="192.168.1.97:5000"
for image in $(docker image ls --format "{{.Repository}}:{{.Tag}}"); do
  if [[ "$image" != "$PRIVATE_REGISTRY"* ]]; then
    new_image="${PRIVATE_REGISTRY}/${image#*/}"
    docker tag "$image" "$new_image"
    docker push "$new_image"
  fi
done

```

将上述代码保存为一个Shell脚本文件（例如`tag_and_push.sh`），然后在脚本所在的目录中运行：

```bash
bashCopy codechmod +x tag_and_push.sh  # 添加执行权限
./tag_and_push.sh         # 运行脚本
```

此脚本将获取本地所有镜像的列表，并将它们逐个打上私有仓库的标签，并将这些标签的镜像推送到您的私有仓库。

