# Docker-LNMP-YDT
利用 Docker-Compose 编排 LNMP + es + redis + memcached 开发环境  

### 清单 
> 注: 没有加版本号，说明没有指定的版本要求
- 服务:版本/(镜像)
- php:5.6.4/(phpdockerio/php56-fpm)
- Nginx/(nginx:1.17.9)
- MySQL:5.6/(daocloud.io/library/mysql:5.6)
- Redis:3.0/(redis:3.0.6)
- memcached:1.4.14/(memcached:1.4.23)
- elasticsearch:5.5.3/(elasticsearch:5.5.2)
- kibana/(kibana:5.5.2)

### 目录结构
```
Docker-LNMP
|----docker                             Docker目录
|--------config                         配置文件目录
|------------proxy                      nginx配置文件目录
|--------files                          DockerFile文件目录
|------------cgi                        php-fpm DockerFile文件目录
|----------------Dockerfile             php-fpm DockerFile文件
|----------------docker-entrypoint.sh   php-fpm 启动脚本
|------------proxy                      nginx DockerFile文件目录
|----------------Dockerfile             nginx DockerFile文件
|----------------docker-entrypoint.sh   nginx 启动脚本
|--------log                            日志文件目录
|------------cgi                        php-fpm日志文件目录
|------------proxy                      nginx日志文件目录
|----www                                应用根目录
|--------index.php                      PHP数据和redis链接测试
|----README.md                          说明文件
|----docker-compose-ydt.yml             docker compose 配置文件 
```
### 准备
```shell
# 安装docker和docker-compose 
	## linux
		yum -y install epel-release 
		yum -y install docker docker-compose
		启动docker服务 service docker start
	
	## mac
		直接安装终端软件

# 配置阿里云docker镜像加速器(建议配置加速器, 可以提升docker拉取镜像的速度)
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

	##macox:
		在perferences里面进行配置
		{
		    "registry-mirrors": ["https://8auvmfwy.mirror.aliyuncs.com"]
		}

```

### 安装
```shell
# 克隆项目
git clone git@gitlab.com:yidoutang/qee-docker.git
# 进入目录
cd qee-docker
# 容器编排
docker-compose -f docker-compose-ydt.yml up -d
```
### 测试
执行成功
```
Creating cgi ... done
Creating proxy ... done
Creating mysql ...
Creating redis ...
Creating memcached ...
Creating elasticsearch ...
Creating kibana ...
```
访问localhost即可

### 额外配置
	一 安装php的extsion
		docker exec -it cgi /bin/bash
		apt-get update
		apt-get install -y php5-mysql php5-gd php5-redis php5-memcache

		重启php
		docker restart cgi

	二 elasticserach安装ik中文插件
		由于docker的elasticsearch镜像是5.5.2,下载对应版本的ik，复制到对应的plugins目录即可
		https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v5.5.2/elasticsearch-analysis-ik-5.5.2.zip
		重启es
		docker restart elasticserach

	三  kibana汉化
		vim config/kibana.yml
		搜索 locale一行
		去掉#，并将"en"改成"zh-CN"

	四  配置/日志/代码 文件

		配置文件在 ./docker/config/
		日志文件在 ./docker/log/
		数据文件在 ./docker/data/
		代码在    ./www 

	五  mysql的账号密码
		root  
		root

	六  开发环境代码的各种服务host配置
		mysql
		redis
		elasticserach
		memcached

### 学习文档
- [如何新建一个站点](docs/如何新建一个站点.md)
- [如何安装yaf扩展](docs/如何安装yaf扩展.md)
- [如何安装swoole扩展](docs/如何安装swoole扩展.md)

### 可能遇到的问题
```bash
#localhost浏览器打开提示: Error 1: could not find driver

此情况是，php没有装扩展,参考上面的php扩展安装

```

```bash
# Error信息
The "https://packagist.phpcomposer.com/packages.json" file could not be down
# 解决方案
这是由于composer中国镜像失效, 修改Docker-LNMP/docker/files/cgi/Dockerfile
https://packagist.phpcomposer.com 改为 https://mirrors.aliyun.com/composer/
```

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
### 更新日志
- cgi容器支持crontab
- PHP支持rdkafka扩展
- PHP支持POSIX、PCNTL扩展
- 新增学习文档

### Docker常用命令
```shell
# 删除所有容器
docker rm -f $(docker ps -aq)  
# 删除所有镜像
docker rmi $(docker images -q)
```

### 参考
- [https://github.com/duiying/Docker-LNMP](https://github.com/duiying/Docker-LNMP)
- [https://github.com/gengxiankun/dockerfiles](https://github.com/gengxiankun/dockerfiles)