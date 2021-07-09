# PID C语言实现
## PID结构体
```c
typedef struct PID{
	float P;					// 参数
	float I;
	float D;
	float Error;				// 比例项
	float Interal;				// 积分项
	float Differ;				// 微分项
	float PreError;				// 上一次误差
	float Ilimit;				// 积分分离
	float Irang;				// 积分限幅
	uint8_t Ilimit_flag;		// 积分分离标志
	float Pout;					// 比例项输出
	float Iout;					// 积分项输出
	float Dout;					// 微分项输出
	float OutPut;				// 总输出
}PID_Type;
```
### 位置式PID控制器的c语言实现
```c
void PID_Position_Cal(PID_Type *PID,float target,float measure){
	//int dt = 0;					// 采样时间
	PID->Error = target - measure;	// 误差
	PID->Differ = PID->Error - PID->PreError;	// 微分量
	PID->Integral += PID->Error;	// 对误差进行积分
	if(PID->Integral > PID->Irang)	// 积分限幅
		PID->Integral = PID->Irang;	
	if(PID->Integral > PID->Irang)
		PID->Integral = -PID->-Irang;
	
	PID->Pout = PID->P * PID->Error;	// 比例控制输出
	PID->Iout = PID->I * PID->Integral;	// 积分控制输出
	PID->Dout = PID->D * PID->Differ;	// 微分控制输出
	
	PID->OutPut = PID->Pout + PID->Iout + PID->Dout;
	
	PID->PreError = PID->Error;		// 钱一个误差值
}
```


