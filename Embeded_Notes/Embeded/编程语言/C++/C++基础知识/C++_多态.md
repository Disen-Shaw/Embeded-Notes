# C++ 多态
## 多态的基本概念
### 多态的基本介绍
多态时C++面向对象三大特性之一
多态分为两类：
+ 静态多态：**函数重载**和**运算符重载**属于静态多态，复用函数名
+ 动态多态：派生类和虚函数实现运行时多态

区分：
+ 静态多态的**函数地址早绑定** - **编译阶段**确定函数地址
+ 动态多态的**函数地址晚绑定** - **运行阶段**确定函数地址

`C++中允许类父子之间的类型转换`

virtual void xxx();虚函数
~~~c
class Animal{
public:
    virtual void func()
    {
        cout<<"Animal"<<endl;
    }
};
class Cat:public Animal{
public:
    void func()
    {
        cout<<"Cat"<<endl;
    }
};
void doSpake(Animal &animal)
{
    animal.func();
}
~~~
在父类成员函数中没有给定类的地址，在子类中调用函数会根据传入参数(子类或者父类)的值来调用相应的成员函数

满足动态多态的条件：
+ 满足继承关系
+ 子类要重写父类的虚函数
	+ **函数的返回值相同**
	+ **函数的名相同**
	+ **函数传参列表相同**
+ 子类的virtual可写可不写

### 动态多态的实用
**父类的指针或者引用**指向**子类对象**
+ void doSpake(Animal &animal) 

## **多态底层原理**
### **虚函数**与**虚函数指针**基本概念
**vfptr**:虚函数(表)指针
+ v：virtual
+ f：function
+ ptr：pointer

**vfable**：虚函数表
+ v：virtual
+ f：function
+ table：table

![[Pasted image 20210408160225.png]]

![[Pasted image 20210408160335.png]]
如果发生重写，子类会把虚函数表内部进行覆盖
当父类的指针或者引用指向子类对象时，发生多态
指针类型自动转移成子类
~~~c++
Animal &animal = cat;
animal.speak();
~~~

## 多态优点
代码组织结构清晰，出错可以定位到
可读性强
利于前期和后期的拓展和维护

如果想扩展新功能，需要修源码
在真实开发中 提倡 开闭原则
开闭原则：
对扩展进行开发，对修改进行关闭

### 简易计算器多态实现
利用多态来完成加减乘除等操作
~~~c++
class calculator_base{
public:
    double m_First;
    double m_Second;
    virtual double fun()
    {
        return 0;
    }
};
class calculator_add:public calculator_base{
public:
    double fun()
    {
        return m_First+m_Second;
    }
};
class calculator_sub:public calculator_base{
public:    
    double fun()
    {
        return m_First-m_Second;
    }
};
class calculator_x:public calculator_base{
public:
    double fun()
    {
        return m_First*m_Second;
    }
};
class calculator_chu:public calculator_base{
public:    
    double fun()
    {
        return m_First/m_Second;
    }
};

int main(void)
{
    calculator_add *p = new calculator_add();
    p->m_First = 3.14;
    p->m_Second = 12.56;
    std::cout<<p->fun()<<std::endl;
    delete p;
}

~~~



## 纯虚函数和抽象类
抽象类：abstract
在多态中，通常父类中的虚函数的实现时无意义的，主要都是调用子类重写的函数
因此可以将虚函数改为纯虚函数

纯虚函数写法：
~~~c++
virtual 返回值类型 函数名 (参数列表) = 0；
~~~
当类中有纯虚函数时，这个类也被称为抽象类

### 抽象类特点
+ **无法实例化对象**
+ **子类必须重写抽象类中的纯虚函数，否则也属于抽象类**

~~~c++
class calculator_base{
public:
    double m_First;
    double m_Second;
    virtual double fun() = 0;
};
class calculator_add:public calculator_base{
public:
    double fun()
    {
        return m_First+m_Second;
    }
};
class calculator_sub:public calculator_base{
public:    
    double fun()
    {
        return m_First-m_Second;
    }
};
class calculator_x:public calculator_base{
public:
    double fun()
    {
        return m_First*m_Second;
    }
};

class calculator_chu:public calculator_base{
public:    
    double fun()
    {
        return m_First/m_Second;
    }
};
~~~

多态——一个接口，多种形态

## 虚析构函数和纯虚析构函数
多态使用时，如果子类中有属性开辟到堆区，那么父类指针在释放时无法调用到子类的析构代码
解决方式：
将父类中的**析构函数**改为**纯虚析构函数**

虚析构函数和纯析构函数共性：
+ **解决父类指针释放子对象**
+ **都需要有具体的函数实现**

虚析构和纯析构区别：
+ 纯析构属于抽象类，无法实例化对象

**虚析构语法**
~~~c++
virtual ~类名(){}
~~~
**纯虚析构函数语法**
~~~c++
virtual ~类名() = 0;
~~~

 
### 总结
虚析构函数和纯虚析构函数都是用来解决**父类指针释放子类对象**
如果子类中没有堆区数据，可以不写为虚析构或者纯虚析构函数
拥有纯虚析构函数的类也属于抽象类



## 多态小练习
~~~c++
#include <iostream>
using namespace std;
/* *************************************************** */
class CPU
{
public:
    virtual void cpu_work() = 0;
};
class Board
{
public:
    virtual void borad_work() = 0;
};
class Computer
{
private:
    CPU *cpu;
    Board *board;

public:
    Computer(CPU *cpu_var, Board *board_var)
    {
        cpu = cpu_var;
        board = board_var;
    }
    void work()	// 多态
    {
        cpu->cpu_work();
        board->borad_work();
    }
    ~Computer()
    {
        if (cpu != NULL)
        {
            delete (cpu);
            cpu = NULL;
        }
        if (board != NULL)
        {
            delete (board);
            board = NULL;
        }
    }
};
/* *************************************************** */
class Intel_CPU : public CPU
{
    void cpu_work()
    {
        cout << "Intel CPU Working!" << endl;
    }
};
class Intel_Board : public Board
{
    void borad_work()
    {
        cout << "Intel Board Working!" << endl;
    }
};

int main(void)
{
    CPU *intel_cpu = new Intel_CPU();
    Board *intel_board = new Intel_Board();
    Computer *computer = new Computer(intel_cpu, intel_board);
    computer->work();
}

~~~
 











