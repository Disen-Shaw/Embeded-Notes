# LiteOS 软件定时器 错误码
<table>
	<thead align="left"><tr id="row2267197395642"><th class="cellrowborder" id="mcps1.1.6.1.1" width="5.34%" valign="top"><p id="p1908783195642"><a name="p1908783195642"></a><a name="p1908783195642"></a>序号</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.2" width="24.82%" valign="top"><p id="p261046995642"><a name="p261046995642"></a><a name="p261046995642"></a>定义</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.3" width="13.3%" valign="top"><p id="p1012144095642"><a name="p1012144095642"></a><a name="p1012144095642"></a>实际数值</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.4" width="27.01%" valign="top"><p id="p1453028795642"><a name="p1453028795642"></a><a name="p1453028795642"></a>描述</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.5" width="29.53%" valign="top"><p id="p2753561710026"><a name="p2753561710026"></a><a name="p2753561710026"></a>参考解决方案</p>
</th>
</tr>
</thead>
<tbody><tr id="row6366372295642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p5648782795642"><a name="p5648782795642"></a><a name="p5648782795642"></a>1</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p1211123695642"><a name="p1211123695642"></a><a name="p1211123695642"></a>LOS_ERRNO_SWTMR_PTR_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p4148605495642"><a name="p4148605495642"></a><a name="p4148605495642"></a>0x02000300</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p492720095642"><a name="p492720095642"></a><a name="p492720095642"></a>软件定时器回调函数为空</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p1579250110026"><a name="p1579250110026"></a><a name="p1579250110026"></a>定义软件定时器回调函数</p>
</td>
</tr>
<tr id="row4434480695642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p3515954495642"><a name="p3515954495642"></a><a name="p3515954495642"></a>2</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p2935083995642"><a name="p2935083995642"></a><a name="p2935083995642"></a>LOS_ERRNO_SWTMR_INTERVAL_NOT_SUITED</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p2860775495642"><a name="p2860775495642"></a><a name="p2860775495642"></a>0x02000301</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p3552674695642"><a name="p3552674695642"></a><a name="p3552674695642"></a>软件定时器的定时时长为0</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p412423410026"><a name="p412423410026"></a><a name="p412423410026"></a>重新定义定时器的定时时长</p>
</td>
</tr>
<tr id="row5130526095642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p6208537795642"><a name="p6208537795642"></a><a name="p6208537795642"></a>3</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p14395618185923"><a name="p14395618185923"></a><a name="p14395618185923"></a>LOS_ERRNO_SWTMR_MODE_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p5846730195642"><a name="p5846730195642"></a><a name="p5846730195642"></a>0x02000302</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p3823098095642"><a name="p3823098095642"></a><a name="p3823098095642"></a>不正确的软件定时器模式</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p6562756010026"><a name="p6562756010026"></a><a name="p6562756010026"></a>确认软件定时器模式，范围为[0,2]</p>
</td>
</tr>
<tr id="row853450895642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p2020651095642"><a name="p2020651095642"></a><a name="p2020651095642"></a>4</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p2611462995642"><a name="p2611462995642"></a><a name="p2611462995642"></a>LOS_ERRNO_SWTMR_RET_PTR_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p3491023395642"><a name="p3491023395642"></a><a name="p3491023395642"></a>0x02000303</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p915662595642"><a name="p915662595642"></a><a name="p915662595642"></a>入参的软件定时器ID指针为NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p1423211810026"><a name="p1423211810026"></a><a name="p1423211810026"></a>定义ID变量，传入有效指针</p>
</td>
</tr>
<tr id="row1530076695642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p3140256895642"><a name="p3140256895642"></a><a name="p3140256895642"></a>5</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p6058010795642"><a name="p6058010795642"></a><a name="p6058010795642"></a>LOS_ERRNO_SWTMR_MAXSIZE</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p804161495642"><a name="p804161495642"></a><a name="p804161495642"></a>0x02000304</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p4739096995642"><a name="p4739096995642"></a><a name="p4739096995642"></a>软件定时器个数超过最大值</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p1195087610026"><a name="p1195087610026"></a><a name="p1195087610026"></a>重新设置软件定时器最大个数，或者等待一个软件定时器释放资源</p>
</td>
</tr>
<tr id="row2386554195642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p5406070595642"><a name="p5406070595642"></a><a name="p5406070595642"></a>6</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p1684095295642"><a name="p1684095295642"></a><a name="p1684095295642"></a>LOS_ERRNO_SWTMR_ID_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p2193989295642"><a name="p2193989295642"></a><a name="p2193989295642"></a>0x02000305</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p3230086195642"><a name="p3230086195642"></a><a name="p3230086195642"></a>入参的软件定时器ID不正确</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p2849689910026"><a name="p2849689910026"></a><a name="p2849689910026"></a>确保入参合法</p>
</td>
</tr>
<tr id="row2227229895642"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p5922568095642"><a name="p5922568095642"></a><a name="p5922568095642"></a>7</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p3255077595642"><a name="p3255077595642"></a><a name="p3255077595642"></a>LOS_ERRNO_SWTMR_NOT_CREATED</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p1936711095642"><a name="p1936711095642"></a><a name="p1936711095642"></a>0x02000306</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p2523210295642"><a name="p2523210295642"></a><a name="p2523210295642"></a>软件定时器未创建</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p62917066101048"><a name="p62917066101048"></a><a name="p62917066101048"></a>创建软件定时器</p>
</td>
</tr>
<tr id="row43458669101114"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p30491270101114"><a name="p30491270101114"></a><a name="p30491270101114"></a>8</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p53873767101114"><a name="p53873767101114"></a><a name="p53873767101114"></a>LOS_ERRNO_SWTMR_NO_MEMORY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p1699001101114"><a name="p1699001101114"></a><a name="p1699001101114"></a>0x02000307</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p3955882919926"><a name="p3955882919926"></a><a name="p3955882919926"></a>初始化软件定时器模块时，内存不足</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p60375397191252"><a name="p60375397191252"></a><a name="p60375397191252"></a>调整OS_SYS_MEM_SIZE，以确保有足够的内存供软件定时器使用</p>
</td>
</tr>
<tr id="row12143904101125"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p44132204101125"><a name="p44132204101125"></a><a name="p44132204101125"></a>9</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p17938739101125"><a name="p17938739101125"></a><a name="p17938739101125"></a>LOS_ERRNO_SWTMR_MAXSIZE_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p43751775101125"><a name="p43751775101125"></a><a name="p43751775101125"></a>0x02000308</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p54232920101125"><a name="p54232920101125"></a><a name="p54232920101125"></a>暂不使用该错误码</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p60601407191429"><a name="p60601407191429"></a><a name="p60601407191429"></a>-</p>
</td>
</tr>
<tr id="row44185939101121"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p22291345101121"><a name="p22291345101121"></a><a name="p22291345101121"></a>10</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p60768531101121"><a name="p60768531101121"></a><a name="p60768531101121"></a>LOS_ERRNO_SWTMR_HWI_ACTIVE</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p23304002101121"><a name="p23304002101121"></a><a name="p23304002101121"></a>0x02000309</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p8576005101121"><a name="p8576005101121"></a><a name="p8576005101121"></a>在中断中使用定时器</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p23567813101121"><a name="p23567813101121"></a><a name="p23567813101121"></a>修改源代码确保不在中断中使用</p>
</td>
</tr>
<tr id="row25611405101131"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p61257961101131"><a name="p61257961101131"></a><a name="p61257961101131"></a>11</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p62947776101131"><a name="p62947776101131"></a><a name="p62947776101131"></a>LOS_ERRNO_SWTMR_HANDLER_POOL_NO_MEM</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p65605116101131"><a name="p65605116101131"></a><a name="p65605116101131"></a>0x0200030a</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p20573694191652"><a name="p20573694191652"></a><a name="p20573694191652"></a>暂不使用该错误码</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p66027202101131"><a name="p66027202101131"></a><a name="p66027202101131"></a>-</p>
</td>
</tr>
<tr id="row61184987101143"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p57036951101143"><a name="p57036951101143"></a><a name="p57036951101143"></a>12</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p56590286101143"><a name="p56590286101143"></a><a name="p56590286101143"></a>LOS_ERRNO_SWTMR_QUEUE_CREATE_FAILED</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p20410474101143"><a name="p20410474101143"></a><a name="p20410474101143"></a>0x0200030b</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p42635731101143"><a name="p42635731101143"></a><a name="p42635731101143"></a>在软件定时器初始化时，创建定时器队列失败</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p17562130104812"><a name="p17562130104812"></a><a name="p17562130104812"></a>调整OS_SYS_MEM_SIZE，以确保有足够的内存供软件定时器创建队列</p>
</td>
</tr>
<tr id="row55331775101146"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p52688791101146"><a name="p52688791101146"></a><a name="p52688791101146"></a>13</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p39933692101146"><a name="p39933692101146"></a><a name="p39933692101146"></a>LOS_ERRNO_SWTMR_TASK_CREATE_FAILED</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p39289074192041"><a name="p39289074192041"></a><a name="p39289074192041"></a>0x0200030c</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p11950219101146"><a name="p11950219101146"></a><a name="p11950219101146"></a>在软件定时器初始化时，创建定时器任务失败</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p47151913492"><a name="p47151913492"></a><a name="p47151913492"></a>调整OS_SYS_MEM_SIZE，以确保有足够的内存供软件定时器创建任务</p>
</td>
</tr>
<tr id="row2857798210120"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p3311521410120"><a name="p3311521410120"></a><a name="p3311521410120"></a>14</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p6508665810120"><a name="p6508665810120"></a><a name="p6508665810120"></a>LOS_ERRNO_SWTMR_NOT_STARTED</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p3752793910120"><a name="p3752793910120"></a><a name="p3752793910120"></a>0x0200030d</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p59973912192254"><a name="p59973912192254"></a><a name="p59973912192254"></a>未启动软件定时器</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p5265929219236"><a name="p5265929219236"></a><a name="p5265929219236"></a>启动软件定时器</p>
</td>
</tr>
<tr id="row4447897810129"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p4602745410129"><a name="p4602745410129"></a><a name="p4602745410129"></a>15</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p3723625410129"><a name="p3723625410129"></a><a name="p3723625410129"></a>LOS_ERRNO_SWTMR_STATUS_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p6334657010129"><a name="p6334657010129"></a><a name="p6334657010129"></a>0x0200030e</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p6695266119244"><a name="p6695266119244"></a><a name="p6695266119244"></a>不正确的软件定时器状态</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p61350282192418"><a name="p61350282192418"></a><a name="p61350282192418"></a>检查确认软件定时器状态</p>
</td>
</tr>
<tr id="row6331348110124"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p2811835210124"><a name="p2811835210124"></a><a name="p2811835210124"></a>16</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p6299406810124"><a name="p6299406810124"></a><a name="p6299406810124"></a>LOS_ERRNO_SWTMR_SORTLIST_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p224588410124"><a name="p224588410124"></a><a name="p224588410124"></a>0x0200030f</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p4769892910124"><a name="p4769892910124"></a><a name="p4769892910124"></a>暂不使用该错误码</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p3840802610124"><a name="p3840802610124"></a><a name="p3840802610124"></a>-</p>
</td>
</tr>
<tr id="row4160002610127"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p1415891810127"><a name="p1415891810127"></a><a name="p1415891810127"></a>17</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p602173510127"><a name="p602173510127"></a><a name="p602173510127"></a>LOS_ERRNO_SWTMR_TICK_PTR_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p1799856510127"><a name="p1799856510127"></a><a name="p1799856510127"></a>0x02000310</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p401190419321"><a name="p401190419321"></a><a name="p401190419321"></a>用以获取软件定时器剩余Tick数的入参指针为NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p4409730210127"><a name="p4409730210127"></a><a name="p4409730210127"></a>定义有效变量以传入有效指针</p>
</td>
</tr>
<tr id="row4522121517596"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p8522915125913"><a name="p8522915125913"></a><a name="p8522915125913"></a>18</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="24.82%" valign="top"><p id="p4522111595915"><a name="p4522111595915"></a><a name="p4522111595915"></a>LOS_ERRNO_SWTMR_SORTLINK_CREATE_FAILED</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.3%" valign="top"><p id="p452271525919"><a name="p452271525919"></a><a name="p452271525919"></a>0x02000311</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="27.01%" valign="top"><p id="p1522191517594"><a name="p1522191517594"></a><a name="p1522191517594"></a>在软件定时器初始化时，创建定时器链表失败</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="29.53%" valign="top"><p id="p12161145652119"><a name="p12161145652119"></a><a name="p12161145652119"></a>调整OS_SYS_MEM_SIZE，以确保有足够的内存供软件定时器创建链表</p>
</td>
</tr>
</tbody>

</table>

