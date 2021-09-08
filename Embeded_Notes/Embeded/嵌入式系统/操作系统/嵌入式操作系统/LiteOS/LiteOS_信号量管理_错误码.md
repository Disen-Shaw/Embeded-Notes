# LiteOS 信号量管理 错误码
<table>
<thead align="left"><tr id="row2267197395642"><th class="cellrowborder" id="mcps1.1.6.1.1" width="5.65%" valign="top"><p id="p1908783195642"><a name="p1908783195642"></a><a name="p1908783195642"></a>序号</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.2" width="21.15%" valign="top"><p id="p261046995642"><a name="p261046995642"></a><a name="p261046995642"></a>定义</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.3" width="13.089999999999998%" valign="top"><p id="p1012144095642"><a name="p1012144095642"></a><a name="p1012144095642"></a>实际数值</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.4" width="26.91%" valign="top"><p id="p1453028795642"><a name="p1453028795642"></a><a name="p1453028795642"></a>描述</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.5" width="33.2%" valign="top"><p id="p2753561710026"><a name="p2753561710026"></a><a name="p2753561710026"></a>参考解决方案</p>
</th>
</tr>
</thead>
<tbody><tr id="row6366372295642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p5648782795642"><a name="p5648782795642"></a><a name="p5648782795642"></a>1</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p1211123695642"><a name="p1211123695642"></a><a name="p1211123695642"></a>LOS_ERRNO_SEM_NO_MEMORY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p4148605495642"><a name="p4148605495642"></a><a name="p4148605495642"></a>0x02000700</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p492720095642"><a name="p492720095642"></a><a name="p492720095642"></a>初始化信号量时，内存空间不足</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p145551278485"><a name="p145551278485"></a><a name="p145551278485"></a>调整OS_SYS_MEM_SIZE以确保有足够的内存供信号量使用，或减小系统支持的最大信号量数LOSCFG_BASE_IPC_SEM_LIMIT</p>
</td>
</tr>
<tr id="row4434480695642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p3515954495642"><a name="p3515954495642"></a><a name="p3515954495642"></a>2</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p2935083995642"><a name="p2935083995642"></a><a name="p2935083995642"></a>LOS_ERRNO_SEM_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p2860775495642"><a name="p2860775495642"></a><a name="p2860775495642"></a>0x02000701</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p3552674695642"><a name="p3552674695642"></a><a name="p3552674695642"></a>信号量ID不正确或信号量未创建</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p412423410026"><a name="p412423410026"></a><a name="p412423410026"></a>传入正确的信号量ID或创建信号量后再使用</p>
</td>
</tr>
<tr id="row5130526095642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p6208537795642"><a name="p6208537795642"></a><a name="p6208537795642"></a>3</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p6285965595642"><a name="p6285965595642"></a><a name="p6285965595642"></a>LOS_ERRNO_SEM_PTR_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p5846730195642"><a name="p5846730195642"></a><a name="p5846730195642"></a>0x02000702</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p3823098095642"><a name="p3823098095642"></a><a name="p3823098095642"></a>传入空指针</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p6562756010026"><a name="p6562756010026"></a><a name="p6562756010026"></a>传入合法指针</p>
</td>
</tr>
<tr id="row853450895642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p2020651095642"><a name="p2020651095642"></a><a name="p2020651095642"></a>4</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p2611462995642"><a name="p2611462995642"></a><a name="p2611462995642"></a>LOS_ERRNO_SEM_ALL_BUSY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p3491023395642"><a name="p3491023395642"></a><a name="p3491023395642"></a>0x02000703</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p915662595642"><a name="p915662595642"></a><a name="p915662595642"></a>创建信号量时，系统中已经没有未使用的信号量</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p1423211810026"><a name="p1423211810026"></a><a name="p1423211810026"></a>及时删除无用的信号量或增加系统支持的最大信号量数LOSCFG_BASE_IPC_SEM_LIMIT</p>
</td>
</tr>
<tr id="row1530076695642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p3140256895642"><a name="p3140256895642"></a><a name="p3140256895642"></a>5</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p6058010795642"><a name="p6058010795642"></a><a name="p6058010795642"></a>LOS_ERRNO_SEM_UNAVAILABLE</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p804161495642"><a name="p804161495642"></a><a name="p804161495642"></a>0x02000704</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p10819081152943"><a name="p10819081152943"></a><a name="p10819081152943"></a>无阻塞模式下未获取到信号量</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p42669253153017"><a name="p42669253153017"></a><a name="p42669253153017"></a>选择阻塞等待或根据该错误码适当处理</p>
</td>
</tr>
<tr id="row2386554195642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p5406070595642"><a name="p5406070595642"></a><a name="p5406070595642"></a>6</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p1684095295642"><a name="p1684095295642"></a><a name="p1684095295642"></a>LOS_ERRNO_SEM_PEND_INTERR</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p2193989295642"><a name="p2193989295642"></a><a name="p2193989295642"></a>0x02000705</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p63490793152953"><a name="p63490793152953"></a><a name="p63490793152953"></a>中断期间非法调用LOS_SemPend申请信号量</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p43375472153017"><a name="p43375472153017"></a><a name="p43375472153017"></a>中断期间禁止调用LOS_SemPend</p>
</td>
</tr>
<tr id="row2227229895642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p5922568095642"><a name="p5922568095642"></a><a name="p5922568095642"></a>7</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p3255077595642"><a name="p3255077595642"></a><a name="p3255077595642"></a>LOS_ERRNO_SEM_PEND_IN_LOCK</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p1936711095642"><a name="p1936711095642"></a><a name="p1936711095642"></a>0x02000706</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p52085876152953"><a name="p52085876152953"></a><a name="p52085876152953"></a>任务被锁，无法获得信号量</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p36140674153017"><a name="p36140674153017"></a><a name="p36140674153017"></a>在任务被锁时，不能调用LOS_SemPend申请信号量</p>
</td>
</tr>
<tr id="row43458669101114"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p30491270101114"><a name="p30491270101114"></a><a name="p30491270101114"></a>8</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p53873767101114"><a name="p53873767101114"></a><a name="p53873767101114"></a>LOS_ERRNO_SEM_TIMEOUT</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p1699001101114"><a name="p1699001101114"></a><a name="p1699001101114"></a>0x02000707</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p28760934152953"><a name="p28760934152953"></a><a name="p28760934152953"></a>获取信号量超时</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p48623836153017"><a name="p48623836153017"></a><a name="p48623836153017"></a>将时间设置在合理范围内</p>
</td>
</tr>
<tr id="row12143904101125"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p44132204101125"><a name="p44132204101125"></a><a name="p44132204101125"></a>9</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p17938739101125"><a name="p17938739101125"></a><a name="p17938739101125"></a>LOS_ERRNO_SEM_OVERFLOW</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p43751775101125"><a name="p43751775101125"></a><a name="p43751775101125"></a>0x02000708</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p35771040152953"><a name="p35771040152953"></a><a name="p35771040152953"></a>信号量计数值已达到最大值，无法再继续释放该信号量</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p7712100153017"><a name="p7712100153017"></a><a name="p7712100153017"></a>根据该错误码适当处理</p>
</td>
</tr>
<tr id="row44185939101121"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p22291345101121"><a name="p22291345101121"></a><a name="p22291345101121"></a>10</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p60768531101121"><a name="p60768531101121"></a><a name="p60768531101121"></a>LOS_ERRNO_SEM_PENDED</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p23304002101121"><a name="p23304002101121"></a><a name="p23304002101121"></a>0x02000709</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p52495624152953"><a name="p52495624152953"></a><a name="p52495624152953"></a>等待信号量的任务队列不为空</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p9449161153017"><a name="p9449161153017"></a><a name="p9449161153017"></a>唤醒所有等待该信号量的任务后，再删除该信号量</p>
</td>
</tr>
<tr id="row14232120451"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.65%" valign="top"><p id="p8232012154514"><a name="p8232012154514"></a><a name="p8232012154514"></a>11</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="21.15%" valign="top"><p id="p1623121284516"><a name="p1623121284516"></a><a name="p1623121284516"></a>LOS_ERRNO_SEM_PEND_IN_SYSTEM_TASK</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.089999999999998%" valign="top"><p id="p323131215459"><a name="p323131215459"></a><a name="p323131215459"></a>0x0200070a</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="26.91%" valign="top"><p id="p1123512134512"><a name="p1123512134512"></a><a name="p1123512134512"></a>在系统任务中获取信号量，如idle和软件定时器</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="33.2%" valign="top"><p id="p162331214458"><a name="p162331214458"></a><a name="p162331214458"></a>不要在系统任务中获取信号量</p>
</td>
</tr>
</tbody>
</table>

如有错误码更新，参考 [LiteOS内核开发者手册](https://gitee.com/LiteOS/LiteOS/blob/master/doc/LiteOS_Kernel_Developer_Guide.md)