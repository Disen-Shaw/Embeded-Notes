# 临界段
理解章节
原子操作，不可中断
## 简介
临界段代码是一段不可分割的代码
uCOS中包含了很多临界段的代码，如果临界段可能被中断，那么就需要关中断以保护临界段。如果临界段可能被任务级代码打断，那么需要锁调度器保护临界段。

临界段只有在系统调度和外部中断时会被打断在
μC/OS的系统调度，最终也是产生`PendSV中断`，在`PendSV Handler`里面实现任务的切换，所以还是可以归结为中断。既然这样，μC/OS对临界段的保护最终还是回到对中断的开和关的控制

### uCOS临界段
在μC/OS里面，这个临界段最常出现的就是对全局变量的操作
`全局变量就好像是一个枪把子，谁都可以对他开枪，但是我开枪的时候，你就不能开枪，否则就不知道是谁命中了靶子`
μC/OS中定义了一个进入临界段的宏和两个出临界段的宏，用户可以通过这些宏定义进入临界段和退出临界段。
```c
OS_CRITICAL_ENTER()
OS_CRITICAL_EXIT()
OS_CRITICAL_EXIT_NO_SCHED()
// 此外还有一个开中断但是锁定调度器的宏定义
OS_CRITICAL_ENTER_CPU_EXIT()。
```

## Cortex-M内核快速关中断指令
在任务调度提到过的
```asm
CPSID I ;PRIMASK=1	;关中断
CPSIE I ;PRMASK=0	;开中断
CPSID F ;FAULTMASK=1;关异常
COSIE F ;FAULTMASK=0;开异常
```


| 名字      | 功能描述                                                                                                                                                                                                                   |     |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| PRIMASK   | 这是个只有单一比特的寄存器。</br>在它被置1后，就关掉所有可屏蔽的异常，只剩下NMI和硬FAULT可以响应。</br>它的缺省值是0，表示没有关中断。                                                                                     |     |
| FAULTMASK | 这是个只有1个位的寄存器。</br>当它置1时，只有NMI才能响应，所有其他的异常，甚至是硬FAULT，也通通闭嘴。</br>它的缺省值也是0，表示没有关异常。                                                                                |     |
| BASEPRI   | 这个寄存器最多有9位（由表达优先级的位数决定）。</br>它定义了被屏蔽优先级的阈值。</br>当它被设成某个值后，所有优先级号大于等于此值的中断都被关（优先级号越大，优先级越低）</br>但若被设成0，则不关闭任何中断，0也是缺省值。 |     |

## 关中断
μC/OS中关中断的函数在cpu_a.asm中定义，无论上层的宏定义是怎么实现的，底层操作关中断的函数还是CPU_SR_Save()，具体代码如下
```asm
CPU_SR_Save
	MRSR0,	PRIMASK
	CPSID	I
	BX		LR
```
通过MRS指令将特殊寄存器PRIMASK寄存器的值存储到通用寄存器r0。当在C中调用汇编的子程序返回时，会将r0作为函数的返回值。所以在C中调用CPU_SR_Save()的时候，需要事先声明一个变量用来存储CPU_SR_Save()的返回值，即r0寄存器的值，也就是PRIMASK的值	
关闭中断，即使用CPS指令将PRIMASK寄存器的值置1

## 开中断
开中断要与关中断配合使用，μC/OS中开中断的函数在cpu_a.asm中定义，无论上层的宏定义是怎么实现的，底层操作关中断的函数还是CPU_SR_Restore()，具体代码如下
```c
CPU_SR_Restore
	MSR		PRIMASK,	R0
	BX		LR
```
通过MSR指令将通用寄存器r0的值存储到特殊寄存器PRIMASK。当在C中调用汇编的子程序返回时，会将第一个形参传入到通用寄存器r0。所以在C中调用CPU_SR_Restore()的时候，需要传入一个形参，该形参是进入临界段之前保存的PRIMASK的值。

