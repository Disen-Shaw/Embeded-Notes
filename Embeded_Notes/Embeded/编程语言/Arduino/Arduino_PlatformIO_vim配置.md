---
date updated: '2021-10-01T07:48:23+08:00'

---

# vim 配置PlatformIO环境

## 准备工作

首先需要有 Python 的工作环境\
下载 `PlatformIO` 的core\
执行安装脚本

```shell
python3 -c "$(curl -fsSL https://raw.githubusercontent.com/platformio/platformio/master/scripts/get-platformio.py)"
```

安装成功后会自动生成 `～/.platformio` 的文件夹\
将 `~/.platformio/penv/bin` 添加到路径 `PATH` 中

取得 [get-platformio.py](https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py) 安装脚本文件\
`可以将网页内容复制，并添加到新建文件get-platformio.py中`

之后执行指令检查是否安装成功

```shell
python get-platformio.py check core
```

检查安装成功后生成配置文件

```shell
get-platformio.py check core --dump-state Your/Designate/PATH/pioinstaller-state.json
```

大致内容如下

```json
{
	"core_version": "5.1.1",
	"python_version": "3.9.6",
	"core_dir": "/home/master/.platformio",
	"cache_dir": "/home/master/.platformio/.cache",
	"penv_dir": "/home/master/.platformio/penv",
	"penv_bin_dir": "/home/master/.platformio/penv/bin",
	"platformio_exe": "/home/master/.platformio/penv/bin/platformio",
	"installer_version": "1.0.2",
	"python_exe": "/home/master/.platformio/penv/bin/python",
	"system": "linux_x86_64",
	"is_develop_core": false
}
```

最后安装 `PlatformIO Core`

```shell
python get-platformio.py
```

执行到此步， `PlatformIO` 已经安装完成

## 工程定义

可以使用指令 `platformio boards | grep ‘your board name’` 来查找所要用的板子\
新建文件夹，并进入文件夹\
执行指令 `pio project init --ide vim --board uno(your board name such as uno)`\
`PlatformIO` 会自动生成工程

工程文件夹包括

- include: 头文件
- lib: 需要用到的库文件或其他库，如`mpu6050`
- src: 源代码位置，需要自己新建
- test
- platformio.ini:工程的一些基本配置
  - 下载程序需要添加: `upload_port = /dev/ttyUSB0(开发板的设备名)`

并且每个文件夹下有 `README` 文件，可以给使用者提示

新建Makefile文件，内容如下:

```makefile
#SHELL := /bin/bash
#PATH := /usr/local/bin:$(PATH)

all:
	pio -f -c vim run

upload:
	pio -f -c vim run --target upload

clean:
	pio -f -c vim run --target clean

program:
	pio -f -c vim run --target program

uploadfs:
	pio -f -c vim run --target uploadfs

update:
	pio -f -c vim update
```

至此，工程创建完成，执行 `make` 构建工程，执行 `make upload` 下载程序到开发板中

```c++
# Blink Test

void setup(){
	pinMode(13,OUTPUT);
}

void loop(){
	digitialWrite(13,HIGH);
	delay(1000);
	digitialWrite(13,LOW);
	delay(1000);
}
```

闪灯成功！
