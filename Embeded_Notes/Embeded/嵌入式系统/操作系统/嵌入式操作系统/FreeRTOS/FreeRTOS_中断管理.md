# FreeRTOS中断管理
## 中断简介
中断是微控制器一个很常见的特性，中断由硬件产生，当中断产生之后CPU就会中断当前的流程转而去处理中断服务，Cortex-M内核的MCU提供一个用于中断管理的桥套向量中断控制器(NVIC)  
Cortex-M3和M4的NVIC最多支持240个IRQ(中断请求)、一个不可屏蔽中断(NMI)、一个SysTick(滴答定时器中断和多个系统异常)。  

## 优先级分组
为了使抢占机制变得可控，CM3还把256级优先级按位分成高低两段，分别是抢占优先级和亚优先级，MSB所在的位段对应抢占优先级，而LSB所在的位段对应亚优先级  

| 分组位置 | 表达抢占优先级的位段 | 表达亚优先级的位段 |
| -------- | -------------------- | ------------------ |
| 0        | [7:1]                | [0:0]              |
| 1        | [7:2]                | [1:0]              |
| 2        | [7:3]                | [2:0]              |
| 3        | [7:4]                | [3:0]              |
| 4        | [7:5]                | [4:0]              |
| 5        | [7:6]                | [5:0]              |
| 6        | [7:7]                | [6:0]              |
| 7        | None                 | [7:0] (All bits)   | 

优先级分组通过寄存器ARICR设置，地址为0xE000ED00  
绝大数CM3芯片会`精简设计`，以至于实际支持的优先级会更少。  


## FreeRTOS中断
### FreeRTOS中断配置宏
+ configPRIO_BITS
	+ 此宏用来设置MCU使用几位优先级，STM32使用的是4位，因此此宏为
+ configLIBRARY_LOWEST_INTERRUPT_PRIORITY
	+ 此宏是用来设置最低优先级，STM32配置的组使用的是4</br>也就是四位都是抢占优先级，因此优先级数就是16个，最低优先级为15，这个宏此时就是15
+ configKERNEL_INTERRUPT_PRIORITY
	+ 用来设置内核中断优先级
	+ 这个宏为configLIBRARY_LOWEST_INTERRUPT_PRIORITY左移8-configPRIO_BITS位得到的，也就是左移四位。
	+ 这个宏用来设置PendSV和滴答定时器的中断优先级，在port.c中有定义
	![[Pasted image 20210714181125.png]]
	+ PendSV和SysTick的中断优先级设置是操作`0xE000_ED20`地址的，这样一次写入的是32个位的数据，SysTick和PendSV的优先级寄存器分别对应这个32位数据的最高八位和次高八位。
	+ PendSV的优先级在xPortStartScheducler()中设置，此函数在文件port.c中
	![[Pasted image 20210714181702.png]]
	这个位置设置PendSV和SysTick优先级，直接向地址`portNVIC_SYSPRI2_REG`写入优先级数据，`portNVIC_SYSPRI2_REG`是个宏，也是在同文件中定义的，就是相关寄存器的地址
	
+ configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY
	+ 此宏用来设置FreeRTOS系统可管理的最大优先级，设置此值，高于此值优先级的中断不归于FreeRTOS管理。
+ configMAX_SYSCALL_INTERRUPT_PRIORITY
	+ configLIBRARY_MAX_SYSCALL_INTERRUPT_PRIORITY左移4位得到，此宏设置好以后，低于此优先级的中断可以安全的调用FreeRTOS的API函数，高于此优先级的中断FreeRTOS是不能禁止的，中断服务函数也不能调用FreeRTOS的API

	![[Pasted image 20210714182449.png]]
	
	configMAX_SYSCALL_INTERRUPT_PRIORITY的优先级不会被FreeRTOS内核屏蔽，因此那些对实时性要求严格的任务就可以使用这些优先级，比如四轴飞行器中的壁障检测。
## FreeRTOS开关中断

### 开中断函数
portENABLE_INTERRUPTS()

### 关中断函数
portDISENABLE_INTERRUPTS()

