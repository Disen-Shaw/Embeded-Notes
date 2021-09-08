# LiteOS 位操作
## 基本概念
位操作是指对二进制数的bit位进行操作  
程序可以设置某一变量为状态字，状态字中的每一bit位（标志位）可以具有自定义的含义

## APIs
系统提供标志位的置1和清0操作，可以改变标志位的内容  
同时还提供获取状态字中标志位为1的最高位和最低位的功能  
用户也可以对系统的寄存器进行位操作

<table>
	<thead align="left"><tr id="row61966233115614"><th class="cellrowborder" id="mcps1.1.4.1.1" width="23.87238723872387%" valign="top"><p id="p9118648115614"><a name="p9118648115614"></a><a name="p9118648115614"></a>功能分类</p>
</th>
<th class="cellrowborder" id="mcps1.1.4.1.2" width="22.94229422942294%" valign="top"><p id="p413017115614"><a name="p413017115614"></a><a name="p413017115614"></a>接口名</p>
</th>
<th class="cellrowborder" id="mcps1.1.4.1.3" width="53.185318531853184%" valign="top"><p id="p33454382115614"><a name="p33454382115614"></a><a name="p33454382115614"></a>描述</p>
</th>
</tr>
</thead>
<tbody><tr id="row32653983115614"><td class="cellrowborder" rowspan="2" headers="mcps1.1.4.1.1 " width="23.87238723872387%" valign="top"><p id="p27727006115614"><a name="p27727006115614"></a><a name="p27727006115614"></a>置1/清0标志位</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="22.94229422942294%" valign="top"><p id="p6665151352510"><a name="p6665151352510"></a><a name="p6665151352510"></a>LOS_BitmapSet</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="53.185318531853184%" valign="top"><p id="p51870782115614"><a name="p51870782115614"></a><a name="p51870782115614"></a>对状态字的某一标志位进行置1操作</p>
</td>
</tr>
<tr id="row64183855115614"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p2156603115614"><a name="p2156603115614"></a><a name="p2156603115614"></a>LOS_BitmapClr</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p40467168115614"><a name="p40467168115614"></a><a name="p40467168115614"></a>对状态字的某一标志位进行清0操作</p>
</td>
</tr>
<tr id="row28660194115614"><td class="cellrowborder" rowspan="2" headers="mcps1.1.4.1.1 " width="23.87238723872387%" valign="top"><p id="p39774405115614"><a name="p39774405115614"></a><a name="p39774405115614"></a>获取标志位为1的bit位</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " width="22.94229422942294%" valign="top"><p id="p501352115614"><a name="p501352115614"></a><a name="p501352115614"></a>LOS_HighBitGet</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.3 " width="53.185318531853184%" valign="top"><p id="p40609523115614"><a name="p40609523115614"></a><a name="p40609523115614"></a>获取状态字中为1的最高位</p>
</td>
</tr>
<tr id="row29941391115614"><td class="cellrowborder" headers="mcps1.1.4.1.1 " valign="top"><p id="p17827586115614"><a name="p17827586115614"></a><a name="p17827586115614"></a>LOS_LowBitGet</p>
</td>
<td class="cellrowborder" headers="mcps1.1.4.1.2 " valign="top"><p id="p34748382115614"><a name="p34748382115614"></a><a name="p34748382115614"></a>获取状态字中为1的最低位</p>
</td>
</tr>
</tbody>
</table>
