# Docker-LNMP
利用 Docker-Compose 编排 LNMP + redis + memcached 开发环境  

### 清单 
> 注: 没有加版本号，说明没有指定的版本要求
- 服务:版本/(镜像)
- php:5.6.4/(phpdockerio/php56-fpm)
- Nginx/(nginx:1.17.9)
- MySQL:5.6/(daocloud.io/library/mysql:5.6)
- Redis:3.0/(redis:3.0.6)
- memcached:1.4.14/(memcached:1.4.23)

### 目录结构
```
Docker-LNMP
|----docker                             Docker目录
|--------config                         配置文件目录
|------------nginx                      nginx配置文件目录
|--------files                          DockerFile文件目录
|------------php                        php-fpm DockerFile文件目录
|----------------Dockerfile             php-fpm DockerFile文件
|--------log                            日志文件目录
|------------php                        php-fpm日志文件目录
|------------nginx                      nginx日志文件目录
|----www                                应用根目录
|----share                              宿主机共享文件夹
|----README.md                          说明文件
|----docker-compose.yml                 基础版配置文件 
```
### 准备
```shell
# 安装docker和docker-compose 
	## mac, windows
		安装docker-desktop
		https://www.docker.com/products/docker-desktop

	## linux
		yum -y install epel-release 
		yum -y install docker docker-compose
		启动docker服务 service docker start

# 配置阿里云docker镜像加速器(建议配置加速器, 可以提升docker拉取镜像的速度)
	##docker-desktop:
		在perferences里面进行配置
		{
			"registry-mirrors": ["https://8auvmfwy.mirror.aliyuncs.com"]
		}

	##linux:
		mkdir -p /etc/docker
		vim /etc/docker/daemon.json
		# 新增下面内容
		{
			"registry-mirrors": ["https://8auvmfwy.mirror.aliyuncs.com"]
		}
		# 重新加载配置、重启docker
		systemctl daemon-reload 
		systemctl restart docker 

```

### 安装
```shell
# 容器编排
docker-compose up -d
docker-compose up -d php nginx
```
### 测试
执行成功
```
Creating php ... done
Creating nginx ... done
Creating mysql ...
Creating redis ...
Creating memcached ...
Creating elasticsearch ...
Creating kibana ...
```
访问localhost即可

### 额外配置

	*  配置/日志/代码 文件
		配置文件在 ./docker/config/
		日志文件在 ./docker/log/
		数据文件在 ./docker/data/
		代码在    ./www 

	*  mysql的账号密码
		root  
		root

	*  MySQL数据迁移示例
		导出： mysqldump -u root -p ydt > ydt.sql
		导入： 将dump文件放在share文件夹中
			  进入MySQL容器 docker exec -it mysql /bin/bash
			  终端连接 mysql -u root -p 
			  > create database ydt;
			  > use ydt;
			  > source /data/ydt.sql;

	*  各种服务均无法使用127.0.0.1或localhost，应该替换为以下host
		fpm => php
		nginx => nginx
		mysql=>mysql
		redis=>redis
		elasticserach=>elasticsearch
		memcached=>memcached
		
### 如何加入新项目
	
	1. 将PHP项目放在www文件夹，注意修改代码配置中各种服务的host
	1. nginx配置文件放在docker/config/nginx/conf.d下，注意修改fpm的host。
	1. 亦可无须添加nginx配置直接通过localhost/dir访问

### 可能遇到的问题


```bash
# Error信息
ERROR: for mysql  Cannot start service mysql: endpoint with name mysql already exists in network docker-lnmp_default
# 解决方案
这是由于端口被占用，需要清理此容器的网络占用
格式：docker network disconnect --force 网络模式 容器名称
docker network disconnect --force docker-lnmp_default mysql
检查是否还有其它容器占用
格式：docker network inspect 网络模式
```

### Docker常用命令
```shell
#进入某个容器
docker exec -it mysql /bin/bash
# 删除所有容器
docker rm -f $(docker ps -aq)  
# 删除所有镜像
docker rmi $(docker images -q)
```

### 参考
- [https://github.com/duiying/Docker-LNMP](https://github.com/duiying/Docker-LNMP)
- [https://github.com/gengxiankun/dockerfiles](https://github.com/gengxiankun/dockerfiles)
