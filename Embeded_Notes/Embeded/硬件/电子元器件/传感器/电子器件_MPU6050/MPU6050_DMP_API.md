# MPU6050 DMP库的API接口
## 文件介绍
### inv_mpu.c
基于i2c的Invensense陀螺仪驱动程序  

### inv_mpu_dmp_android.c
DMP图像功能和界面功能  

## 函数
****
**int dmp_enable_6x_lp_quat(unsigned char enable)**    
从dmp中生成六轴四元数    
在这个驱动程序中，三轴和六轴DMP四元数特征是相互排斥的    
参数：1,使能六轴四元数    
返回值：如果成功，则返回0    
****  
**int dmp_enable_feature (unsigned short mask)**    
使能DMP的特性    
mask掩码：    
DMP_FEATURE_TAP    
DMP_FEATURE_ANDROID_ORIENT    
DMP_FEATURE_LP_QUAT    
DMP_FEATURE_6X_LP_QUAT    
DMP_FEATURE_GYRO_CAL    
DMP_FEATURE_SEND_RAW_ACCEL    
DMP_FEATURE_SEND_RAW_GYRO    
注：DMP_FEATURE_LP_QUAT和DMP_FEATURE_6X_LP_QUAT是相互排斥的    
参数：mask 要使能的功能掩码    
返回值：如果成功，则返回0    
****  
**int dmp_enable_gyro_cal (unsigned char enable)**    
校准DMP中的陀螺仪数据    
8秒内没有动作，DMP将计算陀螺偏差并从四元数输出中减去它们    
如果dmp_enable_feature的参数是DMP_FEATURE_SEND_CAL_GYRO，这些偏差也将从陀螺仪中减去    
参数：1来使能陀螺仪标定    
返回值：如果成功，则返回0    
****  
**int dmp_enable_lp_quat (unsigned char enable)**    
从DMP中生成三轴四元数    
在这个驱动程序中，三轴和六轴DMP四元数特征是相互排斥的    
参数：1去使能三轴四元数    
返回值：如果成功返回0    
****  
**int dmp_enable_no_motion_detection (unsigned char enable)**    
检测加速度轴的无运动事件发生    
参数：用1来使能加速度轴无运动事件发生    
返回值：如果成功，则返回0    
****  
**int dmp_get_fifo_rate (unsigned short ∗rate)**    
得到DMP的输出速率    
参数：FIFO的速率    
返回值：如果成功，则返回0    
****  
**int dmp_get_pedometer_step_count (unsigned long ∗count) **    
获取当前计数步长    
参数：检测到的步数    
返回值：如果成功，则返回0    
****  
**int dmp_get_pedometer_walk_time (unsigned long ∗ time)**    
获取走步的持续时间    
参数：毫秒行走时间    
返回值：如果成功，则返回0    
****  
**int dmp_load_android_firmware (void)**    
用图像加载DMP    
返回值：如果成功，则返回0    
****  
```c  
int dmp_read_fifo (short ∗ gyro, short ∗ accel, long ∗ quat, unsigned long ∗ timestamp, short ∗ sensors, unsigned char ∗ more)  
```  
从fifo中获取一个数据包    
传感器可以包含下面的标志的组合    
INV_X_GYRO, INV_Y_GYRO, INV_Z_GYRO    
INV_XYZ_GYRO    
INV_XYZ_ACCEL    
INV_WXYZ_QUAT    
如果FIFO没有数据，则传感器就会是0    
如果FIFO没有使能，该函数会返回一个非0的错误    
参数：    
gyro：硬件单元的陀螺仪数据    
accel：硬件单元的加速度数据    
quat：硬件单元的四元数数据    
timestamp：以毫秒为单位的时间戳    
sensors：上面的标志组合    
more：剩余报文数    
返回值：如果成功，则返回0    
****  
**int dmp_register_android_orient_cb (void(∗)(unsigned char) func)**    
注册一个在android方向事件中执行的函数    
参数：回调函数func    
返回值：如果成功，则返回0    
****  
**int dmp_register_no_motion_cb (void(∗)(void) func)**    
注册一个在无运动事件在执行的函数    
参数：回调函数func    
返回值：如果成功，则返回0    
****  
**int dmp_register_tap_cb (void(∗)(unsigned char, unsigned char) func)**  
注册一个点击时间执行的函数  
点击事件是下面中的一个  
TAP_X_UP  
TAP_X_DOWN  
TAP_Y_UP  
TAP_Y_DOWN  
TAP_Z_UP  
TAP_Z_DOWN  
参数：回调函数func  
返回值：如果成功，则返回0  
****  
**int dmp_set_accel_bias (long ∗ bias)**  
将加速度偏差推到DMP，这些偏差将从DMP六轴四元数中去除  
参数：q16的加速度偏差  
返回值：如果成功，则返回0  
****  
**int dmp_set_gyro_bias (long ∗ bias)**  
将陀螺仪的偏差推到DMP  
因为陀螺仪积分是在DMP中处理的，任何由MPL计算的陀螺仪偏差都应该被推到DMP内存中，以消除三轴四元数漂移  
如果基于DMP的陀螺校准是启用的，DMP将覆盖写入该位置的偏差  
参数：q16的陀螺仪偏差  
返回值：如果成功，则返回0  
****  
**int dmp_set_fifo_rate (unsigned short rate)**  
设置DMP的输出率  
只能在DMP开启的情况下使用  
参数：FIFO的速率  
如果成功，则返回0  
****  
**int dmp_set_interrupt_mode (unsigned char mode)**  
指定应该发生DMP中断的时间  
DMP中断可以配置为在以下两种情况中的任何一种情况下触发  
+ 一个FIFO已经过去  
+ 检测到点击事件  
参数：mode  
DMP_INT_GESTURE  
DMP_INT_CONTINUOUS.  
如果成功，则返回0  
****  
**int dmp_set_no_motion_thresh (unsigned long thresh_mg)**  
设置无运动的阈值  
当每个加速轴上的线性加速度低于此阈值时，DMP检测不到运动  
参数：阈值 q16 in milli-gs  
****  
**int dmp_set_no_motion_time (unsigned short time_ms)**  
设置无运动延迟  
设置多长时间线性加速度低于某值人定为无运动  
参数：ms毫秒  
如果成功，则返回0  
****  
**int dmp_set_orientation (unsigned short orient)**  
将加速度和陀螺仪的方向推入DMP  
这个方向在这里表示为反向方向矩阵到-标量的输出  
参数：陀螺仪和加速度在机身的框架  
如果成功，则返回0  
****  
**int dmp_set_pedometer_step_count (unsigned long count)**  
覆盖当前步数  
这个函数写入DMP内存，如果在计步器启用时调用，可能会遇到竞争条件  
参数：新的步数  
返回值：如果成功，则返回0  
****  
**int dmp_set_pedometer_walk_time (unsigned long time)**  
覆盖当前的行走时间  
这个函数写入DMP内存，如果在计步器启用时调用，可能会遇到竞争条件  
参数：新的行走时间(ms)  
返回值：如果成功，则返回0  
****  
**int dmp_set_shake_reject_thresh (long sf, unsigned short thresh)**  
设置抗震动阈值  
参数：  
sf：陀螺仪刻度因子  
thresh：陀螺仪阈值dps  
返回值：如果成功，则返回0  
****  
**int dmp_set_shake_reject_time (unsigned short time)**  
设置抑制震动时间  
设置陀螺仪必须超出陀螺设置的抖动拒绝脱粒阈值的时间长度，然后丝锥才被拒绝..  
参数：毫秒ms  
返回值：如果成功，则返回0  
****  
**int dmp_set_shake_reject_timeout (unsigned short time)**  
设置抖动抑制超时  
设置抖动抑制后的时间长度，即陀螺仪必须停留在阀值以内，然后才能再次检测到轻拍。  
一个强制性的60毫秒被添加到这个参数  
参数：毫秒(ms)  
返回值：如果成功，则返回0  
****  
**int dmp_set_tap_axes (unsigned char axis)**  
设置哪一个轴会设置成一个tap  
参数：axis x、y、z分别为1、2、4  
返回值：如果成功，则返回0  
****  
**int dmp_set_tap_thresh (unsigned char axis, unsigned short thresh)**  
设置特定轴的点击阈值  
参数：  
axis x,y,z分别为1，2,4  
thresh tap的阈值，mg/ms  
返回值：如果成功，则返回0  
****  
**int dmp_set_tap_time (unsigned short time)**  
设置有效点击之间的时间长度  
参数：毫秒  
返回值：如果成功，则返回0  
****  
**int dmp_set_tap_time_multi (unsigned short time)**  
设置最大时间之间的轻按注册为多轻按  
参数：time 两次点击之间的最大毫秒数  
返回值：如果成功，则返回0  
****  
**int mpu_configure_fifo (unsigned char sensors)**  
选择哪些传感器被推入FIFO  
参数sensors可以是下面这些的组合  
INV_X_GYRO, INV_Y_GYRO, INV_Z_GYRO  
INV_XYZ_GYRO  
INV_XYZ_ACCEL  
参数：sensors 上面的组合  
返回值：如果成功，则返回0  
****  
**int mpu_get_accel_fsr (unsigned char ∗ fsr)**  
将加速度提高到全范围  
参数：fsr 电流满量程  
返回值：如果成功，则返回0  
****  
**int mpu_get_accel_reg (short ∗ data, unsigned long ∗ timestamp)**  
直接从寄存器中读取原始的加速度信息  
参数：  
data 硬件单元中的原始数据  
timestamps 毫秒，不需要则写为NULL  
返回值：如果成功，则返回0  
****  
**int mpu_get_accel_sens (unsigned short ∗ sens)**  
得到加速度灵敏度的比例因子  
参数：sens 从硬件单位到gs的转换  
sens Conversion from hardware units to g’s.  
返回值：如果成功，则返回0  
****  
**int mpu_get_compass_fsr (unsigned short ∗ fsr)**  
把指南针调到全范围  
参数： fsr 目前的全范围  
返回值：如果成功，则返回0  
****  
**int mpu_get_compass_reg (short ∗ data, unsigned long ∗ timestamp)**  
读取原始的指南针的数据  
参数：  
data 硬件单元中的原始数据  
timestamps 毫秒，不需要则写为NULL  
****  
**int mpu_get_compass_sample_rate (unsigned short ∗ rate)**  
获得指南针的采样率  
参数：当前指南针的采样率  
返回值：如果成功，则返回0  
****  
**int mpu_get_dmp_state (unsigned char ∗ enabled)**  
得到DMP的状态  
参数：如果要使能，则1  
返回值：如果成功，则返回0  
****  
**int mpu_get_fifo_config (unsigned char ∗ sensors)**  
获取当前的FIFO配置  
传感器可以包含以下标准的组合  
INV_X_GYRO, INV_Y_GYRO, INV_Z_GYRO  
INV_XYZ_GYRO  
INV_XYZ_ACCEL  
参数：sensors 上面的组合  
返回值：如果成功，则返回0  
****  
**int mpu_get_gyro_fsr (unsigned short ∗ fsr)**  
让陀螺仪达到全范围  
参数：目前的全范围  
返回值：如果成功，则返回0  
****  
**int mpu_get_gyro_reg (short ∗ data, unsigned long ∗ timestamp)**  
从寄存器中读取原始陀螺仪的数据  
参数：  
data 硬件单元中的原始数据  
timestamps 毫秒，不需要则写为NULL  
返回值：如果成功，则返回0  
****  
**int mpu_get_gyro_sens (float ∗ sens)**  
得到陀螺仪灵敏度的比例因子  
参数：sens 从硬件单元到dps的转换  
返回值：如果成功，则返回0  
****  
**int mpu_get_int_status (short ∗ status)**  
读取主控板中断状态寄存器  
参数：中断位掩码  
返回值：如果成功，则返回0  
****  
**int mpu_get_lpf (unsigned short ∗ lpf)**  
获取当前DLPF的设置  
****  
**int mpu_get_power_state (unsigned char ∗ power_on)**  
获取当前功率状态  
参数：power_on 1表示打开、0表示关闭  
返回值：则返回0  
****  
**int mpu_get_sample_rate (unsigned short ∗ rate)**  
获取采样率  
rate：当前的采样率  
返回值：如果成功，则返回0  
****  
**int mpu_get_temperature (long ∗ data, unsigned long ∗ timestamp)**  
直接从寄存器读取温度数据  
参数：  
data q16格式数据  
timestamps 毫秒，不需要则写为NULL  
****  
**int mpu_init (struct int_param_s ∗ int_param)**  
初始化硬件  
初始化配置  
Gyro FSR: +/- 2000DPS  
Accel FSR +/- 2G  
DLPF: 42Hz  
FIFO rate: 50Hz  
Clock source: Gyro PLL  
FIFO: Disabled.  
Data ready interrupt: Disabled, active low, unlatched.  
参数：int_param 用于中断API平台的特定参数  
返回值：如果成功，则返回0  
****  
```c  
int mpu_load_firmware (unsigned short length, const unsigned char ∗firmware, unsigned short start_addr, unsigned short sample_rate)  
```  
加载和验证DMP的图像  
参数:  
+ length 图像的长度  
+ firmware DMP代码  
+ start_addr DMP代码内存的开始位置  
+ sample_rate 当DMP启用时的固定采样率  
返回值：如果成功，则返回0  
****  
**int mpu_lp_accel_mode (unsigned char rate)**  
进入低功率加速度模式  
在低功率加速模式下，芯片进入睡眠状态，只在下列频率之一的加速度计采样时醒来  
MPU6050: 1.25Hz, 5Hz, 20Hz, 40Hz  
MPU6500: 1.25Hz, 2.5Hz, 5Hz, 10Hz, 20Hz, 40Hz, 80Hz, 160Hz, 320Hz, 640Hz  
如果请求的速率不是上面列出的速率，设备将被设置为下一个最高的速率。  
请求超过最大支持频率的速率将导致错误  
参数：rate 最小采样率，或零以禁用LP加速模式  
返回值：如果成功，则返回0  
****  
**int mpu_lp_motion_interrupt (unsigned short thresh, unsigned chartime, unsigned char lpa_freq)**  
进入LP加速运动中断模式  
在MPU6050和MPU6500之间，该特性的行为是非常不同的。每个芯片版本的这一功能说明如下  
MPU6050  
当首次启用此模式时，硬件将捕获单个加速样本，并将随后的样本与此样本进行比较，以确定设备是否处于运动状态。因此，无论何时需要更改这个“锁定”示例，都必须再次调用这个函数  
硬件运动阈值可以在32mg和8160mg之间的32mg增量  
1.25Hz, 5Hz, 20Hz, 40Hz  
MPU6500  
与MPU6050版本不同，硬件没有“锁定”参考样本。硬件监视加速数据，并在短时间内检测任何大的变化  
硬件运动阈值可以在4mg和1020mg之间的4mg增量，MPU6500低功耗加速模式支持以下频率  
1.25Hz, 2.5Hz, 5Hz, 10Hz, 20Hz, 40Hz, 80Hz, 160Hz, 320Hz, 640Hz  
  
