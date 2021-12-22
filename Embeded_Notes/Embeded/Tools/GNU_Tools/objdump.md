# objdump
## 简介
Linux下的反汇编目标文件或者可执行文件的命令

## 使用实例
### 显示文件头信息
```shell
objdump -f xxx 
```


### 反汇编`文件`中需要执行指令的那些区域
```shell
objdump -d xxx 
```

### 反汇编`文件`中的所有区域
```shell
objdump -D xxx 
```

### 显示`文件`的区域的头信息
```shell
objdump -h xxx 
```

### 显示文件全部的头信息
```shell
objdump -x xxx 
```

