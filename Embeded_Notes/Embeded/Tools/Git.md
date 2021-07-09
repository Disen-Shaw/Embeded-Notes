# Git使用笔记

## 准备

在使用Git前必须初始化配置，否则无法上传文件

## 工作原理

Git本地由三个工作区域，分别为

1. 工作目录
2. 暂存区
3. 资源库

如果再加上远程的git仓库就可以分为4个工作域。

![[Pasted image 20210308011707.png]]
1. **工作区：平时存放代码的地方**
2. 暂存区：用于存放改动的文件
3. 仓库区：安全存放数据的位置，有提交的所有版本的数据，HEAD指向最新放入仓库的版本
4. **远程仓库(GitHub、Gitee)：代码托管的服务器。**

工作目录下有个.git文件夹，里面有几个文件是暂存区

## Git的工作流程

1. 在目录中添加、修改文件。

2. 将需要进行版本管理的文件放入暂存区         

   ```shell
   git add .
   ```

3. 将暂存区的文件放入git仓库            

   ```shell
   # 提交暂存区的东西到本地仓库
   git commit -m .
   ```

git管理的文件由三种状态：
已修改(modified)
已暂存(staged)
已提交(committed)

![[Pasted image 20210308011814.png]]

## Git项目的搭建

#### 创建工作目录与常用的指令

工作目录一般是希望git帮助管理的文件夹，也可以是项目的目录，也可以是空目录。

## Git项目的搭建

#### 创建工作目录与常用的指令

工作目录一般是希望git帮助管理的文件夹，也可以是项目的目录，也可以是空目录。

![[Pasted image 20210308012003.png]]

#### 创建本地仓库

1. 创建全新的仓库，需要用GIT管理的项目的根目录执行：

~~~shell
# 在当前位置创建一个Git代码库
git init
~~~

2. 克隆远程仓库

```shell
# 克隆远程仓库
git clone [url]
```

## Git文件操作

#### 文件的4种状态

1. untracked：未跟踪

   在文件夹中，但是没有加入到git库中，不参与版本控制。
   通过**git add**将状态变为staged暂存状态。

2. unmodify：文件已经入库，未修改。

   版本库中的快照内容与文件夹中的一致。
   有两个去处：

   + 被修改，变为modify
   + 使用**git rm**移出版本库，变为untracked。

3. modify：已被修改。

   已被修改，但是没有进行其他操作。

   有两个去处：

   + 通过**git add**进入暂存状态 
   + 使用**git checkout**丢弃修改，返回到unmodify状态，即从库中取出文件，覆盖当前修改。

4. staged：暂存状态

   执行git commit则将修改同步到库中，之后库中文件和不问你滴文件又变为一致，文件为unmodify状态。

   执行git reset HEAD filename取消暂存，文件状态为modify。

#### 查看文件状态

1. 查看某文件状态

   ```shell
   git status [filename]
   ```

2. 查看所有文件状态

   ```shell
   git status
   ```

#### 忽略文件

在主目录下建立.gitgnore文件

规则：

1. 忽略文件中空行或者以#开始的
2. 可以使用Linux通配符
3. 如果最前面有一个感叹号，表示例外规则，将不被忽略
4. 名称前面是一个路径分隔符 / 表示忽略文件在此目录下，而子目录文件不被忽略
5. 名称后面是一个路径分隔符 / 表示忽略子文件夹下的文件

```shell
#为注释
*.txt				# 表示忽略所有.txt结尾的文件,上传不会被选中
!lib.txt			# 但是lib.txt除外
/temp				# 忽略项目根目录下的文件，不包括子目录temp
build/				# 忽略子目录build下的所有文件
```

## 使用码云

#### 设置个人信息

一般使用gitee，公司中有时候搭建自己的git服务器。

可以作为未来找工作的重要信息。

#### 设置本机绑定SSH公钥，实现免密码登录

```shell
# 生成公钥
ssh-keygen
ssh-keygen -t rsa			# 官方推荐加密
```


## 补充
Git大文件

安装git-lfs
~~~bash
sudo apt install git-lfs
~~~
git lfs track "FrameworkFold/XXXFramework/xxx

常规操作
git add .
git commit -m "add large file"
pit push


## 命令
| 命令             操作                  |                        |
| -------------------------------------- | ---------------------- |
| git init                               | 初始化仓库             |
| git status                             | 查看状态               |
| git add + 文件                         | 向仓库添加文件         |
| git diff                               | 查看修改，未上传的更改 |
| git reset                              | add的反悔              |
| git commit -m xxx                      | 提交xxx                |
| git commit </br>可以是added a new file | 手动编辑提交的方式     |
| git rm --cache xxx                     | 去掉xxx的追踪缓存      |
| git branch 分支名                      | 创建分支               |
| git checkout 分支名                    | 切换分支               |
| git merge                              | 分支合并               |
| git branch -d 分支名                   | 删除分支               |
| git remote add orgin 网址              | 添加上传信息           |
| git push --set-upstream origin master  | 上传                   |
| git pull                               | 下载云端代码           |


### .gitignore
文件中的文件名不会被提交，git不会去追踪这个文件
如果之前git已经追踪这个文件了，那么加到这个文件了，还是会追踪
可以用git rm --cache xxx 来取消

### git分支
git branch 分支名
git branch -d 分支名 删除分支
git checkout 分支名
git merge 分支合并

### 添加项目
git remote add orgin 网址
git push --set-upstream origin master

### 不用再输入密码
git config credential.helper stone