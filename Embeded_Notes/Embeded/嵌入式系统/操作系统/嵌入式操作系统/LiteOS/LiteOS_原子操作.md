# LiteOS 原子操作
## 基本概念
在支持多任务的操作系统中，修改一块内存区域的数据需要“读取-修改-写入”三个步骤  
然而同一内存区域的数据可能同时被多个任务访问，如果在修改数据的过程中被其他任务打断，就会造成该操作的执行结果无法预知

使用开关中断的方法固然可以保证多任务执行结果符合预期，但这种方法显然会影响系统性能

ARMv6架构引入了LDREX和STREX指令，以支持对共享存储器更缜密的非阻塞同步。由此实现的原子操作能确保对同一数据的“读取-修改-写入”操作在它的执行期间不会被打断，即操作的原子性

### 运作机制
ARMv6架构引入了 `LDREX` 和 `STREX` 进行封装，向用户提供一套原子接口
-   **LDREX Rx, [Ry]**
    
    读取内存中的值，并标记对该段内存为独占访问：
    
    -   读取寄存器Ry指向的4字节内存数据，保存到Rx寄存器中。
    -   对Ry指向的内存区域添加独占访问标记。
-   **STREX Rf, Rx, [Ry]**
    
    检查内存是否有独占访问标记，如果有则更新内存值并清空标记，否则不更新内存：
    
    -   有独占访问标记
        
        1.  将寄存器Rx中的值更新到寄存器Ry指向的内存。
        2.  标志寄存器Rf置为0。
    -   没有独占访问标记
        
        1.  不更新内存。
        2.  标志寄存器Rf置为1。
-   **判断标志寄存器**
    
    -   标志寄存器为0时，退出循环，原子操作结束。
    -   标志寄存器为1时，继续循环，重新进行原子操作。

