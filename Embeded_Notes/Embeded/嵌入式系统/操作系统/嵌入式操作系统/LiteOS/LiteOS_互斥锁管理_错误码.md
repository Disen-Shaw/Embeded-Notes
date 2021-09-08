# LiteOS 互斥锁 错误码
<table>
	<thead align="left"><tr id="row30398401185440"><th class="cellrowborder" id="mcps1.1.6.1.1" width="6.18%" valign="top"><p id="p14509506185440"><a name="p14509506185440"></a><a name="p14509506185440"></a>序号</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.2" width="21.05%" valign="top"><p id="p34419344185440"><a name="p34419344185440"></a><a name="p34419344185440"></a>定义</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.3" width="12.25%" valign="top"><p id="p36503519185440"><a name="p36503519185440"></a><a name="p36503519185440"></a>实际数值</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.4" width="27.02%" valign="top"><p id="p3995095185440"><a name="p3995095185440"></a><a name="p3995095185440"></a>描述</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.5" width="33.5%" valign="top"><p id="p55167263185440"><a name="p55167263185440"></a><a name="p55167263185440"></a>参考解决方案</p>
</th>
</tr>
</thead>
<tbody><tr id="row26743320185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p18725340185440"><a name="p18725340185440"></a><a name="p18725340185440"></a>1</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p40357572185440"><a name="p40357572185440"></a><a name="p40357572185440"></a>LOS_ERRNO_MUX_NO_MEMORY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p47737913185440"><a name="p47737913185440"></a><a name="p47737913185440"></a>0x02001d00</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p41565730185440"><a name="p41565730185440"></a><a name="p41565730185440"></a>初始化互斥锁模块时，内存不足</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p829261710818"><a name="p829261710818"></a><a name="p829261710818"></a>设置更大的系统动态内存池，配置项为OS_SYS_MEM_SIZE，或减少系统支持的最大互斥锁个数</p>
</td>
</tr>
<tr id="row35319849185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p42335492185440"><a name="p42335492185440"></a><a name="p42335492185440"></a>2</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p6622832185440"><a name="p6622832185440"></a><a name="p6622832185440"></a>LOS_ERRNO_MUX_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p66687380185440"><a name="p66687380185440"></a><a name="p66687380185440"></a>0x02001d01</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p32968729185440"><a name="p32968729185440"></a><a name="p32968729185440"></a>互斥锁不可用</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p53221415185440"><a name="p53221415185440"></a><a name="p53221415185440"></a>传入有效的互斥锁ID</p>
</td>
</tr>
<tr id="row9230688185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p9488269185440"><a name="p9488269185440"></a><a name="p9488269185440"></a>3</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p30352343185440"><a name="p30352343185440"></a><a name="p30352343185440"></a>LOS_ERRNO_MUX_PTR_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p42620709185440"><a name="p42620709185440"></a><a name="p42620709185440"></a>0x02001d02</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p29725408185440"><a name="p29725408185440"></a><a name="p29725408185440"></a>创建互斥锁时，入参为空指针</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p58947823185440"><a name="p58947823185440"></a><a name="p58947823185440"></a>传入有效指针</p>
</td>
</tr>
<tr id="row60768362185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p23290259185440"><a name="p23290259185440"></a><a name="p23290259185440"></a>4</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p7462788185440"><a name="p7462788185440"></a><a name="p7462788185440"></a>LOS_ERRNO_MUX_ALL_BUSY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p506086185440"><a name="p506086185440"></a><a name="p506086185440"></a>0x02001d03</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p40992992185440"><a name="p40992992185440"></a><a name="p40992992185440"></a>创建互斥锁时，系统中已经没有可用的互斥锁</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p32098075185440"><a name="p32098075185440"></a><a name="p32098075185440"></a>增加系统支持的最大互斥锁个数</p>
</td>
</tr>
<tr id="row20447224185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p45612471185440"><a name="p45612471185440"></a><a name="p45612471185440"></a>5</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p3622666185440"><a name="p3622666185440"></a><a name="p3622666185440"></a>LOS_ERRNO_MUX_UNAVAILABLE</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p25000538185440"><a name="p25000538185440"></a><a name="p25000538185440"></a>0x02001d04</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p11777678185440"><a name="p11777678185440"></a><a name="p11777678185440"></a>申请互斥锁失败，因为锁已经被其他线程持有</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p14467855185440"><a name="p14467855185440"></a><a name="p14467855185440"></a>等待其他线程解锁或者设置等待时间</p>
</td>
</tr>
<tr id="row63101831185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p10974693185440"><a name="p10974693185440"></a><a name="p10974693185440"></a>6</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p16534980185440"><a name="p16534980185440"></a><a name="p16534980185440"></a>LOS_ERRNO_MUX_PEND_INTERR</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p64265036185440"><a name="p64265036185440"></a><a name="p64265036185440"></a>0x02001d05</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p38085412185440"><a name="p38085412185440"></a><a name="p38085412185440"></a>在中断中使用互斥锁</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p65019508185440"><a name="p65019508185440"></a><a name="p65019508185440"></a>禁止在中断中申请/释放互斥锁</p>
</td>
</tr>
<tr id="row48304665185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p20363793185440"><a name="p20363793185440"></a><a name="p20363793185440"></a>7</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p38854550185440"><a name="p38854550185440"></a><a name="p38854550185440"></a>LOS_ERRNO_MUX_PEND_IN_LOCK</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p60210831185440"><a name="p60210831185440"></a><a name="p60210831185440"></a>0x02001d06</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p45239141185440"><a name="p45239141185440"></a><a name="p45239141185440"></a>锁任务调度时，不允许以阻塞模式申请互斥锁</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p40491775185440"><a name="p40491775185440"></a><a name="p40491775185440"></a>以非阻塞模式申请互斥锁，或使能任务调度后再阻塞申请互斥锁</p>
</td>
</tr>
<tr id="row28881657185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p57712885185440"><a name="p57712885185440"></a><a name="p57712885185440"></a>8</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p44232105185440"><a name="p44232105185440"></a><a name="p44232105185440"></a>LOS_ERRNO_MUX_TIMEOUT</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p26030782185440"><a name="p26030782185440"></a><a name="p26030782185440"></a>0x02001d07</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p28118620185440"><a name="p28118620185440"></a><a name="p28118620185440"></a>申请互斥锁超时</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p63015722185440"><a name="p63015722185440"></a><a name="p63015722185440"></a>增加等待时间，或采用一直等待模式</p>
</td>
</tr>
<tr id="row30270586185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p35998420185440"><a name="p35998420185440"></a><a name="p35998420185440"></a>9</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p30190898185440"><a name="p30190898185440"></a><a name="p30190898185440"></a>LOS_ERRNO_MUX_OVERFLOW</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p29543677185440"><a name="p29543677185440"></a><a name="p29543677185440"></a>0x02001d08</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p5187305519220"><a name="p5187305519220"></a><a name="p5187305519220"></a>暂不使用该错误码</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p25666808185440"><a name="p25666808185440"></a><a name="p25666808185440"></a>-</p>
</td>
</tr>
<tr id="row29674680185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p54838841185440"><a name="p54838841185440"></a><a name="p54838841185440"></a>10</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p12761131185440"><a name="p12761131185440"></a><a name="p12761131185440"></a>LOS_ERRNO_MUX_PENDED</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p27018677185440"><a name="p27018677185440"></a><a name="p27018677185440"></a>0x02001d09</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p41029248185440"><a name="p41029248185440"></a><a name="p41029248185440"></a>删除正在使用的互斥锁锁</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p35034804185440"><a name="p35034804185440"></a><a name="p35034804185440"></a>等待解锁后再删除该互斥锁</p>
</td>
</tr>
<tr id="row46877780185440"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p39003831185440"><a name="p39003831185440"></a><a name="p39003831185440"></a>11</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p5193751185440"><a name="p5193751185440"></a><a name="p5193751185440"></a>LOS_ERRNO_MUX_GET_COUNT_ERR</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p18040667185440"><a name="p18040667185440"></a><a name="p18040667185440"></a>0x02001d0a</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p902268419229"><a name="p902268419229"></a><a name="p902268419229"></a>暂不使用该错误码</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p51891633185440"><a name="p51891633185440"></a><a name="p51891633185440"></a>-</p>
</td>
</tr>
<tr id="row41674524185752"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p20193313185752"><a name="p20193313185752"></a><a name="p20193313185752"></a>12</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p25045679185752"><a name="p25045679185752"></a><a name="p25045679185752"></a>LOS_ERRNO_MUX_REG_ERROR</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p15434093185752"><a name="p15434093185752"></a><a name="p15434093185752"></a>0x02001d0b</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p42201987185752"><a name="p42201987185752"></a><a name="p42201987185752"></a>暂不使用该错误码</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p62917786185752"><a name="p62917786185752"></a><a name="p62917786185752"></a>-</p>
</td>
</tr>
<tr id="row16448413194410"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="6.18%" valign="top"><p id="p4448121364413"><a name="p4448121364413"></a><a name="p4448121364413"></a>13</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.05%" valign="top"><p id="p64488131440"><a name="p64488131440"></a><a name="p64488131440"></a>LOS_ERRNO_MUX_PEND_IN_SYSTEM_TASK</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.25%" valign="top"><p id="p12448613144412"><a name="p12448613144412"></a><a name="p12448613144412"></a>0x02001d0c</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.02%" valign="top"><p id="p18448141317446"><a name="p18448141317446"></a><a name="p18448141317446"></a>系统任务中获取互斥锁，如idle和软件定时器</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.5%" valign="top"><p id="p244816137442"><a name="p244816137442"></a><a name="p244816137442"></a>不在系统任务中申请互斥锁</p>
</td>
</tr>
</tbody>

</table>

