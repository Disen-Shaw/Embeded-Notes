# 就绪列表
在uCOS中，任务创建后，任务的TCB会被放入到就绪列表中，表示任务在就绪，随时可能被运行
就绪列表包含一个表示任务优先级的优先级表，一个存储任务的TCB的TCB双向链表

## 优先级表
优先级表在代码层面上来看，就是一个数组，在文件os_prio.c的开头定义，具体如下
**优先级表**
```c
CPU_DATA OSPrioTbl[OS_PRIO_TBL_SIZE];(
```
CPU_DATA为32位整型。数组的大小由宏`OS_PRIO_TBL_SIZE`控制。
`OS_PRIO_TBL_SIZE`的具体取值与μC/OS-III支持多少个优先级有关，支持的优先级越多，优先级表也就越大，需要的RAM空间也就越多。`理论上理论上μC/OS-III支持无限的优先级，只要RAM控制足够`
宏OS_PRIO_TBL_SIZE在os.h文件定义，具体如下：
**宏OS_PRO_TBL_SIZE**
```c
#define OS_PRIO_TBL_SIZE((OS_CFG_PRIO_MAX - 1u)/(DEF_INT_CPU_NBR_BITS) + 1u)
```
OS_CFG_PRIO_MAX表示支持多少个优先级，在os_cfg.h定义
DEF_INT_CPU_NBR_BITS定义CPU整型数据有多少位，基于Cortex-M系列的MCU，宏展开为32位

此时经过OS_CFG_PRIO_MAX和DEF_INT_CPU_NBR_BITS这两个宏展开运算之后，可得出OS_PRIO_TBL_SIZE的值为1，即优先级表只需要一个成员即可表示32个优先级
如果要支持64个优先级，即需要两个成员，以此类推。如果MCU的类型是16位、8位或者64位，只需要把优先级表的数据类型CPU_DATA改成相应的位数即可。

![[Pasted image 20210707172112.png]]

优先级表中，优先级表的成员是32位的，每个成员可以表示32个优先级。如果优先级超过32个，那么优先级表的成员就要相应的增加
CPU的类型为32位，支持最大的优先级为32个，优先级表只需要一个成员即可，即只有`OSPrioTbl\[0]`。假如创建一个优先级为Prio的任务，那么就在OSPrioTbl\[0]的位\[31-prio]置1即可。如果Prio等于3，那么就将位28置1。OSPrioTbl\[0]的位31表示的是优先级最高的任务，以此递减，直到OSPrioTbl\[OS_PRIO_TBL_SIZE-1]]的位0，OSPrioTbl\[OS_PRIO_TBL_SIZE-1]]的位0表示的是最低的优先级。

### 优先级表函数讲解
优先级表相关的函数在os_prio.c文件中实现，在os.h文件中声明

| 函数名称          | 函数作用               |
| ----------------- | ---------------------- |
| OS_PrioInit       | 初始化优先级表         |
| OS_PrioInsert     | 设置优先级表中相应的位 |
| OS_PrioRemove     | 清除优先级表中相应的位 |
| OS_PrioGetHighest | 查找最高的优先级       |

#### OS_PrioInit()函数
用于初始化优先级列表，在OSInit()函数中被调用，具体实现如下
```c
void OS_PrioInit(void)
{
	CPU_DATA i;
	/* 默认全部初始化为0 */
	for( i=0u ; i < OS_PRIO_TBL_SIZE ; i++){
		OSPrioTbl[i] = (CPU_DATA)0;
	}
}
```
优先级表OS_PrioTbl[]只有一个成员，即OS_PRIO_TBL_SIZE等于1经过初始化之后，具体是优先级表初始化后的示意图
![[Pasted image 20210707173028.png]]


