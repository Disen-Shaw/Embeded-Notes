# STM32_串口编程
## 串口编程
### 串口标准库
~~~c
  // 串口初始化函数
typedef struct
{
    uint32_t USART_BaudRate;	// 波特率
    uint16_t USART_WordLength;	// 字长 CR1_M
    uint16_t USART_StopBits;	// 停止位CR2_STOP
    uint16_t USART_Parity;		// 校验控制 CR1_PCE、CR1_PS
    uint16_t USART_Mode;		// 模式选择
    // 硬件流选择 CR3_CTSE、CR3_RTSE
    uint16_t USART_HardwareFlowControl;
} USART_InitTypeDef;


/* 同步时钟初始化结构体 */
typedef struct{
    uint16_t USART_Clock;		// 同步时钟
    uint16_t USART_CPOL;		// 极性CR2_CPOL
    uint16_t USART_CPHA;		// 相位CR2_CPHA
    uint16_t USART_LastBit;		// 最后一个位的时钟脉冲 CR2_LBC
} USART_ClockInitTypeDef;


/* 串口初始化函数 */
void USART_Init(USART_TypeDef *USARTx,USART_InitTypeDef *USART_InitStructure);
/* 中断配置函数 */
void USART_ITConfig(USART_TypeDef *USARTx,uint16_t USART_IT,FunctionalState NewState);
/* 串口使能函数 */
void USART_Cmd(USART_TypeDef *USARTx,FunctionalState NewState);
/* 数据发送函数 */
void USART_SendData(USART_TypeDef *USARTx,uint16_t Data);
/* 数据接收函数 */
uint16_t USART_ReceiveData(USART_TypeDef *USARTx);
/* 中断状态获取函数 */
ITStatus USART_GetITStatus(USART_TypeDef *USARTx,uint16_t USART_IT);
~~~

### 中断接收和发送
~~~c
/* 头文件 */ 
/* bsp_usart.h */
#ifndef __BSP_USART_H
#define __BSP_USART_H

#include "stm32f10x.h"

// 串口宏定义
// 串口1-USART1
#define DEBUG_USARTx USART1
#define DEBUG_USART_Clk RCC_APB2Periph_USART1
#define DEBUG_USART_APBxClkCmd RCC_APB2PeriphClockCmd
#define DEBUG_USART_BAUDRATE 115200

// USART GPIO 引脚定义
#define DEBUG_USART_GPIO_Clk RCC_APB2Periph_GPIOA
#define DEBUG_USART_GPIO_APBxClkCmd RCC_APB2PeriphClockCmd

#define DEBUG_USART_TX_GPIO_PORT GPIOA
#define DEBUG_USART_TX_GPIO_PIN GPIO_Pin_9
#define DEBUG_USART_RX_GPIO_PORT GPIOA
#define DEBUG_USART_TX_GPIO_PIN GPIO_Pin_10

#define DEBUG_USART_IRQ	USART1_IRQn
#define DEBUG_USART_IRQHandler	USART1_IRQHandler

#endif

/* 源文件 */
#include "bsp_usart.h"


static void NVIC_Configuration(void)
{
    NVIC_InitTypeDef NVIC_InitStruct;
    // 嵌套向量中断控制器组选择
    NVIC_PriorityGroupConfig(NVICPriorityGroup2);
    // 配置中断源
    NVIC_InitStruct.NVIC_IRQChannel = DEBUG_USART_IRQ;
    NVIC_InitStruct.NVIC_IRQChannelPreemptionPriority = 1;		// 抢占优先级
    NVIC_InitStruct.NVIC_IRQChannelSubPriority = 1;				// 子优先级
    NVIC_InitStruct.NVIC_IRQChannelCmd = ENABLE;				// 使能中断
    NVIC_Init(&NVIC_InitStruct);								// 初始化
}

void USART_Config(void)
{
    GPIO_InitTypeDef GPIO_InitStructure;
    USART_InitTypeDef USART_InitStructure;

    // 打开GPIO时钟
    DEBUG_USART_GPIO_APBxClkCmd(DEBUG_USART_GPIO_CLK,ENABLE);

    // 打开串口外设时钟
    DEBUG_USART_APBxClkCmd(DEBUG_USART_CLK,ENABLE);

    // 将USART Tx的GPIO配置为推挽复用模式
    GPIO_InitStructure.GPIO_Pin = DEBUG_USART_TX_GPIO_PIN;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_InitStructure,GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_Init(DEBUG_USART_TX_GPIO_PORT,&GPIO_InitStructure);
    // 将USART Rx的GPIO配置为浮空输入模式
    GPIO_InitStructure.GPIO_Pin = DEBUG_USART_RX_GPIO_PIN;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
    GPIO_Init(DEBUG_USART_RX_GPIO_PORT,&GPIO_InitStructure);

    // 配置串口的工作参数
    // 配置波特率
    USART_InitStructure.USART_BanudRate = DEBUG_USART_BAUDRATE;
    // 配置祯数据字长
    USART_InitStructure.USART_WordLength = USART_WordLength_8b;
    // 配置停止位
    USART_InitStructure.USART_StopBits = USART_StopBits_1;
    // 配置校验位
    USART_InitStructure.USART_Parity = USART_Parity_No;
    // 配置硬件流控制
    USART_InitStructure.USART_HardwareFlowControl = 		   USART_HardwareFlowControl_None;
    // 配置工作模式 收发一起
    USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
    // 完成串口的初始化配置
    USART_Init(DEBUG_USARTx,&USART_InitStructure);

    // 串口中断优先级配置
    NVIC_Configuration();
    // 使能串口接收中断
    USART_ITConfig(DEBUG_USARTx,USART_IT_RXNE,ENABLE);
    // 使能串口
    USART_Cmd(DEBUG_USARTx,ENABLE);    
}

