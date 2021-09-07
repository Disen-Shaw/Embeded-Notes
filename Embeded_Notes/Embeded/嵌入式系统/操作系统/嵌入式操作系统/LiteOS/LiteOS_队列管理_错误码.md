# LiteOS 队列管理 错误码
<table>
<thead align="left"><tr id="row66647056191749"><th class="cellrowborder" id="mcps1.1.6.1.1" width="5.34%" valign="top"><p id="p65995609191749"><a name="p65995609191749"></a><a name="p65995609191749"></a>序号</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.2" width="20.21%" valign="top"><p id="p44044076191749"><a name="p44044076191749"></a><a name="p44044076191749"></a>定义</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.3" width="13.930000000000001%" valign="top"><p id="p10800441191749"><a name="p10800441191749"></a><a name="p10800441191749"></a>实际数值</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.4" width="24.610000000000003%" valign="top"><p id="p39597633191844"><a name="p39597633191844"></a><a name="p39597633191844"></a>描述</p>
</th>
<th class="cellrowborder" id="mcps1.1.6.1.5" width="35.91%" valign="top"><p id="p61844251191749"><a name="p61844251191749"></a><a name="p61844251191749"></a>参考解决方案</p>
</th>
</tr>
</thead>
<tbody><tr id="row6517730619218"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p4487040819218"><a name="p4487040819218"></a><a name="p4487040819218"></a>1</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p1062439819218"><a name="p1062439819218"></a><a name="p1062439819218"></a>LOS_ERRNO_QUEUE_MAXNUM_ZERO</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p5526990919218"><a name="p5526990919218"></a><a name="p5526990919218"></a>0x02000600</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p9238164164714"><a name="p9238164164714"></a><a name="p9238164164714"></a>系统支持的最大队列数为0</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p1372919138224"><a name="p1372919138224"></a><a name="p1372919138224"></a>系统支持的最大队列数应该大于0。如果不使用队列模块，则将队列模块静态裁剪开关LOSCFG_BASE_IPC_QUEUE设置为NO</p>
</td>
</tr>
<tr id="row33366968191749"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p18369922191749"><a name="p18369922191749"></a><a name="p18369922191749"></a>2</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p11568741191749"><a name="p11568741191749"></a><a name="p11568741191749"></a>LOS_ERRNO_QUEUE_NO_MEMORY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p64652808191749"><a name="p64652808191749"></a><a name="p64652808191749"></a>0x02000601</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p787615154915"><a name="p787615154915"></a><a name="p787615154915"></a>队列初始化时，从动态内存池申请内存失败</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p1687611564915"><a name="p1687611564915"></a><a name="p1687611564915"></a>设置更大的系统动态内存池，配置项为OS_SYS_MEM_SIZE，或减少系统支持的最大队列数</p>
</td>
</tr>
<tr id="row33397154191749"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p20814974191749"><a name="p20814974191749"></a><a name="p20814974191749"></a>3</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p8291367191749"><a name="p8291367191749"></a><a name="p8291367191749"></a>LOS_ERRNO_QUEUE_CREATE_NO_MEMORY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p512132191749"><a name="p512132191749"></a><a name="p512132191749"></a>0x02000602</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p181431132184915"><a name="p181431132184915"></a><a name="p181431132184915"></a>创建队列时，从动态内存池申请内存失败</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p614312322497"><a name="p614312322497"></a><a name="p614312322497"></a>设置更大的系统动态内存池，配置项为OS_SYS_MEM_SIZE，或减少要创建队列的队列长度和消息节点大小</p>
</td>
</tr>
<tr id="row41391008191749"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p64337369191749"><a name="p64337369191749"></a><a name="p64337369191749"></a>4</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p43944370191749"><a name="p43944370191749"></a><a name="p43944370191749"></a>LOS_ERRNO_QUEUE_SIZE_TOO_BIG</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p2724179191749"><a name="p2724179191749"></a><a name="p2724179191749"></a>0x02000603</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p197252184910"><a name="p197252184910"></a><a name="p197252184910"></a>创建队列时消息节点大小超过上限</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p49735213493"><a name="p49735213493"></a><a name="p49735213493"></a>更改入参消息节点大小，使之不超过上限</p>
</td>
</tr>
<tr id="row10026959191749"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p6877374191749"><a name="p6877374191749"></a><a name="p6877374191749"></a>5</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p20196417191749"><a name="p20196417191749"></a><a name="p20196417191749"></a>LOS_ERRNO_QUEUE_CB_UNAVAILABLE</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p25297089191749"><a name="p25297089191749"></a><a name="p25297089191749"></a>0x02000604</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p1732013725019"><a name="p1732013725019"></a><a name="p1732013725019"></a>创建队列时，系统中已经没有空闲队列</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p232020755019"><a name="p232020755019"></a><a name="p232020755019"></a>增加系统支持的最大队列数</p>
</td>
</tr>
<tr id="row59373972191749"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p44562467191749"><a name="p44562467191749"></a><a name="p44562467191749"></a>6</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p52790107191749"><a name="p52790107191749"></a><a name="p52790107191749"></a>LOS_ERRNO_QUEUE_NOT_FOUND</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p48140259191749"><a name="p48140259191749"></a><a name="p48140259191749"></a>0x02000605</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p60420222193129"><a name="p60420222193129"></a><a name="p60420222193129"></a>传递给删除队列接口的队列ID大于等于系统支持的最大队列数</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p49643405193152"><a name="p49643405193152"></a><a name="p49643405193152"></a>确保队列ID是有效的</p>
</td>
</tr>
<tr id="row36473565191749"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p1568774191749"><a name="p1568774191749"></a><a name="p1568774191749"></a>7</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p59961868191749"><a name="p59961868191749"></a><a name="p59961868191749"></a>LOS_ERRNO_QUEUE_PEND_IN_LOCK</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p25073110191749"><a name="p25073110191749"></a><a name="p25073110191749"></a>0x02000606</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p19045334193230"><a name="p19045334193230"></a><a name="p19045334193230"></a>当任务被锁定时，禁止在队列中阻塞等待写消息或读消息</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p20051835193257"><a name="p20051835193257"></a><a name="p20051835193257"></a>使用队列前解锁任务</p>
</td>
</tr>
<tr id="row51263497192010"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p58702556192010"><a name="p58702556192010"></a><a name="p58702556192010"></a>8</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p57286633192010"><a name="p57286633192010"></a><a name="p57286633192010"></a>LOS_ERRNO_QUEUE_TIMEOUT</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p9705686192010"><a name="p9705686192010"></a><a name="p9705686192010"></a>0x02000607</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p53994389193449"><a name="p53994389193449"></a><a name="p53994389193449"></a>等待处理队列超时</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p51382338193520"><a name="p51382338193520"></a><a name="p51382338193520"></a>检查设置的超时时间是否合适</p>
</td>
</tr>
<tr id="row36402998193312"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p62961745193312"><a name="p62961745193312"></a><a name="p62961745193312"></a>9</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p66736597193312"><a name="p66736597193312"></a><a name="p66736597193312"></a>LOS_ERRNO_QUEUE_IN_TSKUSE</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p36955240193312"><a name="p36955240193312"></a><a name="p36955240193312"></a>0x02000608</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p3637555120413"><a name="p3637555120413"></a><a name="p3637555120413"></a>队列存在阻塞任务而不能被删除</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p66119138193312"><a name="p66119138193312"></a><a name="p66119138193312"></a>使任务能够获得资源而不是在队列中被阻塞</p>
</td>
</tr>
<tr id="row51203889193321"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p53874317193321"><a name="p53874317193321"></a><a name="p53874317193321"></a>10</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p1743582193321"><a name="p1743582193321"></a><a name="p1743582193321"></a>LOS_ERRNO_QUEUE_WRITE_IN_INTERRUPT</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p7012492193321"><a name="p7012492193321"></a><a name="p7012492193321"></a>0x02000609</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p31140990193321"><a name="p31140990193321"></a><a name="p31140990193321"></a>在中断处理程序中不能以阻塞模式写队列</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p51817932193749"><a name="p51817932193749"></a><a name="p51817932193749"></a>将写队列设为非阻塞模式，即将写队列的超时时间设置为0</p>
</td>
</tr>
<tr id="row58997007193325"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p14028263193325"><a name="p14028263193325"></a><a name="p14028263193325"></a>11</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p62547532193325"><a name="p62547532193325"></a><a name="p62547532193325"></a>LOS_ERRNO_QUEUE_NOT_CREATE</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p33185317193325"><a name="p33185317193325"></a><a name="p33185317193325"></a>0x0200060a</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p3656155193325"><a name="p3656155193325"></a><a name="p3656155193325"></a>队列未创建</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p14251707193839"><a name="p14251707193839"></a><a name="p14251707193839"></a>创建该队列，或更换为一个已经创建的队列</p>
</td>
</tr>
<tr id="row23132180193345"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p61767288193345"><a name="p61767288193345"></a><a name="p61767288193345"></a>12</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p37094461193345"><a name="p37094461193345"></a><a name="p37094461193345"></a>LOS_ERRNO_QUEUE_IN_TSKWRITE</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p51861387193345"><a name="p51861387193345"></a><a name="p51861387193345"></a>0x0200060b</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p6555415519399"><a name="p6555415519399"></a><a name="p6555415519399"></a>队列读写不同步</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p20620767193345"><a name="p20620767193345"></a><a name="p20620767193345"></a>同步队列的读写，即多个任务不能并发读写同一个队列</p>
</td>
</tr>
<tr id="row21687970193352"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p11895156193352"><a name="p11895156193352"></a><a name="p11895156193352"></a>13</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p23983603193352"><a name="p23983603193352"></a><a name="p23983603193352"></a>LOS_ERRNO_QUEUE_CREAT_PTR_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p63623686193352"><a name="p63623686193352"></a><a name="p63623686193352"></a>0x0200060c</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p3279290519404"><a name="p3279290519404"></a><a name="p3279290519404"></a>对于创建队列接口，保存队列ID的入参为空指针</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p17873674193352"><a name="p17873674193352"></a><a name="p17873674193352"></a>确保传入的参数不为空指针</p>
</td>
</tr>
<tr id="row32251036193358"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p62197112193358"><a name="p62197112193358"></a><a name="p62197112193358"></a>14</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p4801272193358"><a name="p4801272193358"></a><a name="p4801272193358"></a>LOS_ERRNO_QUEUE_PARA_ISZERO</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p53358724193358"><a name="p53358724193358"></a><a name="p53358724193358"></a>0x0200060d</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p27309930194051"><a name="p27309930194051"></a><a name="p27309930194051"></a>对于创建队列接口，入参队列长度或消息节点大小为0</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p46758883193358"><a name="p46758883193358"></a><a name="p46758883193358"></a>传入正确的队列长度和消息节点大小</p>
</td>
</tr>
<tr id="row6471318219343"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p727640719343"><a name="p727640719343"></a><a name="p727640719343"></a>15</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p5251806419343"><a name="p5251806419343"></a><a name="p5251806419343"></a>LOS_ERRNO_QUEUE_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p2610475319343"><a name="p2610475319343"></a><a name="p2610475319343"></a>0x0200060e</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p5223249920528"><a name="p5223249920528"></a><a name="p5223249920528"></a>传递给读队列或写队列或获取队列信息接口的队列ID大于等于系统支持的最大队列数</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p329454442063"><a name="p329454442063"></a><a name="p329454442063"></a>确保队列ID有效</p>
</td>
</tr>
<tr id="row3895023819348"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p85270419348"><a name="p85270419348"></a><a name="p85270419348"></a>16</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p196018619348"><a name="p196018619348"></a><a name="p196018619348"></a>LOS_ERRNO_QUEUE_READ_PTR_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p2455739719348"><a name="p2455739719348"></a><a name="p2455739719348"></a>0x0200060f</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p5676363194253"><a name="p5676363194253"></a><a name="p5676363194253"></a>传递给读队列接口的指针为空</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p37131993194325"><a name="p37131993194325"></a><a name="p37131993194325"></a>确保传入的参数不为空指针</p>
</td>
</tr>
<tr id="row15616099193413"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p56944481193413"><a name="p56944481193413"></a><a name="p56944481193413"></a>17</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p49100215193413"><a name="p49100215193413"></a><a name="p49100215193413"></a>LOS_ERRNO_QUEUE_READSIZE_IS_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p17694478193413"><a name="p17694478193413"></a><a name="p17694478193413"></a>0x02000610</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p23966605193413"><a name="p23966605193413"></a><a name="p23966605193413"></a>传递给读队列接口的缓冲区大小为0或者大于0xFFFB</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p62246877193413"><a name="p62246877193413"></a><a name="p62246877193413"></a>传入的一个正确的缓冲区大小需要大于0且小于0xFFFC</p>
</td>
</tr>
<tr id="row24056666194424"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p2432890194424"><a name="p2432890194424"></a><a name="p2432890194424"></a>18</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p62846374194424"><a name="p62846374194424"></a><a name="p62846374194424"></a>LOS_ERRNO_QUEUE_WRITE_PTR_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p57391559194424"><a name="p57391559194424"></a><a name="p57391559194424"></a>0x02000612</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p2160612619463"><a name="p2160612619463"></a><a name="p2160612619463"></a>传递给写队列接口的缓冲区指针为空</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p65297927194424"><a name="p65297927194424"></a><a name="p65297927194424"></a>确保传入的参数不为空指针</p>
</td>
</tr>
<tr id="row23479934194430"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p22826525194430"><a name="p22826525194430"></a><a name="p22826525194430"></a>19</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p37009232194430"><a name="p37009232194430"></a><a name="p37009232194430"></a>LOS_ERRNO_QUEUE_WRITESIZE_ISZERO</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p44957824194430"><a name="p44957824194430"></a><a name="p44957824194430"></a>0x02000613</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p28691532194638"><a name="p28691532194638"></a><a name="p28691532194638"></a>传递给写队列接口的缓冲区大小为0</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p24827637194430"><a name="p24827637194430"></a><a name="p24827637194430"></a>传入正确的缓冲区大小</p>
</td>
</tr>
<tr id="row2499390194657"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p1124069194657"><a name="p1124069194657"></a><a name="p1124069194657"></a>20</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p23940727194657"><a name="p23940727194657"></a><a name="p23940727194657"></a>LOS_ERRNO_QUEUE_WRITE_SIZE_TOO_BIG</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p60150750194657"><a name="p60150750194657"></a><a name="p60150750194657"></a>0x02000615</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p40372610194657"><a name="p40372610194657"></a><a name="p40372610194657"></a>传递给写队列接口的缓冲区大小比队列的消息节点大小要大</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p7860434194847"><a name="p7860434194847"></a><a name="p7860434194847"></a>减小缓冲区大小，或增大队列的消息节点大小</p>
</td>
</tr>
<tr id="row4823728219471"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p1490580719471"><a name="p1490580719471"></a><a name="p1490580719471"></a>21</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p6651970819471"><a name="p6651970819471"></a><a name="p6651970819471"></a>LOS_ERRNO_QUEUE_ISFULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p1938724919471"><a name="p1938724919471"></a><a name="p1938724919471"></a>0x02000616</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p15921102185619"><a name="p15921102185619"></a><a name="p15921102185619"></a>写队列时没有可用的空闲节点</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p892182115562"><a name="p892182115562"></a><a name="p892182115562"></a>写队列之前，确保在队列中存在可用的空闲节点，或者使用阻塞模式写队列，即设置大于0的写队列超时时间</p>
</td>
</tr>
<tr id="row33549139194916"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p33125773194917"><a name="p33125773194917"></a><a name="p33125773194917"></a>22</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p65941984194917"><a name="p65941984194917"></a><a name="p65941984194917"></a>LOS_ERRNO_QUEUE_PTR_NULL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p39700467194917"><a name="p39700467194917"></a><a name="p39700467194917"></a>0x02000617</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p1581313369567"><a name="p1581313369567"></a><a name="p1581313369567"></a>传递给获取队列信息接口的指针为空</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p1981333617564"><a name="p1981333617564"></a><a name="p1981333617564"></a>确保传入的参数不为空指针</p>
</td>
</tr>
<tr id="row39947507194923"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p14522634194923"><a name="p14522634194923"></a><a name="p14522634194923"></a>23</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p35482697194923"><a name="p35482697194923"></a><a name="p35482697194923"></a>LOS_ERRNO_QUEUE_READ_IN_INTERRUPT</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p55526233194923"><a name="p55526233194923"></a><a name="p55526233194923"></a>0x02000618</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p719617491561"><a name="p719617491561"></a><a name="p719617491561"></a>在中断处理程序中不能以阻塞模式读队列</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p4196154910564"><a name="p4196154910564"></a><a name="p4196154910564"></a>将读队列设为非阻塞模式，即将读队列的超时时间设置为0</p>
</td>
</tr>
<tr id="row50011219194929"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p24376929194929"><a name="p24376929194929"></a><a name="p24376929194929"></a>24</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p28374236194929"><a name="p28374236194929"></a><a name="p28374236194929"></a>LOS_ERRNO_QUEUE_MAIL_HANDLE_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p16611755194929"><a name="p16611755194929"></a><a name="p16611755194929"></a>0x02000619</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p419411103577"><a name="p419411103577"></a><a name="p419411103577"></a>CMSIS-RTOS 1.0中的mail队列，释放内存块时，发现传入的mail队列ID无效</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p55981730143813"><a name="p55981730143813"></a><a name="p55981730143813"></a>确保传入的mail队列ID是正确的</p>
</td>
</tr>
<tr id="row41671503194933"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p19948548194933"><a name="p19948548194933"></a><a name="p19948548194933"></a>25</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p5219669194933"><a name="p5219669194933"></a><a name="p5219669194933"></a>LOS_ERRNO_QUEUE_MAIL_PTR_INVALID</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p20140076194933"><a name="p20140076194933"></a><a name="p20140076194933"></a>0x0200061a</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p128852235715"><a name="p128852235715"></a><a name="p128852235715"></a>CMSIS-RTOS 1.0中的mail队列，释放内存块时，发现传入的mail内存池指针为空</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p828862235714"><a name="p828862235714"></a><a name="p828862235714"></a>传入非空的mail内存池指针</p>
</td>
</tr>
<tr id="row24094539194938"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p5500604194938"><a name="p5500604194938"></a><a name="p5500604194938"></a>26</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p42895774194938"><a name="p42895774194938"></a><a name="p42895774194938"></a>LOS_ERRNO_QUEUE_MAIL_FREE_ERROR</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p52005656194938"><a name="p52005656194938"></a><a name="p52005656194938"></a>0x0200061b</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p1834033520578"><a name="p1834033520578"></a><a name="p1834033520578"></a>CMSIS-RTOS 1.0中的mail队列，释放内存块失败</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p834011351571"><a name="p834011351571"></a><a name="p834011351571"></a>传入非空的mail队列内存块指针</p>
</td>
</tr>
<tr id="row32525342195533"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p17307058195533"><a name="p17307058195533"></a><a name="p17307058195533"></a>27</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p59694421195533"><a name="p59694421195533"></a><a name="p59694421195533"></a>LOS_ERRNO_QUEUE_ISEMPTY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p3409970195533"><a name="p3409970195533"></a><a name="p3409970195533"></a>0x0200061d</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p7772143195533"><a name="p7772143195533"></a><a name="p7772143195533"></a>队列已空</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p65865508195654"><a name="p65865508195654"></a><a name="p65865508195654"></a>读队列之前，确保队列中存在未读的消息，或者使用阻塞模式读队列，即设置大于0的读队列超时时间</p>
</td>
</tr>
<tr id="row14065892195540"><td class="cellrowborder" headers="mcps1.1.6.1.1 " width="5.34%" valign="top"><p id="p65595428195540"><a name="p65595428195540"></a><a name="p65595428195540"></a>28</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.2 " width="20.21%" valign="top"><p id="p11629424195540"><a name="p11629424195540"></a><a name="p11629424195540"></a>LOS_ERRNO_QUEUE_READ_SIZE_TOO_SMALL</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.3 " width="13.930000000000001%" valign="top"><p id="p2459313195540"><a name="p2459313195540"></a><a name="p2459313195540"></a>0x0200061f</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.4 " width="24.610000000000003%" valign="top"><p id="p910254135819"><a name="p910254135819"></a><a name="p910254135819"></a>传递给读队列接口的读缓冲区大小小于队列消息节点大小</p>
</td>
<td class="cellrowborder" headers="mcps1.1.6.1.5 " width="35.91%" valign="top"><p id="p4713788520034"><a name="p4713788520034"></a><a name="p4713788520034"></a>增加缓冲区大小，或减小队列消息节点大小</p>
</td>
</tr>
</tbody>
</table>

如有错误码更新，参考 [LiteOS内核开发者手册](https://gitee.com/LiteOS/LiteOS/blob/master/doc/LiteOS_Kernel_Developer_Guide.md)