## 临界代码段的应用
进入临界代码段，先把中断关掉，退出临界段时再把中断打开，Cortex-M内核设置了快速关中断的CPS指令
临界段开关中断的函数的实现和临界段代码的保护
```asm
/* 开关中断函数的实现 */
CPU_SR_Restore
	CPSIE 	I
	BX		LR

/* void CPU_SR_Restore(void); */
CPU_SR_Restore
	CPSIE	I
	BX		LR
PRIMASK = 0 		/* PRIMASK初始值为0,表示没有关中断 */

/* 临界段代码保护 */
{
	/* 临界段代码保护 */
	CPU_SR_Save();		/* 关中断 */
	{
		/* 执行代码段代码，不可中断 */
	}
	/* 临界段结束 */
	CPU_SR_Restore(); /* 开中断，PRIMASK = 0 */
}
```
关中断直接使用了CPSID I，没有跟代码清单:临界段-2一样事先将PRIMASK的值保存在r0中
开中断直接使用了CPSIE I，而不是像代码清单:临界段-3那样从传进来的形参来恢复PRIMASK的值。
假设PRIMASK初始值为0，表示没有关中断
临界段开始，调用关中断函数CPU_SR_Save()，此时PRIMASK的值等于1，确实中断已经关闭。
执行临界段代码，不可中断
临界段结束，调用开中断函数CPU_SR_Restore()，此时PRIMASK的值等于0，确实中断已经开启。


临界段开关中断的函数的实现和嵌套临界段代码的保护
```asm
; void CPU_SR_Save();
CPU_SR_Save
	MRS		R0,		PRIMASK
	CPSID	I
	BX		LR

; void CPU_SR_Restore(void)
CPU_SR_Restore
	MSR		PRIMASK,R0
	BX		LR
PRIMASK = 0 ;		/* PRIMASK初始值为0,表示没有关中断 */

CPU_SR	cpu_sr1 = (CPU_SR)0
CPU_SR	cpu_sr2 = (CPU_SR)0

/* 临界段代码 */
{
	cpu_sr1 = CPU_SR_Save();	/* 关中断，cpu_sr1 = 0,PRIMASK = 1 */
	{
		/* 临界段2 */
		cpu_sr2=CPU_SR_Save();	/* 关中断,cpu_sr2 = 1,PRIMASK = 1*/
		{
		}
		CPU_SR_Restore(cpu_sr2); 
	}
	/* 临界段1结束 */
	CPU_SR_Restore(cpu_sr1);/*开中断,cpu_sr1=0,PRIMASK=0*/
}
```
假设PRIMASK初始值为0,表示没有关中断
定义两个变量，留着后面用
临界段1开始，调用关中断函数CPU_SR_Save()，CPU_SR_Save()函数先将PRIMASK的值存储在通用寄存器r0，一开始我们假设PRIMASK的值等于0，所以此时r0的值即为0。然后执行汇编指令CPSIDI关闭中断，即设置PRIMASK等于1，在返回的时候r0当做函数的返回值存储在cpu_sr1，所以cpu_sr1等于r0等于0
临界段2开始，调用关中断函数CPU_SR_Save()，CPU_SR_Save()函数先将PRIMASK的值存储在通用寄存器r0，临界段1开始的时候我们关闭了中断，即设置PRIMASK等于1，所以此时r0的值等于1。然后执行汇编指令CPSIDI关闭中断，即设置PRIMASK等于1，在返回的时候r0当做函数的返回值存储在cpu_sr2，所以cpu_sr2等于r0等于1
临界段2结束，调用开中断函数CPU_SR_Restore(cpu_sr2)，cpu_sr2作为函数的形参传入到通用寄存器r0，然后执行汇编指令MSR r0, PRIMASK恢复PRIMASK的值。此时PRIAMSK = r0 = cpu_sr2 =1。关键点来了，为什么临界段2结束了，PRIMASK还是等于1，按道理应该是等于0。因为此时临界段2是嵌套在临界段1中的，还是没有完全离开临界段的范畴，所以不能把中断打开，如果临界段是没有嵌套的，使用当前的开关中断的方法的话，那么PRIMASK确实是等于1

**开关中断的函数的实现和一重临界段代码的保护**
```asm
; 开关中断函数的实现
; void CPU_SR_Save();
CPU_SR_Save
	MSR		R0,PRIMASK
	CPSID	I
	BX		LR

; void CPU_SR_Restore(void)
CPU_SR_Restore
	MSR		PRIMASK,	R0
	BX		LR

PRIMASK = 0 ; 			/* PRIMASK 初始值为0,表示没有关中断 */

CPU_SR	cpu_sr1 = (CPU_SR)0
/* 临界段代码 */
{
	/* 临界段开始 */
	cpu_sr1 = CPU_SR_Save();
	{
	}
	/* 临界段结束 */
	CPU_SR_Restore(cpu_sr1);	/* 开中断，cpu_sr1=0,PRIMASK=0 */
}
```

## 测量关中断时间
uCOS提供了测量关中断时间的功能，通过设置cpu_Cfg.h中的宏定义CPU_CFG_INT_DIS_MEAS_EN为1标志启用该功能