#### OS_PrioInsert()函数
OS_PrioInsert()函数用于置位优先级表中相应的位，会被OSTaskCreate()函数调用
具体如下：
```c
void OS_PrioInsert(OS_PRIO prio){
	CPU_DATA bit;
	CPU_DATA bit_nbr;
	OS_PRIO ix;
	
	/* 求模操作，获取优先级表数组的下标索引 */
	ix = prio/DEF_INT_CPU_NBR_BITS;
	
	/* 求余操作，将优先级限制在DEF_INT_CPU_NBR_BITS之内 */
	bit_nbr = (CPU_DATA)prio&(DEF_INT_CPU_NBR_BITS-1u);
	
	/*获取优先级在优先级表中对应的位的位置*/
	bit=1u;
	bit<<=(DEF_INT_CPU_NBR_BITS-1u)-bit_nbr;
	
	/* 将优先级在优先级表中对应的位置1 */
	OSPrioTbl[ix] |= bit;
}
```

**在μC/OS-III中，最高优先级和最低优先级是留给系统任务使用的，用户任务不能使用。**

#### OS_PrioRemove()函数
OS_PrioRemove()函数用于清除优先级表中相应的位，与OS_PrioInsert()函数的作用刚好相反
```c
void OS_PrioRemove(OS_PRIO prio){
	CPU_DATA 	bit;
	CPU_DATA 	bit_nbr;
	OS_PRIO 	ix;
	
	/* 求模操作，获取优先级表数组的下标索引 */
	ix = prio/DEF_INT_CPU_NBR_BITS;
	
	/* 求余操作，将优先级限制在DEF_INT_CPU_NBR_BITS之内 */
	bit_nbr = (CPU_DATA)prio&(DEF_INT_CPU_NBR_BITS-1u);
	
	/* 获取优先级在优先级表中对应的位的位置 */
	bit=1u;
	bit<<=(DEF_INT_CPU_NBR_BITS-1u)-bit_nbr;
	
	/* 将优先级在优先级表中对应的位清零 */
	OSPrioTbl[ix] &= ~bit;
}
```


#### OS_PrioGetHighest()函数
OS_PrioGetHighest()函数用于从优先级表中查找最高的优先级
```c
OS_PRIO OS_PrioGetHighest(void)
{
	CPU_DATA*p_tbl;
	OS_PRIO prio;
	
	prio = (OS_PRIO)0;
	/* 获取优先级表首地址 */
	p_tbl=&OSPrioTbl[0];
	
	/* 找到数值不为0的数组成员 */
	while(*p_tbl == (CPU_DATA)0){
		prio += DEF_INT_CPU_NBR_BITS;
		p_tbl++;
	}
	/*找到优先级表中置位的最高的优先级*/
	prio+=(OS_PRIO)CPU_CntLeadZeros(*p_tbl);
	return (prio);
}
```
获取优先级表的首地址，从头开始搜索整个优先级表，直到找到最高的优先级。
找到优先级表中数值不为0的数组成员，只要不为0就表示该成员里面至少有一个位是置位的，在图优先级表的优先级表中，优先级按照从左到右，从上到下依次减小，左上角为最高的优先级，右下角为最低的优先级，所以我们只需要找到第一个不是0的优先级表成员即可。
确定好优先级表中第一个不为0的成员后，然后再找出该成员中第一个置1的位（从高位到低位开始找）就算找到最高优先级。在一个变量中，按照从高位到低位的顺序查找第一个置1的位的方法是通过计算前导0函数CPU_CntLeadZeros()来实现的。从高位开始找1叫计算前导0，从低位开始找1叫计算后导0。如果分别创建了优先级3、5、8和11这四个任务，任务创建成功后，优先级表的设置情况具体见图创建优先级3_5_8和11后优先级表的设置情况。调用CPU_CntLeadZeros()可以计算出OSPrioTbl\[0]第一个置1的位前面有3个0，那么这个3就是我们要查找的最高优先级，至于后面还有多少个位置1我们都不用管，只需要找到第一个1即可。

![[Pasted image 20210707174130.png]]

