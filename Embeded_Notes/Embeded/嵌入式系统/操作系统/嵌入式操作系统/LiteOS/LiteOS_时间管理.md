# LiteOS 时间管理
## 基本概念
时间管理以系统时钟为基础，给应用程序提供所有和时间有关的服务

系统时钟是由定时器/计数器产生的输出脉冲触发中断产生的，一般定义为整数或长整数。输出脉冲的周期叫做一个“时钟滴答”。系统时钟也称为时标或者Tick

用户以秒、毫秒为单位计时，而操作系统以Tick为单位计时，当用户需要对系统进行操作时，例如任务挂起、延时等，此时需要时间管理模块对Tick和秒/毫秒进行转换

`Huawei LiteOS` 的时间管理模块提供时间转换、统计、延迟功能

## 相关概念
+ Cycle
	+ 系统最小的计时单位
	+ Cycle的时常主要由系统时钟频率所决定，系统主时钟频率就是谜面中Cycle数
+ Tick
	+ Tick是操作系统的基本时间单位，由用户配置的每秒Tick数决定


## 开发
### 使用场景
用户需要了解当前系统运行的时间以及Tick与秒、毫秒之间的转换关系等

### APIs
<table>
	<thead align="left"><tr id="row6547625614853"><th class="cellrowborder" id="mcps1.1.4.1.1" width="17.07%" valign="top"><p id="p197652314853"><a name="p197652314853"></a><a name="p197652314853"></a>功能分类</p>
</th>
<th class="cellrowborder" id="mcps1.1.4.1.2" width="18.68%" valign="top"><p id="p3159926114853"><a name="p3159926114853"></a><a name="p3159926114853"></a>接口名</p>
</th>
<th class="cellrowborder" id="mcps1.1.4.1.3" width="64.25%" valign="top"><p id="p1752099814853"><a name="p1752099814853"></a><a name="p1752099814853"></a>描述</p>
</th>
</tr>
</thead>
<tbody><tr id="row37761567115936"><td class="cellrowborder" rowspan="2" headers="mcps1.1.4.1.1 " width="17.07%" valign="top"><p id="p66321365112810"><a name="p66321365112810"></a><a name="p66321365112810"></a>时间转换</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="18.68%" valign="top"><p id="p38788111115936"><a name="p38788111115936"></a><a name="p38788111115936"></a>LOS_MS2Tick</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="64.25%" valign="top"><p id="p54829304115936"><a name="p54829304115936"></a><a name="p54829304115936"></a>毫秒转换成Tick</p>
</td>
</tr>
<tr id="row2021456214853"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p2676682114853"><a name="p2676682114853"></a><a name="p2676682114853"></a>LOS_Tick2MS</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p2062890114853"><a name="p2062890114853"></a><a name="p2062890114853"></a>Tick转化为毫秒</p>
</td>
</tr>
<tr id="row4646930012230"><td class="cellrowborder" rowspan="4" headers="mcps1.1.4.1.1 " width="17.07%" valign="top"><p id="p54265225145715"><a name="p54265225145715"></a><a name="p54265225145715"></a>时间统计</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="18.68%" valign="top"><p id="p951174812230"><a name="p951174812230"></a><a name="p951174812230"></a>LOS_CyclePerTickGet</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="64.25%" valign="top"><p id="p3225415312230"><a name="p3225415312230"></a><a name="p3225415312230"></a>每个Tick多少Cycle数</p>
</td>
</tr>
<tr id="row5082319714571"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p33407133145715"><a name="p33407133145715"></a><a name="p33407133145715"></a>LOS_TickCountGet</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p21623253145715"><a name="p21623253145715"></a><a name="p21623253145715"></a>获取自系统启动以来的Tick数</p>
</td>
</tr>
<tr id="row155873165506"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p16587171610509"><a name="p16587171610509"></a><a name="p16587171610509"></a>LOS_GetCpuCycle</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p1758741635020"><a name="p1758741635020"></a><a name="p1758741635020"></a>获取自系统启动以来的Cycle数</p>
</td>
</tr>
<tr id="row01423075018"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p15146306504"><a name="p15146306504"></a><a name="p15146306504"></a>LOS_CurrNanosec</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p1314173035019"><a name="p1314173035019"></a><a name="p1314173035019"></a>获取自系统启动以来的纳秒数</p>
</td>
</tr>
<tr id="row39991813135113"><td class="cellrowborder" rowspan="2" headers="mcps1.1.4.1.1 " width="17.07%" valign="top"><p id="p164791723145114"><a name="p164791723145114"></a><a name="p164791723145114"></a>延时管理</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="18.68%" valign="top"><p id="p12999113115113"><a name="p12999113115113"></a><a name="p12999113115113"></a>LOS_Udelay</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="64.25%" valign="top"><p id="p7999111315513"><a name="p7999111315513"></a><a name="p7999111315513"></a>以us为单位的忙等，但可以被优先级更高的任务抢占</p>
</td>
</tr>
<tr id="row1195310175513"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p12953417125120"><a name="p12953417125120"></a><a name="p12953417125120"></a>LOS_Mdelay</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p1195351765110"><a name="p1195351765110"></a><a name="p1195351765110"></a>以ms为单位的忙等，但可以被优先级更高的任务抢占</p>
</td>
</tr>
</tbody>
</table>

### 时间管理错误码
| 定义                             | 实际数值   | 描述               | 参考解决方案                                                                                                           |
| -------------------------------- | ---------- | ------------------ | ---------------------------------------------------------------------------------------------------------------------- |
| LOS_ERRNO_TICK_CFG_INVALID       | 0x02000400 | 无效的系统Tick配置 | 在板级配置适配时配置有效的系统主时钟频率OS_SYS_CLOCK</br>通过make menuconfig配置有效的LOSCFG_BASE_CORE_TICK_PER_SECOND |
| LOS_ERRNO_TICK_NO_HWTIMER        | 0x02000401 | 暂不使用           |                                                                                                                        |
| LOS_ERRNO_TICK_PER_SEC_TOO_SMALL | 0x02000402 | 暂不使用           |                                                                                                                        |

## 开发流程

根据实际需求，在板级配置适配时确认是否使能 `LOSCFG_BASE_CORE_TICK_HW_TIME` 宏选择外部定时器，并配置系统主时钟频率 `OS_SYS_CLOCK`  
`OS_SYS_CLOCK` 的默认值基于硬件平台配置

通过 `make menuconfig` 配置 `LOSCFG_BASE_CORE_TICK_PER_SECOND`  
菜单路径为：Kernel —> Basic Config —> Task

| 配置项                           | 含义       | 取值范围  | 默认值 | 依赖 |
| -------------------------------- | ---------- | --------- | ------ | ---- |
| LOSCFG_BASE_CORE_TICK_PER_SECOND | 每秒Tick数 | (0, 1000] | 100    | 无   | 

然后调用时钟转换/统计接口

## 注意事项
时间管理不是单独的功能模块，依赖于

+ OS_SYS_CLOCK
+ LOSCFG_BASE_CORE_TICK_PER_SECOND

两个配置选项

系统的Tick数在关中断的情况下不进行计数，故系统Tick数不能作为准确时间使用。
