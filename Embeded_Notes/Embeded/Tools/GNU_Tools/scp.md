# SCP工具

## 用途
该工具通过 `SSH` 进行文件传输

## 从服务器下载文件

```shell
scp 用户名@地址:/文件路径 本地路径
scp username@servername:/path/filename 本地目录）
```

## 上传本地文件到服务器

```shell
scp 本地路径 用户名@地址:/文件路径
scp /path/filename username@servername:/path
```

## 从服务器下载整个目录

```shell
scp -r 用户名@地址:/文件路径 本地路径
scp -r username@servername:/var/www/remote_dir/（远程目录） /var/www/local_dir（本地目录）
```

## 上传本地目录到服务器

```shell
scp -r 本地路径 用户名@地址:/文件路径
scp -r /path/filename username@servername:/path
```