CPU_CntLeadZeros()函数可由汇编或者C来实现，如果使用的处理器支持前导零指令CLZ，可由汇编来实现，加快指令运算，如果不支持则由C来实现。在μC/OS-III中，这两种实现方法均有提供代码，到底使用哪种方法由CPU_CFG_LEAD_ZEROS_ASM_PRESEN这个宏来控制，定义了这个宏则使用汇编来实现，没有定义则使用C来实现。
Cortex-M系列处理器自带CLZ指令，所以CPU_CntLeadZeros()函数默认由汇编编写，具体在cpu_a.asm文件实现，在cpu.h文件声明，具体如下
```c
; *******************************************************************
; PUBLIC FUNCTIONS
; *******************************************************************
EXPORT 	CPU_CntLeadZeros
EXPORT 	CPU_CntTrailZeros
; *******************************************************************
; 计算前导0函数
;
; 描述
; 
; 函数声明：CPU_DATA CPU_CntLeadZeros(CPU_DATA val);
;
; *******************************************************************

CPU_CntLeadZeros
	CLZ 	R0, R0										; Count leading zeros
	BX		LR

; *******************************************************************
; 计算后导0函数
; 描述
; 函数声明 CPU_DATA CPU_CntTrailZeros(CPU_DATA val);
;
; *******************************************************************

CPU_CntTrailZeros
	RBIT 	R0, R0										; Reverse bits
	CLZR0, 	R0											; Count trailing zeros
	BX 		LR
```

```c
/*
 *******************************************************************
 * 函数声明
 * cpu.h文件
*/

#define CPU_CFG_LEAD_ZEROS_ASM_PRESEN
CPU_DATA CPU_CntLeadZeros(CPU_DATA val); 				/* 在cpu_a.asm定义 */
CPU_DATA CPU_CntTrailZeros(CPU_DATA val);				/* 在cpu_a.asm定义 */

```
如果处理器不支持前导0指令，CPU_CntLeadZeros()函数就得由C编写，具体在cpu_core.c文件实现，在cpu.h文件声明，具体如下
```c
#ifndef CPU_CFG_LEAD_ZEROS_ASM_PRESENT
CPU_DATACPU_CntLeadZeros(CPU_DATA val)
{
	CPU_DATA 	nbr_lead_zeros;
	CPU_INT08U 	ix;
	
	/* 检查高16位 */	。。。。。。。。。。。。。。。。1
	if(val>0x0000FFFFu) {
		/* 检查bits [31:24] */
		if(val>0x00FFFFFFu) {。。。。。。。。。。。。。。。。2

		/*获取bits [31:24]的值，并转换成8位*/
		ix=(CPU_INT08U)(val>>24u);	。。。。。。。。。。。。。。。。3

		/*查表找到优先级*/
		nbr_lead_zeros=(CPU_DATA)(CPU_CntLeadZerosTbl[ix]+0u);	。。。。。。。。。。。。。。。。4
	}else{
		/* 获取bits [23:16]的值，并转换成8位 */
		ix = (CPU_INT08U)(val>>16u);
		/* 查表找到优先级 */
		nbr_lead_zeros=(CPU_DATA )(CPU_CntLeadZerosTbl[ix]+8u);
	}
	else{
		/*检查bits [15:08] */
		if(val>0x000000FFu) {
			/*获取bits [15:08]的值，并转换成8位*/
			ix = (CPU_INT08U)(val>>8u);
			/*查表找到优先级*/
			nbr_lead_zeros=(CPU_DATA )(CPU_CntLeadZerosTbl[ix]+16u);
		}
		else{
			/* 获取bits [15:08]的值，并转换成8位 */
			ix = (CPU_INT08U)(val>>0u);
			/* 查表找到优先级 */
			nbr_lead_zeros = (CPU_DATA)(CPU_CntLeadZerosTbl[ix]+24u);
		}
	}
	/* 返回优先级 */
	return(nbr_lead_zeros);
}
#endif
```
1：分离出高16位，else则为低16位。
2：分离出高16位的高8位，else则为高16位的低8位。
3：将高16位的高8位通过移位强制转化为8位的变量，用于后面的查表操作。
4：将8位的变量ix作为数组`CPU_CntLeadZerosTbl[]`的索引，返回索引对应的值，那么该值就是8位变量ix对应的前导0，然后再加上（24-右移的位数）就等于优先级数组CPU_CntLeadZerosTbl[]在cpu_core.c定义
**CPU_CntLeadZerosTbl\[]**
```c
#ifndef CPU_CFG_LEAD_ZEROS_ASM_PRESENT
static const CPU_INT08U CPU_CntLeadZerosTbl[256]={
	/* 索引 */
	8u,7u,6u,6u,5u,5u,5u,5u,4u,4u,4u,4u,4u,4u,4u,4u,/* 0x00 to 0x0F */
	3u,3u,3u,3u,3u,3u,3u,3u,3u,3u,3u,3u,3u,3u,3u,3u,/* 0x10 to 0x1F */
	2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,/* 0x20 to 0x2F */
	2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,2u,/* 0x30 to 0x3F */
	1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,/* 0x40 to 0x4F */
	1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,/* 0x50 to 0x5F */
	1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,/* 0x60 to 0x6F */
	1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,1u,/* 0x70 to 0x7F */
	0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,/* 0x80 to 0x8F */
	0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,/* 0x90 to 0x9F */
	0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,/* 0xA0 to 0xAF */
	0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,/* 0xB0 to 0xBF */
	0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,/* 0xC0 to 0xCF */
	0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,/* 0xD0 to 0xDF */
	0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,/* 0xE0 to 0xEF */
	0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u,0u /* 0xF0 to 0xFF */
};
#endif
```
对一个32位的变量算前导0个数的时候都是分离成8位的变量来计算，然后将这个8位的变量作为数组CPU_CntLeadZerosTbl[]的索引，索引下对应的值就是这个8位变量的前导0个数。一个8位的变量的取值范围为0~0XFF，这些值作为数组CPU_CntLeadZerosTbl[]的索引，每一个值的前导0个数都预先算出来作为该数组索引下的值。通过查CPU_CntLeadZerosTbl[]这个表就可以很快的知道一个8位变量的前导0个数，根本不用计算，只是浪费了定义CPU_CntLeadZerosTbl[]这个表的一点点空间而已，在处理器内存很充足的情况下，则优先选择这种空间换时间的方法。

