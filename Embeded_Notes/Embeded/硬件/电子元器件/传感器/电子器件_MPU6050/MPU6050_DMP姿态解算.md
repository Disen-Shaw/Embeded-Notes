# MPU6050 DMP姿态解算移植
`基于标准库`
## 程序重点
**提供 I2C 读写接口、定时服务及 INT 中断处理**
从陀螺仪中获取原始数据并处理
更新数据并输出

## 分析
官方驱动主要是MPL软件库，要移植软件要为其提供I2C读写接口、定式服务以及MPU6050的数据更新标志

如果输出调试信息还需要输出调试信息到上位机
### 硬件设计
使用INT引脚产生的中断信号

## 移植
### I2C接口
MPL库的内部对I2C读写使用两个函数，在文件**inv_mpu.c**中
并且读写函数有固定的格式

```c
i2c_write(	unsigned char slave_addr, 
			unsigned char reg_addr,
			unsigned char length,
			unsigned char const *data)；
i2c_read(	unsigned char slave_addr,
			unsigned char reg_addr,
			unsigned char length,
			unsigned char *data)

#define i2c_write Sensors_I2C_WriteRegister
#define i2c_read Sensors_I2C_ReadRegister
```

这些接口可以用之前的
Sensors_I2C_ReadRegister
Sensors_I2C_WriteRegister 
进行宏定义替换

### 提供定时服务
MPL 软件库中使用到了延时及时间戳功能
要求需要提供 delay_ms 函数实现毫秒级延时,提供 get_ms 获取毫秒级的时间戳
它们的接口格式也在“inv_mpu.c”文件中给出
```c
#define delay_ms Delay_ms
#define get_ms get_tick_count
```
使用SysTick每毫秒产生一次中断，用于计时
```c
static __IO u32 TimingDelay;
static __IO uint32_t g_ul_ms_ticks=0;

/**
	* @brief us 延时程序,1ms 为一个单位
	* @param
	*@arg nTime: Delay_ms( 1 ) 则实现的延时为 1 ms
	* @retval 无
*/
void Delay_ms(__IO u32 nTime)
{
	TimingDelay = nTime;
	while (TimingDelay != 0);
}

/**
	* @brief 获取节拍程序
	* @param 无
	* @retval 无
	* @attention 在 SysTick 中断函数 SysTick_Handler()调用
*/
void TimingDelay_Decrement(void)
{
	if (TimingDelay != 0x00)
	{
		TimingDelay--;
	}
}

/**
	* @brief 获取当前毫秒值
	* @param 存储最新毫秒值的变量
	* @retval 无
*/
int get_tick_count(unsigned long *count)
{
	count[0] = g_ul_ms_ticks;
	return 0;
}

/**
	* @brief 毫秒累加器,在中断里每毫秒加 1
	* @param 无
	* @retval 无
*/
void TimeStamp_Increment (void)
{
	g_ul_ms_ticks++;
}
```

TimingDelay_Decrement 和 TimeStamp_Increment 函数是在 Systick 的中断服务函数中被调用的
systick 被配置为每毫秒产生一次中断,
而每次中断中会对 TimingDelay 变量减 1，
对 g_ul_ms_ticks 变量加 1

它们分别用于 Delay_ms 函数利用 TimingDelay 的值进行阻塞延迟 , 而 get_tick_count 函数获取的时间戳即g_ul_ms_ticks 的值

SysTick的中断服务函数
```c
/**
	* @brief SysTick 中断服务函数.
	* @param None
	* @retval None
*/
void SysTick_Handler(void)
{
	TimingDelay_Decrement();
	TimeStamp_Increment();
}
```