如果选择了不支持的阈值，驱动程序将把阈值舍入到最近支持的值  
MPU6500不支持延迟参数。如果MPU6500使用此功能，传递到time的值将被忽略。若要禁用此模式，请将lpa频率设置为零。驱动程序将恢复先前的配置  
  
参数：  
+ thresh 运动阈值(mg)  
+ time 在报告动作之前加速数据必须超过阈值的持续时间(以毫秒为单位)  
+ lpa_freq 最小采样率，或零禁用  
  
返回值：如果成功，则返回0  
  
****  
```c  
int mpu_read_fifo (short ∗ gyro, short ∗ accel, unsigned long ∗timestamp, unsigned char ∗ sensors, unsigned char ∗ more)  
```  
从FIFO中获取一个数据包  
如果传感器不包含特定的传感器，则忽略返回给该指针的数据  
sensors可以是下面的组合  
INV_X_GYRO, INV_Y_GYRO, INV_Z_GYRO  
INV_XYZ_GYRO  
INV_XYZ_ACCEL  
如果FIFO没有新的数据，传感器将为零  
如果FIFO被禁用，传感器将为零，此功能将返回一个非零错误码  
参数：  
+ gyro Gyro data in hardware units.  
+ accel Accel data in hardware units.  
+ timestamp Timestamp in milliseconds.  
+ sensors Mask of sensors read from FIFO.  
+ more Number of remaining packets.  
  
