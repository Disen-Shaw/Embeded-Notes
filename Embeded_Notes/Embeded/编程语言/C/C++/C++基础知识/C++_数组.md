# C++ 数组

一个集合，里面存储着相同数据类型的数据元素

- 数组中每个元素都是 **相同数据类型** 的
- 数组是 **一块连续内存位置存储** 的

## 一维数组

一维数组的几种定义方式

```cpp
Data_type Array_name[length];
Data_type Array_name[length]={data1, data2,...};
Data_type Array_name[]={data1, data2,...}; // 自动推测长度
```

访问数组元素时，[ ] 中的内容叫做 `下标`，通过下标可以直接找到某个数组数据\
下标从 0 开始索引

### 一维数组名

通过数组名，可以

- 统计整个数组在内存中的长度，可以通过 `sizeof` 计算数组占用的内存
- 获取数组在内存中的地址，数组名就是数组的首地址

数组名是常量，不可以对其进行赋值操作

## 二维数组

在一维数组的基础上再建立一个维度，通常以矩阵的形式表示\
二位数组的几种定义方式

```cpp
Data_type Array_name[row][column];
Data_type Array_name[row][column]={{data1,data2},{data3,data4}...};
Data_type Array_name[row][column]={data1,data2,data3,data4...};
Data_type Array_name[][column]={data1,data2,data3,data4...};
```

其中第二种更加直观且常用

### 二位数组名

通过二位数组名，可以

- 查看二位数组所占用的内存空间
- 获取二位数组首地址