## APIs
Atomic原子操作
<table>
<thead align="left"><tr id="row1872972720811"><th class="cellrowborder" id="mcps1.2.4.1.1" width="17.588241175882413%" valign="top"><p id="p2197741720811"><a name="p2197741720811"></a><a name="p2197741720811"></a>功能分类</p>
</th>
<th class="cellrowborder" id="mcps1.2.4.1.2" width="22.827717228277173%" valign="top"><p id="p1280752020811"><a name="p1280752020811"></a><a name="p1280752020811"></a>接口名</p>
</th>
<th class="cellrowborder" id="mcps1.2.4.1.3" width="59.58404159584042%" valign="top"><p id="p3595409320811"><a name="p3595409320811"></a><a name="p3595409320811"></a>描述</p>
</th>
</tr>
</thead>
<tbody><tr id="row8821422144017"><td class="cellrowborder" headers="mcps1.2.4.1.1 " width="17.588241175882413%" valign="top"><p id="p1082116226408"><a name="p1082116226408"></a><a name="p1082116226408"></a>读</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " width="22.827717228277173%" valign="top"><p id="p118211822134019"><a name="p118211822134019"></a><a name="p118211822134019"></a>LOS_AtomicRead</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.3 " width="59.58404159584042%" valign="top"><p id="p3821172210403"><a name="p3821172210403"></a><a name="p3821172210403"></a>读取内存数据</p>
</td>
</tr>
<tr id="row12907201494015"><td class="cellrowborder" headers="mcps1.2.4.1.1 " width="17.588241175882413%" valign="top"><p id="p1790851494014"><a name="p1790851494014"></a><a name="p1790851494014"></a>写</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " width="22.827717228277173%" valign="top"><p id="p79081214184016"><a name="p79081214184016"></a><a name="p79081214184016"></a>LOS_AtomicSet</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.3 " width="59.58404159584042%" valign="top"><p id="p1908314114017"><a name="p1908314114017"></a><a name="p1908314114017"></a>写入内存数据</p>
</td>
</tr>
<tr id="row3711131920811"><td class="cellrowborder" rowspan="4" headers="mcps1.2.4.1.1 " width="17.588241175882413%" valign="top"><p id="p1464320720811"><a name="p1464320720811"></a><a name="p1464320720811"></a>加</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " width="22.827717228277173%" valign="top"><p id="p5788323720811"><a name="p5788323720811"></a><a name="p5788323720811"></a>LOS_AtomicAdd</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.3 " width="59.58404159584042%" valign="top"><p id="p6073589620811"><a name="p6073589620811"></a><a name="p6073589620811"></a>对内存数据做加法</p>
</td>
</tr>
<tr id="row15982181955512"><td class="cellrowborder" headers="mcps1.2.4.1.1 " valign="top"><p id="p159821019205512"><a name="p159821019205512"></a><a name="p159821019205512"></a>LOS_AtomicSub</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " valign="top"><p id="p189821319125516"><a name="p189821319125516"></a><a name="p189821319125516"></a>对内存数据做减法</p>
</td>
</tr>
<tr id="row3156887520811"><td class="cellrowborder" headers="mcps1.2.4.1.1 " valign="top"><p id="p6009666520811"><a name="p6009666520811"></a><a name="p6009666520811"></a>LOS_AtomicInc</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " valign="top"><p id="p6683076820811"><a name="p6683076820811"></a><a name="p6683076820811"></a>对内存数据加1</p>
</td>
</tr>
<tr id="row152478191611"><td class="cellrowborder" headers="mcps1.2.4.1.1 " valign="top"><p id="p487389551611"><a name="p487389551611"></a><a name="p487389551611"></a>LOS_AtomicIncRet</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " valign="top"><p id="p4737212173750"><a name="p4737212173750"></a><a name="p4737212173750"></a>对内存数据加1并返回运算结果</p>
</td>
</tr>
<tr id="row551826141617"><td class="cellrowborder" rowspan="2" headers="mcps1.2.4.1.1 " width="17.588241175882413%" valign="top"><p id="p1025291220215"><a name="p1025291220215"></a><a name="p1025291220215"></a>减</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " width="22.827717228277173%" valign="top"><p id="p8139021617"><a name="p8139021617"></a><a name="p8139021617"></a>LOS_AtomicDec</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.3 " width="59.58404159584042%" valign="top"><p id="p659261051617"><a name="p659261051617"></a><a name="p659261051617"></a>对内存数据减1</p>
</td>
</tr>
<tr id="row5082721316112"><td class="cellrowborder" headers="mcps1.2.4.1.1 " valign="top"><p id="p1340185216112"><a name="p1340185216112"></a><a name="p1340185216112"></a>LOS_AtomicDecRet</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " valign="top"><p id="p1180824516112"><a name="p1180824516112"></a><a name="p1180824516112"></a>对内存数据减1并返回运算结果</p>
</td>
</tr>
<tr id="row11187400233110"><td class="cellrowborder" rowspan="2" headers="mcps1.2.4.1.1 " width="17.588241175882413%" valign="top"><p id="p1353275352817"><a name="p1353275352817"></a><a name="p1353275352817"></a>交换</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " width="22.827717228277173%" valign="top"><p id="p50546033233110"><a name="p50546033233110"></a><a name="p50546033233110"></a>LOS_AtomicXchg32bits</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.3 " width="59.58404159584042%" valign="top"><p id="p588031233110"><a name="p588031233110"></a><a name="p588031233110"></a>交换内存数据，原内存中的值以返回值的方式返回</p>
</td>
</tr>
<tr id="row4980729516444"><td class="cellrowborder" headers="mcps1.2.4.1.1 " valign="top"><p id="p3260399916444"><a name="p3260399916444"></a><a name="p3260399916444"></a>LOS_AtomicCmpXchg32bits</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " valign="top"><p id="p2367825216444"><a name="p2367825216444"></a><a name="p2367825216444"></a>比较并交换内存数据，返回比较结果</p>
</td>
</tr>
</tbody>
</table>

Atomic64原子操作
<table>
	<thead align="left"><tr id="row11459105325613"><th class="cellrowborder" id="mcps1.2.4.1.1" width="17.488251174882514%" valign="top"><p id="p15459185355610"><a name="p15459185355610"></a><a name="p15459185355610"></a>功能分类</p>
