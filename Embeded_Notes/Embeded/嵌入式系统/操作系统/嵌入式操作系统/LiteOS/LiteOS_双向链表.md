# LiteOS 双向链表
## 基本概念
双向链表是指含有往前和往后两个方向的链表，即每个结点中除存放下一个节点指针外，还增加一个指向前一个节点的指针。其头指针head是唯一确定的。

从双向链表中的任意一个结点开始，都可以很方便地访问它的前驱结点和后继结点，这种数据结构形式使得双向链表在查找时更加方便，特别是大量数据的遍历。由于双向链表具有对称性，能方便地完成各种插入、删除等操作，但需要注意前后方向的操作。

## APIs
<table>
	<thead align="left"><tr id="row24909577162710"><th class="cellrowborder" id="mcps1.1.4.1.1" width="20.84%" valign="top"><p id="p4409895162710"><a name="p4409895162710"></a><a name="p4409895162710"></a>功能分类</p>
</th>
<th class="cellrowborder" id="mcps1.1.4.1.2" width="21.88%" valign="top"><p id="p21657225162710"><a name="p21657225162710"></a><a name="p21657225162710"></a>接口名</p>
</th>
<th class="cellrowborder" id="mcps1.1.4.1.3" width="57.28%" valign="top"><p id="p9404824162710"><a name="p9404824162710"></a><a name="p9404824162710"></a>描述</p>
</th>
</tr>
</thead>
<tbody><tr id="row3332575162537"><td class="cellrowborder" rowspan="2" headers="mcps1.1.4.1.1 " width="20.84%" valign="top"><p id="p1503143162537"><a name="p1503143162537"></a><a name="p1503143162537"></a>初始化链表</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="21.88%" valign="top"><p id="p54645735162537"><a name="p54645735162537"></a><a name="p54645735162537"></a>LOS_ListInit</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="57.28%" valign="top"><p id="p64228424162537"><a name="p64228424162537"></a><a name="p64228424162537"></a>将指定节点初始化为双向链表节点</p>
</td>
</tr>
<tr id="row63311156131410"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p833117569148"><a name="p833117569148"></a><a name="p833117569148"></a>LOS_DL_LIST_HEAD</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p833111569142"><a name="p833111569142"></a><a name="p833111569142"></a>定义一个节点并初始化为双向链表节点</p>
</td>
</tr>
<tr id="row23593275162710"><td class="cellrowborder" rowspan="3" headers="mcps1.1.4.1.1 " width="20.84%" valign="top"><p id="p20608486161731"><a name="p20608486161731"></a><a name="p20608486161731"></a>增加节点</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="21.88%" valign="top"><p id="p42440799162710"><a name="p42440799162710"></a><a name="p42440799162710"></a>LOS_ListAdd</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="57.28%" valign="top"><p id="p15152688162710"><a name="p15152688162710"></a><a name="p15152688162710"></a>将指定节点插入到双向链表头端</p>
</td>
</tr>
<tr id="row56015283114519"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p28138252114519"><a name="p28138252114519"></a><a name="p28138252114519"></a>LOS_ListHeadInsert</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p64605955114519"><a name="p64605955114519"></a><a name="p64605955114519"></a>将指定节点插入到双向链表头端，同LOS_ListAdd</p>
</td>
</tr>
<tr id="row9935195212551"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p55702669162710"><a name="p55702669162710"></a><a name="p55702669162710"></a>LOS_ListTailInsert</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p15622373162710"><a name="p15622373162710"></a><a name="p15622373162710"></a>将指定节点插入到双向链表尾端</p>
</td>
</tr>
<tr id="row448985511526"><td class="cellrowborder" rowspan="2" headers="mcps1.1.4.1.1 " width="20.84%" valign="top"><p id="p49686117162150"><a name="p49686117162150"></a><a name="p49686117162150"></a>删除节点</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="21.88%" valign="top"><p id="p6426197611526"><a name="p6426197611526"></a><a name="p6426197611526"></a>LOS_ListDelete</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="57.28%" valign="top"><p id="p52712195115237"><a name="p52712195115237"></a><a name="p52712195115237"></a>将指定节点从链表中删除</p>
</td>
</tr>
<tr id="row1023610324012"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p307431620736"><a name="p307431620736"></a><a name="p307431620736"></a>LOS_ListDelInit</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p2658453620736"><a name="p2658453620736"></a><a name="p2658453620736"></a>将指定节点从链表中删除，并使用该节点初始化链表</p>
</td>
</tr>
<tr id="row20058016115551"><td class="cellrowborder" headers="mcps1.1.4.1.1 " width="20.84%" valign="top"><p id="p14086595115551"><a name="p14086595115551"></a><a name="p14086595115551"></a>判断双向链表是否为空</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="21.88%" valign="top"><p id="p163555115551"><a name="p163555115551"></a><a name="p163555115551"></a>LOS_ListEmpty</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="57.28%" valign="top"><p id="p13247975115551"><a name="p13247975115551"></a><a name="p13247975115551"></a>判断链表是否为空</p>
</td>
</tr>
<tr id="row247318308166"><td class="cellrowborder" rowspan="2" headers="mcps1.1.4.1.1 " width="20.84%" valign="top"><p id="p1547433061614"><a name="p1547433061614"></a><a name="p1547433061614"></a>获取节点</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="21.88%" valign="top"><p id="p147463071610"><a name="p147463071610"></a><a name="p147463071610"></a>LOS_DL_LIST_LAST</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="57.28%" valign="top"><p id="p11474330171618"><a name="p11474330171618"></a><a name="p11474330171618"></a>获取指定节点的前驱结点</p>
</td>
</tr>
<tr id="row8121720112211"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p14121172052216"><a name="p14121172052216"></a><a name="p14121172052216"></a>LOS_DL_LIST_FIRST</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p26938427224"><a name="p26938427224"></a><a name="p26938427224"></a>获取指定节点的后继结点</p>
</td>
</tr>
<tr id="row4549184416612"><td class="cellrowborder" rowspan="2" headers="mcps1.1.4.1.1 " width="20.84%" valign="top"><p id="p354934420619"><a name="p354934420619"></a><a name="p354934420619"></a>获取结构体信息</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="21.88%" valign="top"><p id="p135494441562"><a name="p135494441562"></a><a name="p135494441562"></a>LOS_DL_LIST_ENTRY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="57.28%" valign="top"><p id="p1764811219106"><a name="p1764811219106"></a><a name="p1764811219106"></a>获取包含链表的结构体地址，接口的第一个入参表示的是链表中的某个节点，第二个入参是要获取的结构体名称，第三个入参是链表在该结构体中的名称</p>
</td>
</tr>
<tr id="row15765744192214"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p5765124418226"><a name="p5765124418226"></a><a name="p5765124418226"></a>LOS_OFF_SET_OF</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p67652044152220"><a name="p67652044152220"></a><a name="p67652044152220"></a>获取指定结构体内的成员相对于结构体起始地址的偏移量</p>
</td>
</tr>
<tr id="row16797171711230"><td class="cellrowborder" rowspan="2" headers="mcps1.1.4.1.1 " width="20.84%" valign="top"><p id="p3797151712318"><a name="p3797151712318"></a><a name="p3797151712318"></a>遍历双向链表</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="21.88%" valign="top"><p id="p10797141711235"><a name="p10797141711235"></a><a name="p10797141711235"></a>LOS_DL_LIST_FOR_EACH</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="57.28%" valign="top"><p id="p157971517122317"><a name="p157971517122317"></a><a name="p157971517122317"></a>遍历双向链表</p>
</td>
</tr>
<tr id="row163687110268"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p153686172620"><a name="p153686172620"></a><a name="p153686172620"></a>LOS_DL_LIST_FOR_EACH_SAFE</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p236812162616"><a name="p236812162616"></a><a name="p236812162616"></a>遍历双向链表，并存储当前节点的后继节点用于安全校验</p>
</td>
</tr>
<tr id="row522163914275"><td class="cellrowborder" rowspan="3" headers="mcps1.1.4.1.1 " width="20.84%" valign="top"><p id="p9221183932712"><a name="p9221183932712"></a><a name="p9221183932712"></a>遍历包含双向链表的结构体</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="21.88%" valign="top"><p id="p422114390274"><a name="p422114390274"></a><a name="p422114390274"></a>LOS_DL_LIST_FOR_EACH_ENTRY</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="57.28%" valign="top"><p id="p322153910274"><a name="p322153910274"></a><a name="p322153910274"></a>遍历指定双向链表，获取包含该链表节点的结构体地址</p>
</td>
</tr>
<tr id="row1433317199289"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p933319196285"><a name="p933319196285"></a><a name="p933319196285"></a>LOS_DL_LIST_FOR_EACH_ENTRY_SAFE</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p1833341992818"><a name="p1833341992818"></a><a name="p1833341992818"></a>遍历指定双向链表，获取包含该链表节点的结构体地址，并存储包含当前节点的后继节点的结构体地址</p>
</td>
</tr>
<tr id="row27341222192815"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p3734222162811"><a name="p3734222162811"></a><a name="p3734222162811"></a>LOS_DL_LIST_FOR_EACH_ENTRY_HOOK</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p12734722182811"><a name="p12734722182811"></a><a name="p12734722182811"></a>遍历指定双向链表，获取包含该链表节点的结构体地址，并在每次循环中调用钩子函数</p>
</td>
</tr>
</tbody>
</table>

## 开发流程
双向链表的典型开发流程
1.  调用LOS_ListInit/LOS_DL_LIST_HEAD初始双向链表
2.  调用LOS_ListAdd/LOS_ListHeadInsert向链表头部插入节点
3.  调用LOS_ListTailInsert向链表尾部插入节点
4.  调用LOS_ListDelete删除指定节点
5.  调用LOS_ListEmpty判断链表是否为空
6.  调用LOS_ListDelInit删除指定节点并以此节点初始化链表

## 注意事项
-   需要注意节点指针前后方向的操作
-   链表操作接口，为底层接口，不对入参进行判空，需要使用者确保传参合法
-   如果链表节点的内存是动态申请的，删除节点时，要注意释放内存

