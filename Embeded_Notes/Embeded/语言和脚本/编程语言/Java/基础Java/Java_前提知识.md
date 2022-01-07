# 基础知识

## 跨平台原理

### 平台的概念

平台指 _操作系统平台_，例如 **Windows**、**Linux**、**MacOS**等\
Java几乎可以在所有操作系统上运行

### Java 跨平台原理

#### Jvm

`JVM` 是操作系统的 Java 虚拟机，针对不同的操作系统提供不同的 `JVM` 即可

## JRE 和 JDK

### JRE

JRE： `Java Runtime Envirment` 的字母缩写\
是 Java 程序的运行时环境，包含 JVM 和运行是所需的 **核心类库**\
因此只安装 JRE 也可以保证 Java 程序的跨平台运行

### JDK

JDK：`Java Development Kit` 的字母缩写\
是 Java 程序的开发程序包，包含 JRE 和 开发人员所使用的工具

其中开发工具主要指

- 编译工具 javac
- 运行工具 java

若要开发一个全新的 Java 程序，就必须安装 JDK

包含关系
+ JDK
	+ JRE
		+ JVM
		+ 核心类库
	+ 开发工具

