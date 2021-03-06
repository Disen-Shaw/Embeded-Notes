# C语言补充
## 浮点型相关
### 浮点型控制小数输出位数
通过iomanip头文件中的setprecisoon(n)控制输出位数
或者通过setiosplags(ios::fixed)固定小数位数
```c++
#include<iostream>
#include<iomanip>
using namespace std;
int main()
{
    double a=3.14159265358;                    
    cout<<a<<endl;                        //默认  输出为3.14159
    
    //加入setprecision(n)  设置浮点数有效数字 
    cout<<setprecision(3)<<a<<endl;        //将精度改为3（即有效数字三位） 输出3.14                        
    cout<<setprecision(10)<<a<<endl;    //将精度改为10  输出3.141592654 
    
    //加入setiosflags(ios::fixed)   设置浮点数以固定的小数位数显示
    cout<<setiosflags(ios::fixed)<<setprecision(2)<<a<<endl;    
    //控制精度为小数位  setprecision(3)即保留小数点2位    输出3.14 
    cout<<a<<endl;                //fixed和setprecision的作用还在，依然显示3.14
            
    return 0;
}
```
### 判断输入是否为浮点型
```c++
double arr;
cin >> arr;
if(cin.fail()){
	// 失败处理
}

```

## new操作符

C++中利用new在堆区开辟数据

堆区开辟的数据，有程序猿手动开辟手动释放
释放用操作符delete

~~~c++
new 数据类型
// 会返回改数据对应的类型指针
~~~

**malloc()和free()是C语言中的库函数**[[../../C语言/c语言内存管理]]
**new和delete是C++中的操作符，占用内存相对较少**

在堆区开辟数组

~~~c++
int *p = new int[10];
// 返回数组的首地址
// 释放数组要加[]
~~~

## 引用

### 引用的基本使用

用于给变量起别名，都是指向同一块内存
类似于没有*的指针,静态指针？？？

**引用占用的内存和值传递一样，但是指针无论什么数据都是4个字节或者8个字节**

~~~c++
数据类型 &别名 = 原名;
// 数据类型要和原数据类型一致
~~~

### 使用注意事项

+ 引用必须初始化
+ 初始化后不可以改变

### 引用做函数参数

函数传参时，可以利用引用的技术让形参修饰实参
可以简化指针修饰实参

~~~c++
// 交换函数
void swap(int &a, int &b)
{
    int temp;
    temp = b;
    b = a;
    a = temp;
}

int main(void)
{
    int a = 10;
    int b = 20;
    swap(a, b);
    cout << "a=" << a << endl;
    cout << "b=" << b << endl;
}
~~~

### 引用做函数的返回值

**不可返回局部变量引用**
用法：函数调用作为左值

~~~c++
// 错误用法
int &fun(void)
{
    int a = 10;
    /* 返回引用 */
    return a;
}
int main(void)
{
    int &p = fun();
    cout << p << endl;
}
// 函数中的a存在于栈区，函数结束后就会被消灭

// 正确用法
int &fun(void)
{
    static int a = 10;
    /* 返回引用 */
    return a;
}
int main(void)
{
    int &p = fun();
    cout<<p<<endl;
}
// 使用static修饰，变量存在于全局区，直到程序结束才会被消灭，因此可以将其引用
// 采用这个方法可以在函数外修改函数的静态变量
	fun() = 1000;
// 静态变量a变成1000
~~~

**如果函数的返回值是一个引用，那么这个函数的调用可以作为左值**

### 引用的本质

引用的本质在C++内部实现是一个指针常量[[../../C语言/C语言指针]]

 变量类型 *const 变量名

~~~c++
int &ref = a;
// 编译器直接转化为
int *const ref = &a;
~~~

 ### 常量引用

作用：用于修饰形参，防止误操作
在函数形参列表中，可以加const修饰形参，方式形参改变实参

相当于两个const修饰的指针

~~~c++
void showValue(const int &val)
{
    // val = 1000;
    // 不可以修改
    cout << "val=" << val <<endl;
}
~~~

## 函数提高
参考[[../../C语言/C语言函数]]，对其补充

### 函数的默认参数

在C++中，函数可以有默认参数

~~~c++
int func(int a,int b = 10,int c = 10)
{
    return (a+b+c);
}
~~~

+ 如果某个位置有了默认参数，那么从这以后都要有默认值
+ 如果函数声明由默认参数，函数实现就不鞥由默认参数

### 函数占位参数

C++中函数的形参列表里可以有站位参数用来占位，调用函数时必须填补该位置

占个位置，方便以后该接口，不影响编译

~~~c++
返回值类型 函数名(数据类型){}
~~~

示例：

~~~c++
void fun(int a,int)
{
    cout<<a<<endl;
}
int main(void)
{
    fun(12,2);
}
// 占位参数可以有默认值
void fun(int a,int = 10)
{
    cout<<a<<endl;
}
~~~

### 函数重载

函数名可以相同，提高复用性

函数重载满足的条件：

+ 同一个作用域下
+ 函数名称相同
+ 函数参数**类型不同**或者**个数不同****或者**顺序不同**

**函数的返回值不可以作为函数冲在的条件**

~~~c++
void fun()
{
    cout<<"hello,world!"<<endl;
}
void fun(int a)
{
    cout<<a<<endl;
}
// 参数不同
~~~

函数重载问题：

引用做为重载条件

~~~c++
void fun(int &a)
{
    cout<<"函数fun(int &a)调用"<<endl;
}
void fun(const int &a)
{
    cout<<"函数fun(const int &a)调用"			<<endl;
}

~~~



当函数重载碰到默认参数，会出现二义性问题

~~~c++
void fun(int a,int b = 10)
{
    cout<<"函数fun(int a,int b = 10)调用"
        <<endl;
}
void fun(int a)
{
    cout<<"函数fun(int a)调用"<<endl;
}
// 二义性
~~~

