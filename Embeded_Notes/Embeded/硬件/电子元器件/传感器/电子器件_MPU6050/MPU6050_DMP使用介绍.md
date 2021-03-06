# MPU6050 DMP的使用介绍
## DMP介绍
通过代码可以正常读取MPU6050的加速度传感器、陀螺仪传感器和温度传感器的数据，但是实际使用的时候，需要得到姿态数据  
欧拉角：行向角、横滚角、俯仰角  
要得到欧拉角的数据，就要用原始数据进行姿态融合解算，比较复杂，并且耗费MCU的资源  
MPU6050自带了数组运动处理器——DMP  
并且InvenSense提供了一个MPU6050的嵌入式运动驱动库，结合MPU6050的DMP，可以将原始数据直接转化为四元数，而得到四元数之后就可以很方便的计算出欧拉角  

使用内部的DMP，可以大大简化代码设计，MCU不用进行姿态结算的过程，降低MCU的负担，从而有时间去处理其他的东西，提高系统的实时性  

InvenSense提供的MPU6050运动库是基于MSP430的，需要将其一直一下才可以用到STM32上  
官方DMP驱动库移植主要实现下面四个函数  

```c
i2c_write
i2c_read
delay_ms
get_ms
```
需要移植那六个文件  

MPU6050 DMP输出的是姿态解算后的四元数，采用q30格式，也就是放大了2的30次方  
要得到欧拉角，就要转换一下  
![Pasted image 20210525123722](../../../../../pictures/Pasted%20image%2020210525123722.png)

quat\[0]~quat\[3]:MPU6050的DMP解算后的四元数，q30格式  
q30：常量：1073741824,即2的30次方  
57.3：弧度转换为角度，即180/π，这样结果就是以度为单位的  

## DMP移植
[MPU6050_DMP姿态解算](MPU6050_DMP姿态解算.md)

### DMP移植相关代码
`在inv_mpu.c中`  
i2c_write  
i2c_read  
delay_ms `Systemtick相关的一个代码`  
get_ms `空函数`  

### mpu_dmp_init()函数

### mpu_dmp_get_data()函数
获取四元数








