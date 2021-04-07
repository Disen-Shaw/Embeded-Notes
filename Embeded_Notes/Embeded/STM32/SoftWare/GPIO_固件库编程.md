# GPIO_固件库编程
## GPIO输出编程
> 编程要点
+ 使能 GPIO 端口时钟;
+ 初始化 GPIO 目标引脚为推挽输出模式;
+  编写简单测试程序,控制 GPIO 引脚输出高、低电平

> LED(GPIO)引脚宏定义

~~~c
// R-红色
#define LED1_GPIO_PORT GPIOB
#define LED1_GPIO_CLK RCC_APB2Periph_GPIOB
#define LED1_GPIO_PIN GPIO_Pin_5
// G-绿色
#define LED2_GPIO_PORT GPIOB
#define LED2_GPIO_CLK RCC_APB2Periph_GPIOB
#define LED2_GPIO_PIN GPIO_Pin_0
// B-蓝色
#define LED3_GPIO_PORT GPIOB
#define LED3_GPIO_CLK RCC_APB2Periph_GPIOB
#define LED3_GPIO_PIN GPIO_Pin_1
~~~
宏定义引脚端口、引脚时钟外设、引脚号

>控制LED灯亮灭的宏定义

~~~c
#define digitalHi(p,i) {p->BSRR=i;} //输出为高电平
#define digitalLo(p,i) {p->BRR=i;}  // 输出为低电平
#define digitalToggle(p,i) {p->ODR ^=i;} // 反转状态
// 定义IO的宏
#define LED1_TOGGLE digitalToggle(LED1_GPIO_PORT,LED1_GPIO_PIN)
#define LED1_OFF digitalHi(LED1_GPIO_PORT,LED1_GPIO_PIN)
#define LED1_ON digitalLo(LED1_GPIO_PORT,LED1_GPIO_PIN)

#define LED2_TOGGLE digitalToggle(LED2_GPIO_PORT,LED2_GPIO_PIN)
#define LED2_OFF digitalHi(LED2_GPIO_PORT,LED2_GPIO_PIN)
#define LED2_ON digitalLo(LED2_GPIO_PORT,LED2_GPIO_PIN)

#define LED3_TOGGLE digitalToggle(LED3_GPIO_PORT,LED3_GPIO_PIN)
#define LED3_OFF digitalHi(LED3_GPIO_PORT,LED3_GPIO_PIN)
#define LED3_ON digitalLo(LED3_GPIO_PORT,LED3_GPIO_PIN)

// 某个灯的亮灭
#define LED_RED \
				LED1_ON; \
				LED2_OFF \
				LED3_OFF
				
#define LED_GREEN \
				LED1_OFF; \
				LED2_ON \	
				LED3_OFF
				
#define LED_BLUE \
				LED1_OFF; \
				LED2_OFF \	
				LED3_ON				
~~~
固件库编程
~~~c
// GPIO初始化
void LED_GPIO_Config(void)
{
	/*定义一个 GPIO_InitTypeDef 类型的结构体*/
	GPIO_InitTypeDef GPIO_InitStructure;
	/*开启 LED 相关的 GPIO 外设时钟*/
	RCC_APB2PeriphClockCmd( LED1_GPIO_CLK|
							LED2_GPIO_CLK|
							LED3_GPIO_CLK, ENABLE);
	/*选择要控制的 GPIO 引脚*/
	GPIO_InitStructure.GPIO_Pin = LED1_GPIO_PIN;
	/*设置引脚模式为通用推挽输出*/
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	/*设置引脚速率为 50MHz */
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	/*调用库函数,初始化 GPIO*/
	GPIO_Init(LED1_GPIO_PORT, &GPIO_InitStructure);
	/*选择要控制的 GPIO 引脚*/
	GPIO_InitStructure.GPIO_Pin = LED2_GPIO_PIN;
	/*调用库函数,初始化 GPIO*/
	GPIO_Init(LED2_GPIO_PORT, &GPIO_InitStructure);
	/*选择要控制的 GPIO 引脚*/
	GPIO_InitStructure.GPIO_Pin = LED3_GPIO_PIN;
	/*调用库函数,初始化 GPIOF*/
	GPIO_Init(LED3_GPIO_PORT, &GPIO_InitStructure);
	/* 关闭所有 led 灯 */
	GPIO_SetBits(LED1_GPIO_PORT, LED1_GPIO_PIN);
	/* 关闭所有 led 灯 */
	GPIO_SetBits(LED2_GPIO_PORT, LED2_GPIO_PIN);
	/* 关闭所有 led 灯 */
	GPIO_SetBits(LED3_GPIO_PORT, LED3_GPIO_PIN);
}

~~~
## GPIO输入编程
>编程要点

+ 使能GPIO口
+ 初始化 GPIO 目标引脚为输入模式(浮空输入)
+ 编写简单测试程序,检测按键的状态,实现按键控制 LED 灯
~~~c
/* 	
	和LED灯基本一样
	1. 按键宏定义
	2. 按键初始化
	3. 编写按键功能函数
*/
	uint8_t Key_Scan(GPIO_TypeDef* GPIOx,uint16_t GPIO_Pin)
	{
		/*检测是否有按键按下 */
		if (GPIO_ReadInputDataBit(GPIOx,GPIO_Pin) == KEY_ON ) 
		{
			/*等待按键释放 */
			while (GPIO_ReadInputDataBit(GPIOx,GPIO_Pin) == KEY_ON);
			return KEY_ON;
		}
		else
		{
			return KEY_OFF;
		}
	}
~~~

## GPIO位带操作
>位操作就是可以单独的对一个比特位读和写,这个在 51 单片机中非常常见。51 单片机中通过关键字 sbit 来实现位定义,STM32 没有这样的关键字,而是通过访问位带别名区来实现。

在STM32中,有两个地方实现了位带,一个是SRAM区的最低1MB空间,令一个是外设区最低1MB空间，可以通过这个空间来对外设进行位操作

![[Pasted image 20210308193112.png]]

转换公式：
addr&0xF0000000)+0x02000000+((addr & 0x00FFFFFF)<<5)+(bitnum<<2)

直接实现GPIO的微操作
~~~c
// 地址赋予
#define GPIOA_ODR_Addr (GPIOA_BASE+8)
#define GPIOB_ODR_Addr (GPIOB_BASE+8)
#define GPIOC_ODR_Addr (GPIOC_BASE+8)
#define GPIOD_ODR_Addr (GPIOD_BASE+8)
#define GPIOE_ODR_Addr (GPIOE_BASE+8)

#define GPIOA_IDR_Addr (GPIOA_BASE+8)
#define GPIOB_IDR_Addr (GPIOB_BASE+8)
#define GPIOC_IDR_Addr (GPIOC_BASE+8)
#define GPIOD_IDR_Addr (GPIOD_BASE+8)
#define GPIOE_IDR_Addr (GPIOE_BASE+8)

// GPIO位操作
#define PAout(n) BIT_ADDR(GPIOA_ODR_Addr,n) // 输出
#define PAout(n) BIT_ADDR(GPIOA_IDR_Addr,n) // 输入
#define PBout(n) BIT_ADDR(GPIOA_ODR_Addr,n) // 输出
#define PBout(n) BIT_ADDR(GPIOA_IDR_Addr,n) // 输入
... ...
#define PEout(n) BIT_ADDR(GPIOA_ODR_Addr,n) // 输出
#define PEout(n) BIT_ADDR(GPIOA_IDR_Addr,n) // 输入
~~~