</th>
<th class="cellrowborder" id="mcps1.2.4.1.2" width="22.927707229277072%" valign="top"><p id="p44591453115611"><a name="p44591453115611"></a><a name="p44591453115611"></a>接口名</p>
</th>
<th class="cellrowborder" id="mcps1.2.4.1.3" width="59.58404159584042%" valign="top"><p id="p24591253165610"><a name="p24591253165610"></a><a name="p24591253165610"></a>描述</p>
</th>
</tr>
</thead>
<tbody><tr id="row184591853145610"><td class="cellrowborder" headers="mcps1.2.4.1.1 " width="17.488251174882514%" valign="top"><p id="p17459195315612"><a name="p17459195315612"></a><a name="p17459195315612"></a>读</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " width="22.927707229277072%" valign="top"><p id="p134591653155613"><a name="p134591653155613"></a><a name="p134591653155613"></a>LOS_Atomic64Read</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.3 " width="59.58404159584042%" valign="top"><p id="p545915531560"><a name="p545915531560"></a><a name="p545915531560"></a>读取64位内存数据</p>
</td>
</tr>
<tr id="row2459195325618"><td class="cellrowborder" headers="mcps1.2.4.1.1 " width="17.488251174882514%" valign="top"><p id="p44592053105614"><a name="p44592053105614"></a><a name="p44592053105614"></a>写</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " width="22.927707229277072%" valign="top"><p id="p594319452578"><a name="p594319452578"></a><a name="p594319452578"></a>LOS_Atomic64Set</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.3 " width="59.58404159584042%" valign="top"><p id="p14596533569"><a name="p14596533569"></a><a name="p14596533569"></a>写入64位内存数据</p>
</td>
</tr>
<tr id="row8459195313562"><td class="cellrowborder" rowspan="4" headers="mcps1.2.4.1.1 " width="17.488251174882514%" valign="top"><p id="p1459753145613"><a name="p1459753145613"></a><a name="p1459753145613"></a>加</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " width="22.927707229277072%" valign="top"><p id="p134591253195618"><a name="p134591253195618"></a><a name="p134591253195618"></a>LOS_Atomic64Add</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.3 " width="59.58404159584042%" valign="top"><p id="p5459165318568"><a name="p5459165318568"></a><a name="p5459165318568"></a>对64位内存数据做加法</p>
</td>
</tr>
<tr id="row345965325611"><td class="cellrowborder" headers="mcps1.2.4.1.1 " valign="top"><p id="p17459753165610"><a name="p17459753165610"></a><a name="p17459753165610"></a>LOS_Atomic64Sub</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " valign="top"><p id="p194591053165610"><a name="p194591053165610"></a><a name="p194591053165610"></a>对64位内存数据做减法</p>
</td>
</tr>
<tr id="row144591153135611"><td class="cellrowborder" headers="mcps1.2.4.1.1 " valign="top"><p id="p2459125317562"><a name="p2459125317562"></a><a name="p2459125317562"></a>LOS_Atomic64Inc</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " valign="top"><p id="p04591153165619"><a name="p04591153165619"></a><a name="p04591153165619"></a>对64位内存数据加1</p>
</td>
</tr>
<tr id="row114591653145617"><td class="cellrowborder" headers="mcps1.2.4.1.1 " valign="top"><p id="p645955317563"><a name="p645955317563"></a><a name="p645955317563"></a>LOS_Atomic64IncRet</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " valign="top"><p id="p16459953185614"><a name="p16459953185614"></a><a name="p16459953185614"></a>对64位内存数据加1并返回运算结果</p>
</td>
</tr>
<tr id="row745995310561"><td class="cellrowborder" rowspan="2" headers="mcps1.2.4.1.1 " width="17.488251174882514%" valign="top"><p id="p1645935315612"><a name="p1645935315612"></a><a name="p1645935315612"></a>减</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " width="22.927707229277072%" valign="top"><p id="p1045955365615"><a name="p1045955365615"></a><a name="p1045955365615"></a>LOS_Atomic64Dec</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.3 " width="59.58404159584042%" valign="top"><p id="p84596533569"><a name="p84596533569"></a><a name="p84596533569"></a>对64位内存数据减1</p>
</td>
</tr>
<tr id="row18459195365617"><td class="cellrowborder" headers="mcps1.2.4.1.1 " valign="top"><p id="p645975315561"><a name="p645975315561"></a><a name="p645975315561"></a>LOS_Atomic64DecRet</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " valign="top"><p id="p124599539568"><a name="p124599539568"></a><a name="p124599539568"></a>对64位内存数据减1并返回运算结果</p>
</td>
</tr>
<tr id="row1645905355610"><td class="cellrowborder" rowspan="2" headers="mcps1.2.4.1.1 " width="17.488251174882514%" valign="top"><p id="p945914530567"><a name="p945914530567"></a><a name="p945914530567"></a>交换</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " width="22.927707229277072%" valign="top"><p id="p194915482214"><a name="p194915482214"></a><a name="p194915482214"></a>LOS_AtomicXchg64bits</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.3 " width="59.58404159584042%" valign="top"><p id="p13459175315562"><a name="p13459175315562"></a><a name="p13459175315562"></a>交换64位内存数据，原内存中的值以返回值的方式返回</p>
</td>
</tr>
<tr id="row17459115345618"><td class="cellrowborder" headers="mcps1.2.4.1.1 " valign="top"><p id="p10459195312568"><a name="p10459195312568"></a><a name="p10459195312568"></a>LOS_AtomicCmpXchg64bits</p>
</td>
<td class="cellrowborder" headers="mcps1.2.4.1.2 " valign="top"><p id="p1445925315614"><a name="p1445925315614"></a><a name="p1445925315614"></a>比较并交换64位内存数据，返回比较结果</p>
</td>
</tr>
</tbody>
</table>

> 该功能无平台差异性

## 注意事项
目前原子操作只支持整型数据


