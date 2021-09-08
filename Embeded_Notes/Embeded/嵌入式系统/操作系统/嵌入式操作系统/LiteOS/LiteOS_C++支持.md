# LiteOS C++支持
## 基本概念
C++作为目前使用最广泛的编程语言之一，支持类、封装、重载等特性，是在C语言基础上开发的一种面向对象的编程语言。
STL（Standard Template Library）标准模板库，是一些“容器”的集合，也是算法和其他一些组件的集合。  
其目的是标准化组件，**使用标准化组件后可以不用重新开发，直接使用现成的组件**。

## 开发指导
| 功能分类              | 接口名            | 描述              |
| --------------------- | ----------------- | ----------------- |
| 使用C++特性的前置条件 | LOS_CppSystemInit | 初始化C++构造函数 |

该函数有三个参数
+ 第一个参数：init_array段的起始地址
+ 第二个参数：init_array段的结束地址
+ 第三个参数：标记调用C++特性时的场景

## 开发流程
### 配置
通过 `make menuconfig` 使能C++支持  
菜单路径为：Kernel —> Enable Extend Kernel —> C++ Support。

| 配置项                   | 含义              | 取值范围 | 默认值 | 依赖                    |
| ------------------------ | ----------------- | -------- | ------ | ----------------------- |
| LOSCFG_KERNEL_CPPSUPPORT | C++特性的裁剪开关 | YES/NO   | YES    | LOSCFG_KERNEL_EXTKERNEL |

使用C++特性之前，需要调用函数 `LOS_CppSystemInit`，初始化C++构造函数    

C函数与C++函数混合调用
在C++中调用C程序的代码，需要加入C++包含的宏定义
```c
#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif /* __cplusplus */
#endif /* __cplusplus */

...
/* code */
...

#ifdef __cplusplus
#if __cplusplus
}
#endif /* __cplusplus */
#endif /* __cplusplus */
```

## 注意事项
C++功能需要编译器适配才能支持，**编译器编译链接C++代码时需要使用Huawei LiteOS提供的C库**