## 就绪列表
准备好运行的任务的TCB都会被放到就绪列表中，系统可随时调度任务运行
就绪列表在代码的层面上看就是一个OS_RDY_LIST数据类型的数组OSRdyList[]
数组的大小由宏OS_CFG_PRIO_MAX决定，支持多少个优先级，OSRdyList[]就有多少个成员。任务的优先级与OSRdyList[]的索引一一对应，比如优先级3的任务的TCB会被放到OSRdyList\[3]中
OSRdyList[]是一个在os.h文件中定义的全局变量，代码如下：
```c
OS_EXT OS_RDY_LIST OSRdyList[OS_CFG_PRIO_MAX];
```
OS_RDY_LIST在os.h中定义，专用于就绪列表如下：
```c
typedef struct os_rdy_listOS_RDY_LIST;
struct os_rdy_list{
	OS_TCB *HeadPtr;
	OS_TCB *TailPtr;
	OS_OBJ_QTY NbrEntries;
};
```
就绪列表相关函数

| 函数名称                 | 函数作用                      |
| ------------------------ | ----------------------------- |
| OS_RdyListInit           | 初始化就绪列表为空            |
| OS_RdyListInsert         | 插入一个TCB到就绪列表         |
| OS_RdyListInsertHead     | 插入一个TCB到就绪列表的头部   |
| OS_RdyListInsertTail     | 插入一个TCB到就绪列表的尾部   |
| OS_RdyListMoveHeadToTail | 将TCB从就绪列表的头部移到尾部 |
| OS_RdyListRemove         | 从就绪列表中移除              |



