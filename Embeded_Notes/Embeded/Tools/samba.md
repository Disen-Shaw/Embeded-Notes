# samba服务
在Linux下搭建 `samba` 服务，可以实现Windows下对Linux主机上文件的访问  

## 安装samba
```shell
sudo pacman -S samba
```

## 修改 samba 的配置文件
```shell
sudo vim /etc/samba/smb.conf
```
在文件末尾添加下面的内容，其中 `username` 为登陆Linux主机的用户名，`path` 为Windows下可以直接访问的Linux主机上的共享目录
```conf
[username]
	path = /home/master/share_dir
	browseable = yes
	available = yes
	public = yes
	writable = yes
	valid users = username
	create mask = 0777
	security = share
	guest ok = yes
	directory mask = 0777
```

## 重启 samba 服务
```shell
sudo service smdb restart
```

## 设置 samba 账户密码
设置 `samba` 账户密码，按提示输入密码，username为登陆Linux主机的用户名
```shell
sudo smbpasswd -a username
```

## 设置共享目录权限
执行下面的命令将共享目录设置为任何用户都是可读可写可访问的状态
```shell
sudo chmod 777 /home/username
```

## 通过Windows访问Linux主机上的共享目录
在Windows资源管理器中输入
```shell
\\Linux主机IP地址
```
即可访问Linux共享目录