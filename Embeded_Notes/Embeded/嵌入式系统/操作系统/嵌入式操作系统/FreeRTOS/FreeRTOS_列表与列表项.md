# FreeRTOS列表
## 列表与列表项
FreeRTOS的列表和列表项是FreeRTOS的一个数据结构，FreeRTOS大量使用到这个数据结构，它是FreeRTOS的基石。

### 列表
列表是FreeRTOS中的一个数据结构，概念上和链表类似，列表是被用来跟踪FreeRTOS中的任务。
列表结构为`List_t`，在list.h中有定义
```c
typedef struct xLIST
{
	listFIRST_LIST_INTEGRITY_CHECK_VALUE				(1)
	volatile UBaseType_t uxNumberOfItems;				(2)
	ListItem_t * configLIST_VOLATILE pxIndex;			(3)
	MiniListItem_t xListEnd;							(4)
	listSECOND_LIST_INTEGRITY_CHECK_VALUE				(5)
} List_t;
```
1和5都是用来检查列表完整性的，需要将宏`configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES`设置为1，开启以后会向这两个地方分别添加一个变量`xListIntegrityValue1`和`xListIntegrityValue2`，在初始化列表的时候会这两个变量中写入一个特殊的值，**默认不开启这个功能**
+ uxNumberOfItems用来记录列表中**列表项的数量**。
+ pxIndex用来记录**当前列表项索引**，用于遍历列表
+ 列表中最后一个列表项，用来表示列表结束，此变量类型为`MiniListItem_t`，这是一个迷你列表项。

| 列表            |
| :---------------: |
| uxNumberOfItems |
| pxIndex         |
| xListEnd        |


	
### 列表项
列表项就是存放在列表中的项目，FreeRTOS提供了两种列表项：列表项和迷你列表项，两个书经济结构在list.h中都有定义
```c
struct xLIST_ITEM{
	listFIRST_LIST_ITEM_INTEGRITY_CHECK_VALUE				(1)
	configLIST_VOLATILE TickType_txItemValue;				(2)
	struct xLIST_ITEM * configLIST_VOLATILE pxNext; 		(3)
	struct xLIST_ITEM * configLIST_VOLATILE pxPrevious;		(4)
	void *pvOwner;											(5)
	void * configLIST_VOLATILE pvContainer;					(6)
	listSECOND_LIST_ITEM_INTEGRITY_CHECK_VALUE				(7)
};
typedef struct xLIST_ITEM ListItem_t;
```
1和7用来检查列表项的完整性
+ xItemValue为列表项值。
+ pxNext指向下一个列表项
+ pxPrevious指向前一个列表项，和pxNext配合起来实现类似双向链表的功能
+ Owner记录此链表项归谁拥有，**通常是任务控制块**
+ pvContainer用来记录此列表项归哪个列表。

任务控制块中就有两个列表项
+ xStateListItem：状态列表项
+ xEventListItem：事件列表项
当创建一个任务以后xStateListItem的pvOwner变量就指向这个任务的任务控制块，表示xSateListItem属于此任务。
当任务就绪态以后xStateListItem的变量pvContainer就指向就绪列表，表明此列表项在就绪列表中。

|   列表项    |
|:-----------:|
| xItemValue  |
|   pxNext    |
| pxPrevious  |
|   pvOwner   |
| pvContainer |


### 迷你列表项
迷你列表项也在list.h中定义，如下：
```c
struct xMINI_LIST_ITEM{
	listFIRST_LIST_ITEM_INTEGRITY_CHECK_VALUE				(1)
	configLIST_VOLATILE TickType_t xItemValue;				(2)
	struct xLIST_ITEM * configLIST_VOLATILE pxNext;			(3)
	struct xLIST_ITEM * configLIST_VOLATILE pxPrevious;		(4)
};
typedef struct xMINI_LIST_ITEM MiniListItem_t;
```
1还是用语检查迷你列表项的完整性
+ xItemValue记录列表列表项值
+ pxNext指向下一个列表项。
+ pxPrevious指向上一个列表项。

迷你列表项比列表项少了几个成员，有些情况下不需要列表项那么齐全的功能，可能只需要其中的某几个成员变量，如果此时用列表项的话，会造成内存的浪费。

| mini列表项 |
|:----------:|
| xItemValue |
|   pxNext   |
| pxPrevious |

## 相关的API函数

| 函数                          | 描述           |
| ----------------------------- | -------------- |
| vListInitialise()             | 列表初始化     |
| vListInitialiseItem()         | 列表项初始化   |
| vListInsert()                 | 列表项插入     |
| vListInsertEnd()              | 列表项末尾插入 |
| uxListRemove()                | 列表项删除     |
| listGET_OWNER_OF_NEXT_ENTRY() | 列表的遍历     |


