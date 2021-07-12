# uCOSIII事件标志组
## 事件标志组
有时候一个任务需要与多个事件同步，这个时候就需要使用事件标志组。事件标志组与任务之间有两种同步机制："`或`"同步和"`与`"同步。
+ `"或"`同步：等待多个事件时，任务一个事件发生，任务都被同步，这个就称为`"或"`同步
+ "`与`"同步：当所有事件都发生时任务才被同步，这种同步机制被称为"`与`"同步

在uCOSIII中事件标志组为`OS_FLAG_GRP`，如果需要使用事件标志组的时候需要将宏`OS_CFG_FLAG_EN`置为1

### 事件标志组
事件标志组定义在os.h文件，定义如下：
```c
struct os_flag_grp{
	OS_OBJ_TYPE		Type;
	CPU_CHAR		*NamePtr;
	PS_PEND_LIST	PendList;
#if OS_CFG_DBG_EN > 0U
	OS_FLAH_GRP		*DbgPrevPtr;
	OS_FLAH_GRP		*DbgNextPtr;
	CPU_CHAR		*DbgNamePtr;
#endif
OS_FLAGS			Flags;
CPU_TS				TS;
}; 
```
Flag为32位数据，一个bit代表一个事件，哪个事件代表哪个bit由用户决定

### 事件标志组API函数
| 函数名                  | 作用                      |
| ----------------------- | ------------------------- |
| **OSFlagCreate()**      | **创建事件标志组**        |
| OSFlagDel()             | 删除事件标志组            |
| **OSFlagPend()**        | **等待事件标志组**        |
| OSFlagPendAbort()       | 取消等待事件标志组        |
| OSFlagPendGetFlagsRdy() | 获取使任务buxus的事件标志 |
| **OSFlagPost()**        | **向事件标志组发布标志**                          |