void Usart_SentByte(USART_TypeDef *pUSARTx,uint8_t data)
{
    USART_SentData(pUSARTx,data);
    // 等待改字节发送完毕
    while(USART_GetFlagStatus(pUSART,USART_FLAG_TXE) == RESET );
}

/* 主函数文件 */
/* main.c */
#include "头文件"

int main()
{
    USART_Config();
    USART_SentByte(DEBUG_USARTx, 100 );
    while(1);
}

~~~
### 串口进阶编程
~~~c
/* 发送两个字节 */
void Usart_SendHalfWord(USART_TypeDef *pUSART,uint16_t data)
{
    uint8_t temp_h,temp_l;
    
    temp_h = (data&0xff00)>>8;
    temp_h = (data&0xff);
    
    USART_SendData(pUSART,temp_h);
    while(USART_GetFlagStatus(pUSART,USART_FLAG_TXE) == RESET );
    USART_SendData(pUSART,temp_l);
    while(USART_GetFlagStatus(pUSART,USART_FLAG_TXE) == RESET );
}

/* 发送8位数组 */
void Usart_SendArray(USART_TypeDef *pUSART,uint8_t *arr,uint8_t num)
{
    for(uint8_t i = 0; i<num ;i++)
    {
        USART_SendData(pUSART,*(arr+i));
    }
    while(USART_GetFlagStatus(pUSART,USART_FLAG_TC) == RESET );
}

/* 发送字符串 */
void Usart_SendString(USART_TypeDef,uint8_t *str)
{	
    uint8_t i = 0;
    do
    {
       Usart_SendArray(pUSART,*(str+i));
        i++;
    }while( *(str+i) != '\0' );
    while(USART_GetFlagStatus(pUSART,USART_FLAG_TC) == RESET );
}

/* printf函数 */
#include <stdio.h>
// 重定向c库函数printf到串口，重定向后可以使用printf函数
int fputc(int ch,FILE *f)
{
    USART_SendData(DEBUG_USARTx,(uint8_t) ch);
    while(USART_GetFlagStatus(pUSART,USART_FLAG_TXE) == RESET );
    return (ch);
}
// 经过以上更改后
putchar('P');

/* scanf函数 */
// 重定向c库函数scanf到串口，可食用scanf，getchar等函数
int fgetc(FILE *f)
{
    while(USART_GetFlagStatus(DEBUG_USARTx,USART_FLAG_RXNE) == RESET );
    return (int)USART_ReceiveData(DEBUG_USARTx);
}
~~~
如果要换串口，修改宏定义即可
~~~c
// 条件判断宏
// 串口1——3
#define DEBUG_USART1 1
#define DEBUG_USART2 0
#define DEBUG_USART3 0
#define DEBUG_USART4 0
#define DEBUG_USART5 0
// 串口1
#if DEBUG_USART1
/*
	DEBUG_USART1的宏定义
	包括：
	
	// 串口参数
	DEBUG_USARTx				串口号
	DEBUG_USART_CLK				串口时钟配置
	DEBUG_USART_APBxClkCmd		串口外设时钟	(和上面的配置的寄存器不同)
	DEBUG_USART_BAUDRATE		波特率
	
	// GPIO 引脚定义
	DEBUG_USART_GPIO_CLK		引脚GPIO时钟定义
	DEBUG_USART_GPIO_APBxCLKCmd	GPIO时钟
	
	DEBUG_USART_TX_GPIO_PORT	发送端GPIO端口
	DEBUG_USART_TX_GPIO_PIN		发送端引脚
	DEBUG_USART_RX_GPIO_PORT	接收端GPIO端口
	DEBUG_USART_RX_GPIO_PIN		接收端引脚
	
	DEBUG_USART_IRQ				中断源
	DEBUG_USART_IRQHandler		中断源处理
	
*/
// 串口2
#elif DEBUG_USART2
/*
	DEBUG_USART2的宏定义
*/
// 串口3
#elif DEBUG_USART3
/*
	DEBUG_USART3的宏定义
*/
// 串口4
#elif DEBUG_USART4
/*
	DEBUG_USART4的宏定义
*/
// 串口5
#elif DEBUG_USART5
/*
	DEBUG_USART5的宏定义
*/
#endif
~~~
