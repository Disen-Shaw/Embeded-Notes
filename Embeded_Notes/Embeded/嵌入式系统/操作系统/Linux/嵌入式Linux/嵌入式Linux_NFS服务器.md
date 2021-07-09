# NFS服务器的安装和使用
NFS：网络文件系统，在类Unix操作系统中实现文件共享的

## 准备
在宿主机下载nfs-kernel-server
在开发板上下载nfs-common
## NFS配置文件
ubuntu的位于
/etc/exports
修改，加入
```config
共享文件夹路径 *（rw,sync,no_root_squash） 
*是使用用户，*是所有用户
```
执行
sudo exports -arv
来共享文件夹

### 查看共享文件夹
在下位机上执行
showmount -e 上位机ip地址

### 挂载NFS文件系统
sudo mount -t nfs 上位机IP:某个文件夹 /挂在目录
例如
```shell
sudo mount -t nfs 192.168.1.100:/home/master/share /mnt
```

若没有输出错误信息，则挂载成功
