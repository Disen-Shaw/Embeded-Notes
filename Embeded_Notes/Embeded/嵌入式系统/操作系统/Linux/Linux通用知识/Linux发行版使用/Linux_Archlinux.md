# Archlinux
## Pacman使用
### 安装软件
```shell
pacman -S 软件名
```

### 更新软件库
```shell
pacman -Sy
```

### 更新软件
```shell
pacman -Syu
```
更新软件源并更新软件

### 查询软件
```shell
pacman -Ss 软件名
```

### 删除缓存
```shell
pacman -Sc
```

### 删除软件
```shell
// 普通删除
pacman -R 软件
// 彻底删除
pacman -Rs 软件
// 删掉依赖并且删掉全局配置文件
pacman -Rns
````

### 显示安装软件
```shell
// 显示全部已安装的软件
pacman -Q 
// 显示自己安装的软件
pacman -Qe
// 不显示版本号 +q
```

### 查询不再依赖的软件包
```shell
pacman -Qdt
// 删除孤儿
pacman -R $(pacman -Qdt)
```

## 软件回滚
pacman 的更新方式比较激进，如果给某个软件滚崩了，需要回滚，则要使用 `downgrade` 工具
```shell
sudo downgrade (包名)
```
接着可以输入选择要回滚的包的版本，进而达成回滚