系统会在每次关中断前开始测量，开中断后结束测量，测量功能保存了2个方面的测量值，总的关中断时间与最近一次关中断的时间。因此，用户可以根据得到的关中断时间对其加以优化。时间戳的速率决定于CPU的速率。
如果CPU速率为72MHz，时间戳的速率就为72MHz，那么时间戳的分辨率为1/72M微秒，大约为13.8纳秒（ns）系统测出的关中断时间还包括了测量时消耗的额外时间，那么测量得到的时间减掉测量时所耗时间就是实际上的关中断时间。关中断时间跟处理器的指令、速度、内存访问速度有很大的关系

### 测量关中断时间初始化
关中断之前要用函数CPU_IntDisMeasInit()函数进行初始化，可以直接调用函数CPU_Init()函数进行初始化
如下代码，临界段`CPU_IntDisMeasInit()`
```c
#ifdef CPU_CFG_INT_DIS_MEAS_EN
static void CPU_IntDisMeasInit(void){
	CPU_TS_TMR time_meas_tot_cnts;
	CPU_INT16U i;
	CPU_SR_ALLOC();
	
	CPU_IntDisMeasCtr = 0u;
	CPU_IntDisNestCtr = 0u;
	CPU_IntDisMeasStart_cnts = 0u;
	CPU_IntDisMeasStop_cnts = 0u;
	CPU_IntDisMeasMaxCur_cnts = 0u;
	CPU_IntDisMeasMax_cnts = 0u;
	CPU_IntDisMeasOvrhd_cnts = 0u;

	time_meas_tot_cnts = 0u;
	CPU_INT_DIS();				/* 关中断 */
	for( i = 0u; i < CPU_CFG_INT_DIS_MEAS_OVRHD_NBR ; i++){
		CPU_IntDisMeasMaxCur_cnts=0u;
		CPU_IntDisMeasStart(); /*执行多个连续的开始/停止时间测量*/
		CPU_IntDisMeasStop();
		time_meas_tot_cnts += CPU_IntDisMeasMaxCur_cnts; /*计算总的时间*/
	}
	CPU_IntDisMeasOvrhd_cnts=(time_meas_tot_cnts +(CPU_CFG_INT_DIS_MEAS_OVRHD_NBR / 2u))/CPU_CFG_INT_DIS_MEAS_OVRHD_NBR;
	
	/* 得到平均值，就是每一次测量额外消耗的时间 */
	CPU_IntDisMeasMaxCur_cnts = 0u;
	CPU_IntDisMeasMax_cnts = 0u;
	CPU_INT_EN();
}
#endif
```
因为关中断测量本身也会耗费一定的时间，这些时间实际是加入到我们测量到的最大关中断时间里面，如果能够计算出这段时间，后面计算的时候将其减去可以得到更加准确的结果。这段代码的核心思想很简单，就是重复多次开始测量与停止测量，然后多次之后，取得平均值，那么这个值就可以看作一次开始测量与停止测量的时间，保存在CPU_IntDisMeasOvrhd_cnts变量中

### 测量最大关中断时间
如果用户启用了CPU_CFG_INT_DIS_MEAS_EN这个宏定义，那么系统在关中断的时候会调用了开始测量关中断最大时间的函数CPU_IntDisMeasStart()，开中断的时候调用停止测量关中断最大时间的函数CPU_IntDisMeasStop()
只要在关中断且嵌套层数OSSched-LockNestingCtr为0的时候保存下时间戳，如果嵌套层数不为0，肯定不是刚刚进入中断，退出中断且嵌套层数为0的时候，这个时候才算是真正的退出中断，把测得的时间戳减去一次测量额外消耗的时间，便得到这次关中断的时间，再将这个时间跟历史保存下的最大的关中断的时间对比，刷新最大的关中断时间
代码具体如下：
```c
/* 开始测量关中断时间 */
#ifdef CPU_CFG_INT_DIS_MEAS_EN
void CPU_IntDisMeasStart(void){
	CPU_IntDisMeasCtr++;
	if(CPU_IntDisNestCtr==0u)		/* 嵌套层数为0 */
	{
		CPU_IntDisMeasStart_cnts=CPU_TS_TmrRd();	/*保存时间戳*/
	}
	CPU_IntDisNestCtr++;
}
#endif

/* 停止测量关中断时间 */
void CPU_IntDisMeasStop(void){
	CPU_TS_TMR time_ints_disd_cnts;
	CPU_IntDisNestCtr--;
	if(CPU_IntDisNestCtr==0u)						/* 嵌套层数为0 */
	{
		CPU_IntDisMeasStop_cnts=CPU_TS_TmrRd();		/* 保存时间戳 */
		
		time_ints_disd_cnts=CPU_IntDisMeasStop_cnts-25CPU_IntDisMeasStart_cnts; /* 得到关中断时间 */
		if(CPU_IntDisMeasMaxCur_cnts < time_ints_disd_cnts){
			CPU_IntDisMeasMaxCur_cnts = time_ints_disd_cnts;
		}
		if(CPU_IntDisMeasMax_cnts<time_ints_disd_cnts){
			CPU_IntDisMeasMax_cnts=time_ints_disd_cnts;
		}
	}
}
#endif
```

