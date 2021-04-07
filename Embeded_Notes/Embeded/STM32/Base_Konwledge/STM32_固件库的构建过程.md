## 1. 寄存器映射

存储器本身不具有地址信息，给存储器分配地址的过程就是存储器映射

> 存储器功能分类

| 序号   | 用途                | 地址范围(512MB)         |
| ------ | ------------------- | ----------------------- |
| Block0 | Code                | 0x0000 0000~0x1FFF FFFF |
| Block1 | SRAM                | 0x2000 0000~0x3FFF FFFF |
| Block2 | 片上外设            | 0x4000 0000~0x5FFF FFFF |
| Block3 | FSMC上的bank1~bank2 | 0x6000 0000~0x7FFF FFFF |
| Block4 | FSMC上的bank3~bank4 | 0x8000 0000~0x9FFF FFFF |
| Block5 | FSMC寄存器          | 0xA000 0000~0xCFFF FFFF |
| Block6 | 没用                | 0xD000 0000~0xDFFF FFFF |
| Block7 | Cortex-M3内部外设   | 0xE000 0000~0xFFFF FFFF |

> 通过地址单元访问内存单元

~~~c
// GPIOB端口全部输出高电平
// 直接操作内存
*(unsigned int *)(0x40010c0c) = 0xffff;
// 0x40010c0c 是ODR的地址
/* 通过寄存器名称访问内存单元 */
# define GPIOB_ODR (unsigned int*)(0x40010c0c)
* GPIOB_ODR = 0xff;
// 为了方便操作，把指针操作也加到其中
# define GPIOB_ODR *(unsigned int*)(0x40010c0c)
GPIOB_ODR = 0xff;
~~~

## 2. 寄存器

> 给有特定功能的内存单元数取一个别名，别名就是内存器

### 寄存器映射

> 给这个已经分配好地址的有特定功能的内存单元数取别名的过程就是寄存器映射

~~~c
#define PERIPH_BASE ((unsigned int)0x40000000）
#define APB2PERIPH_BASE (PERIOH_BASE)+0x00010000
#define GPIOB_BASE *(APB2PHERIPH_BASE+0x0C00)
// PB0输出低电平
GPIOB_ODR &= ~(1<<0);
// PB0输出高电平
GPIOB_ODR |= ~(1<<0);
~~~

### 通过寄存器映射点灯

~~~c
int main(void)
{
    // 打开GPIOB端口的时钟
    *(unsigned int *)0x40021000 |= ((1)<<3);
    // 配置IO口为输出
    *(unsigned int *)0x4000c000 |= ((1)<< (4*0));
    // 控制ODR寄存器
    *(unsigned int *)0x4000c00c &= ~(1<<0);    
}
void SystemInit()
{
    
}
~~~

### 使用结构体封装寄存器列表

~~~C
typedef unsigned int 	uint32_t;
typedef short int 		uint16_t;
/* GPIO寄存器列表 */
typedef struct{
	uint32_t CRL;		
    uint32_t ORH; // 端口配置寄存器
    uint32_t IDR;	
    uint32_t ODR;	
    uint32_t BSRR;	
    uint32_t BRR;
    uint32_t LCKR;
}GPIO_TypeDef;
~~~

使用结构体指针访问寄存器

~~~c
GPIO_TypeDef *GPIOx;
GPIOx = GPIOB_BASE;
GPIOx->IDR = 0xffff;
GPIOx->ODR = 0xffff;
uint32_t temp;
temp = GPIOx->IDR;
~~~
以此类推，这些外设都可以运用结构体指针来进行操作

## 自己写库 构建库函数雏形

利用结构体指针指向外设地址，进而操作内存

### 结构体示例

~~~c
typedef unsigned int uint32_t;
typedef unsigned short uint16_t;

typedef struct{
    uint32_t CRL;
    uint32_t CRH;
    uint32_t ODR;
    uint32_t BSRR;
    uint32_t BRR;
    uint32_t LCKR;
}GPIO_TypeDef;

#define GPIOB (GPIO_TypeDef*)(GPIOB_BASE) 

// RCC也可以是一个结构体
RCC_APB2ENR |= ((1) << (3));
// 配置IO口的输出
GPIOB->CLR |= ((1) << (4*0));
// 控制ODR寄存器
GPIOB->ODR &= ~(1<<0);
~~~

### 编写端口置位与复位函数

~~~c
// 定义引脚
#define GPIO_Pin_0 ((uint16_t)0x0001)
// ... ...
#define GPIO_Pin_All (uint16_t)(0xFFFF)
// 置位
void GPIO_SetBit(GPIO_TypeDef *GPIOx,uint16_t GPIO_Pin)
{
    GPIOx->BSRR |= GPIO_Pin;
}
// 清楚
void GPIO_ResetBit(GPIO_TypeDef *GPIOx,uint16_t GPIO_Pin)
{
    GPIOx->BRR |= GPIO_Pin;
}
~~~

### 进一步完善

~~~c
// GPIO Speed set
typedef enum{
    GPIO_Speed_10MHZ = 1,
    GPIO_Speed_2MHZ,
    GPIO_Speed_50MHZ
}GPIO_Speed_Typedef;

// GPIO
typedef enum{
    GPIO_Mode_AIN = 0x0, //模拟输入
    GPIO_Mode_IN_FLOATING = 0x04, //浮空输入
    GPIO_Mode_IPD = 0x28,	//下拉输入
    GPIO_Mode_IDU = 0x48,	//上拉输入
    
    GPIO_Mode_Out_OD = 0x14,	//开漏输出
    GPIO_Mode_Out_PP = 0x10,	//推挽输出
    GPIO_Mode_Out_PP = 0x1C,	//复用开漏输出
    GPIO_Mode_Out_PP = 0x18,	//复用推挽输出
}GPIOMode_TypeDef;
// GPIO初始化结构体
typedef struct{
	uint16_t GPIO_Pin;
	uint16_t GPIO_Speed;
	uint16_t GPIO_Mode;
}GPIO_InitTypeDef;
~~~

## 提高可移植性

### 建立文件夹

在文件夹中建立.c和.h文件，并在工程中包含其中
多定义宏，通过修改宏的值来整体更改程序的执行