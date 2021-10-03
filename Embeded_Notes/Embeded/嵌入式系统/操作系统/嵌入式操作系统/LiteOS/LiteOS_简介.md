---
date updated: '2021-10-01T08:37:25+08:00'

---

# LiteOS简介

## LiteOS简介

`Huawei LiteOS` 是华为面向 `IoT` 领域，构建的轻量级物联网操作系统，可以广泛应用于智能家居、个人穿戴设备、车联网、城市公共服务、制造业等领域

`Huawei LiteOS` 开源项目目前支持架构

- ARM64
- ARM Cortex-A
- ARM Cortex-M0
- ARM Cortex-M3
- ARM Cortex-M4
- ARM Cortex-M7等芯片架构

## LiteOS优势

- 高实时性，高稳定性
- 超小内核，基础内核提及可以裁剪到不到10KB
- 低功耗，配套芯片整体工号低至uA级
- 支持功能静态裁剪

## 架构框图

![[Pasted image 20210902115936.png]]

`LiteOS` 支持多种芯片架构，如 `Cortex-M series`、`Cortex-R series`、`Cortex-A series` 等，可以快速一直到多种硬件平台\
`LiteOS` 也支持 `UP(单核)`与 `SMP(多核)` 模式，可以在单核和多核环境上运行

## LiteOS其他组件

- 基础内核：
  - 包括不可裁剪的极小内核和可裁剪的其他模块
    - 任务管理
    - 内存管理
    - 中断管理
    - 异常管理
    - 系统时钟
  - 可裁剪的模块
    - 信号量
    - 互斥锁
    - 队列管理
    - 事件管理
    - 软件定时器等
- 内核增强：在内核的基础功能上进一步增强功能
  - C++支持
  - 调试组件
    - shell命令
    - Trace事件跟踪
    - 获取CPU占用率
    - LMS等
- 文件系统：提供一套轻量级的文件系统接口以支持文件系统的基本功能
  - vfs
  - ramfs
  - fatfs等
- 系统库接口
  - Libc
  - Libm
  - POSIX
  - CMSIS适配层接口
- 网络协议栈：提供丰富的网络协议栈以支持多种网络功能
  - CoAP
  - LwM2M
  - MQTT等