返回值：如果成功，则返回0  
****  
**int mpu_read_fifo_stream (unsigned short length, unsigned char ∗data, unsigned char ∗ more)**  
从FIFO中获得一个未解析的数据包  
如果要在其他地方解析数据包，则应该使用此函数  
参数：  
+ length FIFO数据包的长度  
+ data FIFO数据包  
+ more 剩余报文的数目  
  
返回值：如果成功，则返回0  
****  
**int mpu_read_mem (unsigned short mem_addr, unsigned short length,unsigned char ∗ data)**  
从DMP的内存中读取  
这个函数防止I2C读取超过银行边界。DMP内存只有在芯片唤醒时才可访问  
参数：  
+ mem_addr 内存单元  
+ length 要读取的字节  
+ data 从DMP内存中读取的字节  
  
返回值：如果成功，则返回0  
****  
**int mpu_read_reg (unsigned char reg, unsigned char ∗ data)**  
从单个寄存器中读取  
内存和FIFO读写寄存器不能被访问  
参数：  
+ reg 寄存器地址  
+ data 寄存器数据  
  
返回值：如果成功，则返回0  
****  
**int mpu_reg_dump (void)**  
用于测试的注册转储  
返回值：如果成功，则返回0  
****  
**int mpu_reset_fifo (void)**  
重置FIFO的读写指针  
返回值：如果成功，则返回0  
****  
**int mpu_run_self_test (long ∗ gyro, long ∗ accel)**  
出发陀螺仪、加速度仪、指南针自测  
成功/错误时，自检将返回一个掩码，表示失败的传感器。  
对于每一位，1(1)表示通过  
相反，零(0)表示失败  
掩码的值如下定义  
Bit 0: Gyro.  
Bit 1: Accel.  
Bit 2: Compass.  
目前MPU6500不支持硬件自检。然而，这个函数仍然可以用来获得加速度和陀螺偏差  
这个函数必须在设备正面朝上或正面朝下时调用  
参数：  
+ gyro q16格式陀螺仪偏差  
+ accel q16格式加速度偏差  
  
