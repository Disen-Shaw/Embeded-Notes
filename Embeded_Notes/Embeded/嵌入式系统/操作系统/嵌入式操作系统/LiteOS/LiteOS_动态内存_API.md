# LiteOS 动态内存 API
动态内存的主要工作是动态分配并管理用户申请到的内存空间  
动态内存管理主要用于用户需要使用大小不等的内存块的场景

当用户需要使用内存时，可以通过操作系统的动态内存申请函数索取指定大小的内存块，一旦使用完毕，通过动态内存释放函数归还所占用内存，使之可以重复使用

## 内存池初始化和删除

| 接口名        | 描述                                                |
| ------------- | --------------------------------------------------- |
| LOS_MemInit   | 初始化一块指定的动态内存池，大小为size              |
| LOS_MemDeInit | 删除指定内存池，仅打开 `LOSCFG_MEM_MUL_POOL` 时有效 | 

## 内存申请和释放
| 接口名            | 描述                                                                                              |
| ----------------- | ------------------------------------------------------------------------------------------------- |
| LOS_MemAlloc      | 从指定动态内存池中申请size长度的内存                                                              |
| LOS_MemFree       | 释放已申请的内存                                                                                  |
| LOS_MemRealloc    | 按size大小重新分配内存块，并将原内存块内容拷贝到新内存块</br>如果新内存块申请成功，则释放原内存块 |
| LOS_MemAllocAlign | 从指定动态内存池中申请长度为size且地址按boundary字节对齐的内存                                                                                                  |

## 内存池信息获取
| 接口名              | 描述                                                                                                                                                                                                              |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| LOS_MemPoolSizeGet  | 获取指定动态内存池的总大小                                                                                                                                                                                        |
| LOS_MemTotalUsedGet | 获取指定动态内存池的总使用量大小                                                                                                                                                                                  |
| LOS_MemInfoGet      | 获取指定内存池的内存结构信息</br>空闲内存大小<br>已使用内存大小<br>空闲内存块数量<br>已使用内存块数量<br>最大空闲块大小                                                                                           |
| LOS_MemPoolList     | 打印系统中已经初始化的所有内存池</br>内存池起始地址</br>内存池大小</br>空闲内存总大小</br>已使用内存大小</br>最大空闲内存块大小</br>空闲内存块数量</br>已使用内存块数量</br>功能在打开 `LOSCFG_MEM_MUL_POOL` 有效 |

## 内存块信息获取
| 接口名               | 描述                                                                                    |
| -------------------- | --------------------------------------------------------------------------------------- |
| LOS_MemFreeBlksGet   | 获取指定内存池的空闲内存块数量                                                          |
| LOS_MemUsedBlksGet   | 获取指定内存池已使用的内存块数量                                                        |
| LOS_MemTaskIdGet     | 获取申请了指定内存块的任务ID                                                            |
| LOS_MemLastUsedGet   | 获取内存池最后一个已使用内存块的结束地址                                                |
| LOS_MemNodeSizeCheck | 获取指定内存块的总大小和可用大小，仅在打开</br>`LOSCFG_BASE_MEM_NODE_SIZE_CHECK` 时有效 |
| LOS_MemFreeNodeShow  | 打印指定内存池的空闲内存块的大小及数量                                                  |

## 内存池的完整性检查
**LOS_MemlntegrityCheck**  
对指定内存池做完整性检查  
仅打开 `LOSCFG_BASE_MEM_NODE_INTEGRITY_CHECK` 有效

## 内存审查级别
该功能只在打开 `LOSCFG_BASE_MEM_NODE_SIZE_CHECK` 时有效  

| 接口名               | 描述             |
| -------------------- | ---------------- |
| LOS_MemCheckLevelSet | 设置内存检查级别 |
| LOS_MemCheckLevelGet | 获取内存检查级别 |

## 模块申请、释放动态内存
该功能只在打开 `LOSCFG_MEM_MUL_MODULE` 时有效

| 接口名             | 描述                                                                                                                          |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| LOS_MemMalloc      | 从指定动态内存池分配                                                                                                          |
| LOS_MemMfree       | 释放已经申请的内存块                                                                                                          |
| LOS_MemMallocAlign | 从指定动态内存池中申请长度为size且</br>地址按 `boundary` 字节对齐的内存给指定模块，并纳入模块统计                             |
| LOS_MemMrealloc    | 按size大小重新分配内存块给指定模块，并将原内存块内容拷贝到新内存块</br>同时纳入模块统计。如果新内存块申请成功，则释放原内存块 |

## 获取指定模块的内存使用量
**LOS_MemMusedGet**  
获取指定模块的内存使用量，仅打开 `LOSCFG_MEM_MUL_MODULE` 时有效

</br>

> 通过红开关控制的都是内存 `调试` 功能的相关接口  
> 
> 对于 bestfit_little 算法  
> + 只支持宏开关 `LOSCFG_MEM_MUL_POOL` 控制的多内存池机制和宏开关
> + `LOSCFG_BASE_MEM_NODE_INTEGRITY_CHECK` 控制的内存合法性检查  
> 不支持其他内存调试功能
> 
> 通过 `LOS_MemAllocAlign/LOS_MemMallocAlign` 申请的内存</br>进行LOS_MemRealloc/LOS_MemMrealloc操作后，不能保障新的内存首地址保持对齐
> 
> 对于 `bestfit_little` 算法，不支持对 `LOS_MemAllocAlign` 申请的内存进行LOS_MemRealloc操作，否则将返回失败。

</br>


## 动态内存内核配置项
| 配置项                                     | 含义                                                                                  | 取值范围 | 默认值                    | 依赖                             |
| ------------------------------------------ | ------------------------------------------------------------------------------------- | -------- | ------------------------- | -------------------------------- |
| LOSCFG_KERNEL_MEM_BESTFIT                  | 选择bestfit管理算法                                                                   | YES/NO   | YES                       | 无                               |
| LOSCFG_KERNEL_MEM_BESTFIT_LITTLE           | 选择bestfit_little管理算法                                                            | YES/NO   | NO                        | 无                               |
| LOSCFG_KERNEL_MEM_SLAB_EXTENTION           | 使能slab功能</br>可以降低系统持续运行过程中内存碎片化的程度                           | YES/NO   | NO                        | 无                               |
| LOSCFG_KERNEL_MEM_SLAB_AUTO_EXPANSION_MODE | slab自动扩展，当分配给slab的内存不足时</br>能够自动从系统内存池中申请新的空间进行扩展 | YES/NO   | NO                        | LOSCFG_KERNEL_MEM_SLAB_EXTENTION |
| LOSCFG_MEM_TASK_STAT                       | 使能任务内存统计                                                                      | YES/NO   | LOSCFG_KERNEL_MEM_BESTFIT |                                  |


[[LiteOS_动态内存_开发流程]]