### 获取最大关中断时间
现在得到了关中断时间，μC/OS也提供了三个与获取关中断时间有关的函数，分别是
```c
CPU_IntDisMeasMaxCurReset()
CPU_IntDisMeasMaxCurGet()
CPU_IntDisMeasMaxGet()
```
如果想直接获取整个陈旭运行过程中最大的关中断时间的话，直接调用函数`CPU_IntDisMeasMaxGet()`获取即可。
如果想要测量某段程序执行的最大关中断时间，那么在这段程序的前面调用`CPU_IntDisMeasMaxCurReset()`函数将`CPU_IntDisMeasMaxCur_cnts`变量清0，在这段程序结束的时候调用函数`CPU_IntDisMeasMaxCurGet()`即可。

具体代码如下
```c
#ifdef CPU_CFG_INT_DIS_MEAS_EN   				//如果启用了关中断时间测量
CPU_TS_TMRCPU_IntDisMeasMaxCurGet(void)  		//获取测量的程序段的最大关中断时间
{
	CPU_TS_TMR time_tot_cnts;
	CPU_TS_TMR time_max_cnts;
	
	CPU_SR_ALLOC();								
	// 使用到临界段（在关/开中断时）时必须用到该宏，该宏声明和
	// 定义一个局部变量，用于保存关中断前的CPU状态寄存器
	// SR（临界段关中断只需保存SR），开中断时将该值还原。
	CPU_INT_DIS();								// 关中断
	time_tot_cnts=CPU_IntDisMeasMaxCur_cnts;
	// 获取为处理的出鞥虚段最大关中断时间
	CPU_INT_EN();
	//开中断
	time_max_cnts = CPU_IntDisMeasMaxCalc(time_tot_cnts);
	// 获取减去测量时间后的最大关中断时间
	return(time_max_cnts); 						// 返回程序段的最大关中断时间
}
#endif

#ifdef CPU_CFG_INT_DIS_MEAS_EN					//如果启用了关中断时间测量
CPU_TS_TMR CPU_IntDisMeasMaxGet(void)
// 获取整个程序目前最大的关中断时间
{
	CPU_TS_TMR time_tot_cnts;
	CPU_TS_TMR time_max_cnts;
	CPU_SR_ALLOC();
	// 使用到临界段（在关/开中断时）时必须用到该宏，该宏声明和
	// 定义一个局部变量，用于保存关中断前的CPU状态寄存器
	// SR（临界段关中断只需保存SR），开中断时将该值还原。
	CPU_INT_DIS();
	time_tot_cnts=CPU_IntDisMeasMax_cnts;
	// 获取尚未处理的最大关中断时间
	CPU_INT_EN();
	time_max_cnts=CPU_IntDisMeasMaxCalc(time_tot_cnts);
	// 获取减去测量时间后的最大关中断时间
	return (time_max_cnts);						// 返回目前最大关中断时间
}
#endif

#ifdef CPU_CFG_INT_DIS_MEAS_EN					//如果启用了关中断时间测量
CPU_TS_TMRCPU_IntDisMeasMaxCurReset(void)
// 初始化（复位）测量程序段的最大关中断时间
{
	CPU_TS_TMR time_max_cnts;
	CPU_SR_ALLOC();
	// 使用到临界段（在关/开中断时）时必须用到该宏，该宏声明和定义一个局部变量，用于保存关中断前的CPU状态寄存器
	// SR（临界段关中断只需保存SR），开中断时将该值还原
	time_max_cnts=CPU_IntDisMeasMaxCurGet();	// 获取复位前的程序段最大关中断时间
	CPU_INT_DIS();								// 关中断
	CPU_IntDisMeasMaxCur_cnts=0u;				//清零程序段的最大关中断时间
	CPU_INT_EN();								//开中断
	return(time_max_cnts);						//返回复位前的程序段最大关中断时间
}
#endif
```