返回值：如果成功，则返回0  
****  
**int mpu_set_accel_bias (const long ∗ accel_bias)**  
将偏差推入加速度寄存器  
参数：accel_bias  新的偏差  
返回值：如果成功，则返回0  
****  
**int mpu_set_accel_fsr (unsigned char fsr)**  
设置加速度全量程  
参数 fsr 全量程  
返回值：如果成功，则返回0  
****  
**int mpu_set_bypass (unsigned char bypass_on)**  
设置设备为旁路模式  
参数：bypass_on 1来使能  
返回值：如果成功，则返回0  
****  
**int mpu_set_compass_sample_rate (unsigned short rate)**  
设置磁力计的采样率  
从机I2C总线上的磁力计被MPU硬件以最大100Hz的频率读取  
实际速率可以设置为陀螺采样速率的一部  
新的采样率可能与要求的不同。调用mpu_get_compass采样率检查实际设置。  
返回值：如果成功，则返回0  
****  
**int mpu_set_dmp_state (unsigned char enable)**  
启用、禁用DMP的支持  
参数：1来使能DMP  
返回值：如果成功，则返回0  
****  
**int mpu_set_gyro_fsr (unsigned short fsr)**  
设置陀螺仪满量程  
参数：陀螺仪满量程参数  
返回值：如果成功，则返回0  
****  
**int mpu_set_int_latched (unsigned char enable)**  
使能锁中断  
任何的MPU寄存器将清除中断  
参数 1来使能，0来失能  
返回值：如果成功，则返回0  
****  
**int mpu_set_int_level (unsigned char active_low)**  
设置中断优先级  
参数：active_low 1设置最低，0设置最高  
返回值：如果成功，则返回0  
****  
**int mpu_set_lpf (unsigned short lpf)**  
设置数字低通滤波器  
支持以下LPF设置:188、98、42、20、10、5  
参数：lpf 理想的低通滤波器设置  
返回值：如果成功，则返回0  
****  
**int mpu_set_sample_rate (unsigned short rate)**  
设置采样率  
采样率必须在4Hz到1KHz之间  
返回值：如果成功，则返回0  
****  
**int mpu_set_sensors (unsigned char sensors)**  
打开、关闭特定传感器  
传感器可以是以下的组合  
INV_X_GYRO, INV_Y_GYRO, INV_Z_GYRO  
INV_XYZ_GYRO  
INV_XYZ_ACCEL  
INV_XYZ_COMPASS  
参数： sensors 以上传感器的组合  
返回值：如果成功，则返回0  
****  
```c  
int mpu_write_mem (unsigned short mem_addr, unsigned shortlength, unsigned char ∗ data)  
```  
写DMP的内存  
这个函数防止I2C写入超过内存边界。DMP内存只有在芯片唤醒状态下才可访问  
参数  
+ mem_addr 内存地址  
+ length 要写入的字节个数  
+ data 要写入内存的数据  
****  






