### 提供串口调试
串口调试接口参考[串口调试](https://gitee.com/shao_disheng/stm32-module/tree/master/Print_Mode)
MPL代码库的调试信息输出函数都集中在log_stm32.c文件这种，可以为这些函数提供串口输出接口，一遍把这些信息输出到上位机

输出四元数
```c
void eMPL_send_quat(long *quat)
{
	char out[PACKET_LENGTH];
	int i;
	if (!quat)
	return;
	memset(out, 0, PACKET_LENGTH);
	out[0] = '$';
	out[1] = PACKET_QUAT;
	out[3] = (char)(quat[0] >> 24);
	out[4] = (char)(quat[0] >> 16);
	out[5] = (char)(quat[0] >> 8);
	out[6] = (char)quat[0];
	out[7] = (char)(quat[1] >> 24);
	out[8] = (char)(quat[1] >> 16);
	out[9] = (char)(quat[1] >> 8);
	out[10] = (char)quat[1];
	out[11] = (char)(quat[2] >> 24);
	out[12] = (char)(quat[2] >> 16);
	out[13] = (char)(quat[2] >> 8);
	out[14] = (char)quat[2];
	out[15] = (char)(quat[3] >> 24);
	out[16] = (char)(quat[3] >> 16);
	out[17] = (char)(quat[3] >> 8);
	out[18] = (char)quat[3];
	out[21] = '\r';
	out[22] = '\n';
	for (i=0; i<PACKET_LENGTH; i++) {
		printf(out[i]);
}
```

### 中断接口
MPL代码库使用了MPU6050的INT中断信号
为此要提供外部中断接口
```c
#define EXTI_INT_FUNCTION EXTI15_10_IRQHandler
void EXTI_INT_FUNCTION (void)
{
	if (EXTI_GetITStatus(MPU_INT_EXTI_LINE) != RESET) { //确保是否产生了 EXTI Line 中断
	/* 处理新的数据 */
	gyro_data_ready_cb();
	EXTI_ClearITPendingBit(MPU_INT_EXTI_LINE);
	//清除中断标志位
	}
}
```

在工程中我们把 MPU6050 与 STM32 相连的引脚配置成了中断模式,上述代码是该引脚的中断服务函数,在中断里调用了 MPL 代码库的 gyro_data_ready_cb 函数,它设置了标志变量 hal.new_gyro,以通知 MPL 库有新的数据

```c
/* 每当有新的数据产生时，函数会被中断服务函数调用
 * 在本工程中，它设置标志位用于指示及保护 FIFO 缓冲区
*/
void gyro_data_ready_cb(void)
{
	hal.new_gyro = 1;
}
```

### 主函数流程
看 main 函数了解如何利用 MPL 库获取姿态数据
```c

```
主要流程概括
初始化 STM32 的硬件,如 Systick、LED、调试串口、INT 中断引脚以及 I2C 外设的初始化

+ 调用 MPL 库函数 mpu_init 初始化传感器的基本工作模式
+ 调用 inv_init_mpl 函数初始化 MPL 软件库,初始化后才能正常进行解算
+ 设置各种运算参数,如四元数运算(inv_enable_quaternion)、6 轴或 9 轴数据融合(inv_enable_9x_sensor_fusion)等等
+ 设置传感器的工作模式(mpu_set_sensors)、采样率(mpu_set_sample_rate)、分辨率(inv_set_gyro_orientation_and_scale)等等
+ 当 STM32 驱动、MPL 库、传感器工作模式、DMP 工作模式等所有初始化工作都完成后进行 while 循环
+ 在 while 循环中检测串口的输入,若串口有输入,则调用 handle_input 根据串口输入的字符(命令),切换工作方式
	+ 为了支持上位机通过输入命令,根据进行不同的处理,如开、关加速度信息的采集或调试信息的输出等
+ 在 while 循环中检测是否有数据更新( if (hal.new_gyro && hal.dmp_on) ),当有数据更新的时候产生 INT 中断,会使 hal.new_gyro 置 1 的,从而执行 if 里的条件代码
+ 使用 dmp_read_fifo 把数据读取到 FIFO,这个 FIFO 是指 MPL 软件库定义的一个缓冲区,用来缓冲最新采集得的数据
+ 调用 inv_build_gyro、inv_build_temp、inv_build_accel 及 inv_build_quat 函数处理数据角速度、温度、加速度及四元数数据,并对标志变量 new_data 置 1;
+ 在 while 循环中检测 new_data 标志位,当有新的数据时执行 if 里的条件代码;
+ 调用 inv_execute_on_data 函数更新所有数据及状态;
+ 调用 read_from_mpl 函数向主机输出最新的数据。

### 数据输出接口
main 中最后调用的 read_from_mpl 函数演示了如何调用 MPL 数据输出接口,通过这些接口我们可以获得想要的数据



