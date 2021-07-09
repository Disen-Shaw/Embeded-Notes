# Internet结构
## Internet基本介绍
**Internet是网络的网络**
端系统通过**接入ISP(access ISPs)**连接到Internet
+ 家庭、大公司大学ISPs

接入ISP必须进一步互联
+ 任意两个主机可以互相发送分组

构成负责的网络互联的网络
+ 经济和国家政策是网络演化的主要驱动力

当前的Internet结构
+ 无人能精准描述

## Internet实现
**Internet数以百万计的接入ISP**两两互联
直接互联不适用大规模的网络：连接问题导致成本上升

将每个接入ISP连接到一个国家或全球ISP(Global ISP)
![[Pasted image 20210503011202.png]]
但是从商业角度，ISP必定有竞争者
这些ISP网络必须互联

![[Pasted image 20210503011547.png]]
有几种解决办法
1. 建立对等链路
2. 引入第三方IXP互联网交换节点
3. 区域ISP

内容提供商可能运行其自己的网络、并就近为端客户提供服务、内容

### Intelnet结构
![[Pasted image 20210503011737.png]]

#### 网络中心：少数互联的大型网络
+ “一级”商业ISP(如网通、电信等)，提供国家或国际范围的覆盖
+ 内容提供商网络(如Google)：私有网络，链接其数据中心与Internet，通常绕过一级ISP和区域ISPs










