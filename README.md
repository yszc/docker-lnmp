# Docker-LNMP
利用 Docker-Compose 编排 LNMP + redis 开发环境  

### 清单 
> 注: 没有加版本号，说明没有指定的版本要求
- 服务:版本/(镜像)
- php:5.6.4/(phpdockerio/php56-fpm)
- Nginx/(nginx:1.17.9)
- MySQL:5.6/(daocloud.io/library/mysql:5.6)
- Redis:3.0/(redis:3.0.6)

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

# 推荐配置镜像加速器(可以提升docker拉取镜像的速度)
		{
			"registry-mirrors": [
				"https://dockercf.jsdelivr.fyi",
				"https://docker-cf.registry.cyou",
				"https://dockercf.jsdelivr.fyi",
				"https://docker.1panel.live",
				"https://docker.chenby.cn"
			]
		}
	##docker-desktop:
		在perferences > Docker Engine 里面进行配置

	##linux:
		mkdir -p /etc/docker
		vim /etc/docker/daemon.json
		# 编辑配置
		# 重新加载配置、重启docker
		systemctl daemon-reload 
		systemctl restart docker 

```

### 安装
```shell
# 容器编排
docker-compose up -d
docker-compose up -d php nginx

# 指定PHP环境为生产环境
PHP_ENV=production docker-compose up -d

# 或者修改.env文件中的PHP_ENV值后启动
# vim .env
# docker-compose up -d
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

		
### 如何加入新项目
	
	1. 将PHP项目放在www文件夹，注意修改代码配置中各种服务的host
	1. nginx配置文件放在docker/config/nginx/conf.d下，注意修改fpm的host。
	1. 亦可无须添加nginx配置直接通过localhost/dir访问

### 环境变量配置

项目现在支持通过环境变量来配置PHP容器的运行环境。主要通过以下方式实现：

1. 项目根目录下的`.env`文件中设置默认环境变量：
   ```
   # PHP配置类型：development（开发环境）或 production（生产环境）
   PHP_ENV=development
   ```

2. 在启动容器时通过命令行指定环境变量：
   ```shell
   # 启动开发环境
   PHP_ENV=development docker-compose up -d
   
   # 启动生产环境
   PHP_ENV=production docker-compose up -d
   ```

3. 环境变量的作用：
   - `PHP_ENV=development`：使用PHP的开发环境配置（php.ini-development），提供更详细的错误信息和调试功能
   - `PHP_ENV=production`：使用PHP的生产环境配置（php.ini-production），优化性能，关闭详细错误信息

### 可能遇到的问题


```bash
# Error信息
ERROR: for mysql  Cannot start service mysql: endpoint with name mysql already exists in network docker-lnmp_default
# 解决方案
这是由于端口被占用，需要修改外部端口映射
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
