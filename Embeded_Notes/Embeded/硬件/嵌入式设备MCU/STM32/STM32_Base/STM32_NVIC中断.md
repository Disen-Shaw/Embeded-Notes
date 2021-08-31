# 异常类型

## 异常类型

1. 内核中断

   体现在内核水平

2. 外设异常 

   体现在外设水平

### NVIC简介

嵌套向量中断控制器，属于内核外设
管理者包括内核和偏上所有外设的中断相关功能
两个重要文件：misc.h,core_m3.h

> NVIC寄存器
> NVIC结构体

~~~c
typedef struct{
    __IO uint32_t ISER[8];			// 中断使能寄存器
    uint32_t RESERVED0[24];			
    __IO uint32_t ICER[8];			// 中断清除寄存器
    uint32_t RESERVED1[24];			
    __IO uint32_t ISPR[8];			// 中断使能悬起寄存器
    uint32_t RESERVED2[24];			
    __IO uint32_t ICPR[8];			// 中断清除悬起寄存器
    uint32_t RESERVED3[24];			
    __IO uint32_t IABR[8];			// 中断有效位寄存器
    uint32_t RESERVED4[56];			
    __IO uint8_t IP[240];			// 中断优先级寄存器
    uint32_t RESERVED4[644];			
    __O uint32_t STIR;				// 软件触发中断寄存器
} NVIC_Type;
~~~
### 中断优先级的定义

优先级设定：NVIC->IPRx

0-3位未使用，4-7位用于表达优先级
优先级分组：NVIC->AIRCR:PRIGROUP[10:8]

| 优先级分组           | 主优先级 | 子优先级 | 描述            |
| -------------------- | -------- | -------- | --------------- |
| NVIC_PriorityGroup_0 | 0        | 0-15     | 主-0bit,子-4bit |
| NVIC_PriorityGroup_1 | 0-1      | 0-7      | 主-1bit,子-3bit |
| NVIC_PriorityGroup_2 | 0-3      | 0-3      | 主-2bit,子-2bit |
| NVIC_PriorityGroup_3 | 0-7      | 0-1      | 主-3bit,子-1bit |
| NVIC_PriorityGroup_4 | 0-15     | 0        | 主-4bit,子-0bit |

已经有中断在工作，根据抢占优先级决定新来的中断是否打断原有的中断
打断就发生中断嵌套，不打断就挂起等着

中断都在挂起等待的状态，先按抢占优先级排序，抢占优先级等级高的先行
抢占优先级等级相同，就比子优先级
子优先级还相同，就比IRQ的值
$$
抢占优先级>子优先级>IRQ
$$

## 中断编程

1. 使能中断请求
2. 配置中断优先级分组
3. 配置NVIC寄存器，初始化NVIC_InitTypeDef;
4. 编写中断服务函数


例如编写GPIO的中断：
1. 初始化要链接到EXTI的GPIO
2. 初始化EXTI用于产生中断事件
3. 初始化NVIC，用于处理中断
4. 编写中断服务函数
5. main函数引用

### 中断配置库函数
固件库文件 core_cm3.h 的最后,还提供了 NVIC 的一些函数,这些函数遵循 CMSIS 规则,只要是 Cortex-M3 的处理器都可以使用,具体如下:

| NVIC库函数                                               | 描述             |
| -------------------------------------------------------- | ---------------- |
| void NVIC_EnableIRQ(IRQn_Type IRQn)                      | 使能中断         |
| void NVIC_DisableIRQ(IRQn_Type IRQn)                     | 失能中断         |
| void NVIC_SetPendingIRQ(IRQn_Type IRQn)                  | 设置中断悬起位   |
| void NVIC_ClearPendingIRQ(IRQn_Type IRQn)                | 清除中断悬起位   |
| uint32_t NVIC_GetPendingIRQ(IRQn_Type IRQn)              | 获取悬起中断编号 |
| void NVIC_SetPriority(IRQn_Type IRQn, uint32_t priority) | 设置中断优先级   |
| uint32_t NVIC_GetPriority(IRQn_Type IRQn)                | 获取中断优先级   |
| void NVIC_SystemReset(void)                              | 系统复位         |

### 优先级
在 NVIC 有一个专门的寄存器:中断优先级寄存器 NVIC_IPRx,用来配置外部中断的优先级,IPR 宽度为 8bit,原则上每个外部中断可配置的优先级为 0~255,数值越小,优先级越高。但是绝大多数 CM3 芯片都会精简设计,以致实际上支持的优先级数减少,在F103 中,只使用了高 4bit

| bit7           | bit6   | bit5 | bit4 | bit3 | bit2 | bit1 | bit0 |
| -------------- | ------ | ---- | ---- | ---- | ---- | ---- | ---- |
| 用于表达优先级 | 未使用 |      |      |      |      |      |      |

### 

在配置每个中断的时候一般有 3 个编程要点：
1. 使能外设某个中断,这个具体由每个外设的相关中断使能位控制。
	比如串口有发送完成中断,接收完成中断,这两个中断都由串口控制寄存器的相关中断使能位控制
2. 初始化 NVIC_InitTypeDef 结构体,配置中断优先级分组,设置抢占优先级和子优先级,使能中断请求。NVIC_InitTypeDef 结构体在固件库头文件 misc.h 中定义。
	NVIC初始化结构体
	~~~c
	typedef struct {
		uint8_t NVIC_IRQChannel;		// 中断源
		uint8_t NVIC_IRQChannelPreemptionPriority;	// 抢占优先级
		uint8_t NVIC_IRQChannelSubPriority;		// 子优先级
		FunctionalState NVIC_IRQChannelCmd; 	// 中断使能或者失能
	}
	~~~
+ NVIC_IRQChannel：
	用来设置中断源,不同的中断中断源不一样,且不可写错,即使写错了程序也不会报错,只会导致不响应中断。
	**具体成员配置在stm32f10x.h头文件里面的IRQ_Type结构体里**
	抢占优先级与子优先级分别设置中断的优先级
	
3.  编写中断服务函数
	在启动文件中每个中断写了一个中断服务函数，都是空的，需要重新编写
	在stm32f10x_it.c中
	



