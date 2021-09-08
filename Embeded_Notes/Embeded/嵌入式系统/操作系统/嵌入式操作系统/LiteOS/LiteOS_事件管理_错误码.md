# LiteOS错误码
<table>
<thead align="left"><tr id="row2830196712737"><th class="cellrowborder" id="mcps1.1.6.1.1" width="5.45%" valign="top"><p id="p2971281012737"><a name="p2971281012737"></a><a name="p2971281012737"></a>序号</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.2" width="21.990000000000002%" valign="top"><p id="p5792739612737"><a name="p5792739612737"></a><a name="p5792739612737"></a>定义</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.3" width="12.879999999999999%" valign="top"><p id="p6160751912737"><a name="p6160751912737"></a><a name="p6160751912737"></a>实际值</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.4" width="30.78%" valign="top"><p id="p2415315512737"><a name="p2415315512737"></a><a name="p2415315512737"></a>描述</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.5" width="28.9%" valign="top"><p id="p1024850212737"><a name="p1024850212737"></a><a name="p1024850212737"></a>参考解决方案</p>
</th>
</tr>
</thead>
<tbody><tr id="row35955500121027"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.45%" valign="top"><p id="p26714373121027"><a name="p26714373121027"></a><a name="p26714373121027"></a>1</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.990000000000002%" valign="top"><p id="p16380603121027"><a name="p16380603121027"></a><a name="p16380603121027"></a>LOS_ERRNO_EVENT_SETBIT_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.879999999999999%" valign="top"><p id="p12580778121054"><a name="p12580778121054"></a><a name="p12580778121054"></a>0x02001c00</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="30.78%" valign="top"><p id="p31845851121027"><a name="p31845851121027"></a><a name="p31845851121027"></a>写事件时，将事件ID的第25个bit设置为1。这个比特位OS内部保留，不允许设置为1</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="28.9%" valign="top"><p id="p29377175121027"><a name="p29377175121027"></a><a name="p29377175121027"></a>事件ID的第25bit置为0</p>
</td>
</tr>
<tr id="row2512766212737"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.45%" valign="top"><p id="p2207475012737"><a name="p2207475012737"></a><a name="p2207475012737"></a>2</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.990000000000002%" valign="top"><p id="p4322430612737"><a name="p4322430612737"></a><a name="p4322430612737"></a>LOS_ERRNO_EVENT_READ_TIMEOUT</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.879999999999999%" valign="top"><p id="p1150789112737"><a name="p1150789112737"></a><a name="p1150789112737"></a>0x02001c01</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="30.78%" valign="top"><p id="p5972394412737"><a name="p5972394412737"></a><a name="p5972394412737"></a>读事件超时</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="28.9%" valign="top"><p id="p580127312737"><a name="p580127312737"></a><a name="p580127312737"></a>增加等待时间或者重新读取</p>
</td>
</tr>
<tr id="row5221146412737"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.45%" valign="top"><p id="p127022412737"><a name="p127022412737"></a><a name="p127022412737"></a>3</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.990000000000002%" valign="top"><p id="p3577930412737"><a name="p3577930412737"></a><a name="p3577930412737"></a>LOS_ERRNO_EVENT_EVENTMASK_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.879999999999999%" valign="top"><p id="p1244248812737"><a name="p1244248812737"></a><a name="p1244248812737"></a>0x02001c02</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="30.78%" valign="top"><p id="p120861712737"><a name="p120861712737"></a><a name="p120861712737"></a>入参的事件ID是无效的</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="28.9%" valign="top"><p id="p3078915412737"><a name="p3078915412737"></a><a name="p3078915412737"></a>传入有效的事件ID参数</p>
</td>
</tr>
<tr id="row866693812737"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.45%" valign="top"><p id="p3093336312737"><a name="p3093336312737"></a><a name="p3093336312737"></a>4</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.990000000000002%" valign="top"><p id="p2257447312737"><a name="p2257447312737"></a><a name="p2257447312737"></a>LOS_ERRNO_EVENT_READ_IN_INTERRUPT</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.879999999999999%" valign="top"><p id="p1659299512737"><a name="p1659299512737"></a><a name="p1659299512737"></a>0x02001c03</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="30.78%" valign="top"><p id="p185533712737"><a name="p185533712737"></a><a name="p185533712737"></a>在中断中读取事件</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="28.9%" valign="top"><p id="p1606464512737"><a name="p1606464512737"></a><a name="p1606464512737"></a>启动新的任务来获取事件</p>
</td>
</tr>
<tr id="row1036407712737"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.45%" valign="top"><p id="p3418393812737"><a name="p3418393812737"></a><a name="p3418393812737"></a>5</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.990000000000002%" valign="top"><p id="p1743561612737"><a name="p1743561612737"></a><a name="p1743561612737"></a>LOS_ERRNO_EVENT_FLAGS_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.879999999999999%" valign="top"><p id="p299876612737"><a name="p299876612737"></a><a name="p299876612737"></a>0x02001c04</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="30.78%" valign="top"><p id="p4157346012737"><a name="p4157346012737"></a><a name="p4157346012737"></a>读取事件的mode无效</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="28.9%" valign="top"><p id="p1200709912737"><a name="p1200709912737"></a><a name="p1200709912737"></a>传入有效的mode参数</p>
</td>
</tr>
<tr id="row4095503012737"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.45%" valign="top"><p id="p2902313712737"><a name="p2902313712737"></a><a name="p2902313712737"></a>6</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.990000000000002%" valign="top"><p id="p206387212737"><a name="p206387212737"></a><a name="p206387212737"></a>LOS_ERRNO_EVENT_READ_IN_LOCK</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.879999999999999%" valign="top"><p id="p3295593212737"><a name="p3295593212737"></a><a name="p3295593212737"></a>0x02001c05</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="30.78%" valign="top"><p id="p5218479612737"><a name="p5218479612737"></a><a name="p5218479612737"></a>任务锁住，不能读取事件</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="28.9%" valign="top"><p id="p6621892012737"><a name="p6621892012737"></a><a name="p6621892012737"></a>解锁任务，再读取事件</p>
</td>
</tr>
<tr id="row3924015812752"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.45%" valign="top"><p id="p2433626212752"><a name="p2433626212752"></a><a name="p2433626212752"></a>7</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.990000000000002%" valign="top"><p id="p2508019012752"><a name="p2508019012752"></a><a name="p2508019012752"></a>LOS_ERRNO_EVENT_PTR_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.879999999999999%" valign="top"><p id="p1822948612752"><a name="p1822948612752"></a><a name="p1822948612752"></a>0x02001c06</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="30.78%" valign="top"><p id="p19340712752"><a name="p19340712752"></a><a name="p19340712752"></a>传入的参数为空指针</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="28.9%" valign="top"><p id="p1566600812752"><a name="p1566600812752"></a><a name="p1566600812752"></a>传入非空入参</p>
</td>
</tr>
<tr id="row1451135712910"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.45%" valign="top"><p id="p35145711295"><a name="p35145711295"></a><a name="p35145711295"></a>8</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.990000000000002%" valign="top"><p id="p1916535613425"><a name="p1916535613425"></a><a name="p1916535613425"></a>LOS_ERRNO_EVENT_READ_IN_SYSTEM_TASK</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.879999999999999%" valign="top"><p id="p175155713292"><a name="p175155713292"></a><a name="p175155713292"></a>0x02001c07</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="30.78%" valign="top"><p id="p195117571299"><a name="p195117571299"></a><a name="p195117571299"></a>在系统任务中读取事件，如idle和软件定时器</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="28.9%" valign="top"><p id="p55155711292"><a name="p55155711292"></a><a name="p55155711292"></a>启动新的任务来获取事件</p>
</td>
</tr>
<tr id="row1787264972819"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.45%" valign="top"><p id="p11872249152818"><a name="p11872249152818"></a><a name="p11872249152818"></a>9</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.990000000000002%" valign="top"><p id="p15873849132813"><a name="p15873849132813"></a><a name="p15873849132813"></a>LOS_ERRNO_EVENT_SHOULD_NOT_DESTORY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="12.879999999999999%" valign="top"><p id="p1387374910289"><a name="p1387374910289"></a><a name="p1387374910289"></a>0x02001c08</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="30.78%" valign="top"><p id="p1987324952817"><a name="p1987324952817"></a><a name="p1987324952817"></a>事件链表上仍有任务，无法被销毁</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="28.9%" valign="top"><p id="p187310492283"><a name="p187310492283"></a><a name="p187310492283"></a>先检查事件链表是否为空</p>
</td>
</tr>
</tbody>
</table>

错误码可能会实时更新，网络版本应参考 [LiteOS内核开发者手册](https://gitee.com/LiteOS/LiteOS/blob/master/doc/LiteOS_Kernel_Developer_Guide.md)