### 列表和列表项的初始化
#### 列表初始化
新创建或者定义的列表需要对其做初始化处理，列表的初始化其实就是初始化列表结构体List_t中的各个成员变量，列表的初始化通过使函数`vListInitialise()`来完成，在list.c中有定义。
```c
void vListInitialise( List_t * const pxList ){
	pxList->pxIndex = (ListItem_t *) & (pxList->xListEnd);				(1)
	pxList->xListEnd.xItemValue = portMAX_DELAY;						(2)
	pxList->xListEnd.pxNext = (ListItem_t *) & (pxList->xListEnd);		(3)
	pxList->xListEnd.pxPrevious = (ListItem_t *) & (pxList->xListEnd);	(4)
	pxList->uxNumberOfItems= (UBaseType_t) 0U;							(5)
	listSET_LIST_INTEGRITY_CHECK_1_VALUE( pxList );						(6)
	listSET_LIST_INTEGRITY_CHECK_2_VALUE( pxList );						(7)
};
```
+ ListEnd用来表示列表的末尾，而pxIndex表示列表项的索引，此时列表只有一个列表项，那就是xListEnd，所以pxIndex指向xListEnd。
+ xListEnd的列表项值初始化为portMAX_DELAY，portMAX_DELAY是个宏，在文件portmacro.h中有定义。
	+ 根据所使用的MCU的不同，portMAX_DELAY值也不相同
	+ 16位：0xffff
	+ 32位：0xffffffffUL
+ 初始化列表项xListEnd的pxNext变量，因为此时列表只有一个列表项xListEnd，因此pxNext只能指向自身。
+ 初始化列表项xListEnd的pxPrevious，变量，因为此时列表只有一个列表项xListEnd，因此pxPrevious只能指向自身。
+ 由于此时没有其他的列表项，因此uxNumberOfItems为0**不算xListEnd**
+ 初始化列表项中用于完整性检查字段，只有宏`configUSE_LIST_DATA_INTEGRITY_CHECK_BYTES`为1的时候才有效，同样根据所选的MCU的位数不同也存在差异
	+ 16位：0x5a5a
	+ 32位：0x5a5a5a5aUL

列表初始化之后如下：
![Pasted image 20210714192646](../../../../../pictures/Pasted%20image%2020210714192646.png)
xListEnd的成员变量写出来了，粉色部分为一体

#### 列表项初始化
同列表一样，列表项在使用的时候也需要初始化，列表项初始化由函数`vListInitialiseItem()`来完成，如下:
```c
void vListInitialiseItem( ListItem_t * const pxItem ){
	pxItem->pvContainer = NULL;					//初始化pvContainer为NULL
	
	//初始化用于完整性检查的变量，如果开启了这个功能的话。
	listSET_FIRST_LIST_ITEM_INTEGRITY_CHECK_VALUE( pxItem );
	listSET_SECOND_LIST_ITEM_INTEGRITY_CHECK_VALUE( pxItem );
}

```
列表项初始化只是讲列表项成员变量pvContainer初始化位NULL，并且给用于完整性检查的变量赋值。列表项根据实际的使用情况初始化，比如任务创建函数xTaskCreate()就会对任务堆栈中的`xStateListItem`和`xEventListItem`这两个列表项中的其他成员变量做初始化


#### 列表项插入
列表项的插入操作通过函数`vListInsert()`来完成
函数原型如下
```c
void vListInster(	List_t * const pxList, ListItem_t * const pxNewListItem)
```
参数：
+ pxList：列表项要插入的列表
+ pxNewListItem：要插入的列表项

返回值：
+ 无

根据列表项的value值从小到大插入

#### 列表项末尾插入
列表末尾插入列表项的操作通过函数`vListInsertEnd()`来完成，函数原型如下
```c
void vListInsertEnd(List_t * const pxList, ListItem_t * const pxNewListItem);
```
参数：
+ pxList：列表项要插入的列表。
+ pxNewListItem：要插入的列表项。

返回值：
+ 无

#### 列表项的删除
列表项的删除通过函数uxListRemove()来完成，函数原型如下：
```c
UBaseType_t uxListRemove(ListItem_t * const pxItemToRemove);
```
参数：
+ pxItemToRemove:要删除的列表项。

返回值：
+ 返回删除列表项以后的列表剩余列表项数目
+ 如果这个列表项是动态分配内存的话，列表项的删除只是将指定的列表项从列表中删除掉，并不会将这个列表项的内存给释放掉！

#### 列表的遍历
列表List_t中的成员变量pxIndex是用来遍历列表的。
FreeRTOS提供了一个函数来完成列表的遍历，这个函数是`listGET_OWNER_OF_NEXT_ENTRY()`。
每调用一次这个函数列表的pxIndex变量就会指向下一个列表项，并且返回这个列表项的pxOwner变量值。
该函数本质上是一个宏，这个宏在文件list.h中定义
