### 类和对象
C++面向对象三大特性：封装、继承和多态

C++认为万事万物都为对象，对象有其属性和行为

### 封装

#### 封装的意义

+ 将属性和行为作为一个整体，表现生活中的事物
+ 将属性和行为加以权限控制

封装的意义

1. 在设计类的时候，属性和行为写在一起，表现事物

~~~c++
class 类名{
    访问权限:
    属性/行为;
}
~~~

+ 类中的属性和行为统一称为成员
+ 属性：成员属性、成员变量
+ 行为：成员函数、成员方法

2. 类在设计师，可以吧属性和行为放在不同的权限下加以控制

   访问权限有三种：

   + public：公共权限

     成员类内外都可以访问

   + protected：保护权限

     只可以类内访问

   + private：私有权限

     只可以类内访问

   protected 和 private 区别在于继承方面的问题

   protected权限子类也可以访问，

   private权限子类无法访问

#### struct和class的区别

默认的访问权限不同

+ struct：默认为共有权限
+ class：默认为私有

#### 将成员属性设置为私有

优点：

1. 将所有的成员设置为私有，可以**自己控制读写权限**
2. 对于写权限，**可以检测数据的有效性**

在类中可以将另一个类作为成员

#### 多文件C++编程

在.h文件中

+ 类的声明
+ 类的方法的声明
+ 包含相应的头文件
 
在.c文件中

+ 类的方法的实现

~~~c++
返回类型 类名::函数名()
{
    // 实 现
}
~~~

#### 对象的初始化和清理

构造函数和析构函数

对象的**初始化和清理**是两个非常重要的问题

同样的使用完一个对象或者变量，没有及时清理也会造成一定的安全问题

+ 构造函数

  作用在创建对象时为对象属性赋值，构造函数由编译器自动调用，无需手动调用
  可以有参数，因此可以发生重载

+ 析构函数

  析构函数没有参数，不可以发生重载

  作用在对象销毁前系统自动调用，执行一些清理工作

若没有定义，编译器提供的构造函数和析构函数是空实现

~~~c++
class Student{
private:
	string name;
    int age;
    // 构造函数
    Student();
    // 析构函数
    ~Student();
}
Student::Student()
{
    // 构造方法
}
Student::~Student()
{
    // 析构方法
}
~~~

#### 构造函数的分类和调用

两种分类方式

1. 按参数分类
   + 有参数构造函数
   + 无参数构造函数
2. 按类型分类
   + 普通构造函数
   + 拷贝构造函数

~~~c++
// 拷贝构造函数
// 将传入人身上的所有属性拷贝到所构造身上
Test(const Test &p)
{
    
}
~~~

三种调用方式

+ 括号法

  调用默认构造函数时，不要加括号，编译器可能会认为是一个函数的声明

~~~c++
Test test1;
Test test2();
~~~

+ 显示法

  不要利用拷贝构造函数来初始化匿名对象

~~~c++
Test test1;
Test test2 = Test();
// 匿名对象
// 执行结束后直接被删除(当场去世)
Test(10);
~~~

+ 隐式转换法

~~~c++
Test test1 = 10;
// 相当于直接是 Test test1 = Test(10);
~~~

 #### 拷贝构造函数调用时机

C++中拷贝构造函数调用通常分三种情景

+ 使用一个已创建的对象来初始化另一个对象
+ 值传递的方式给函数传值
+ 以值方式返回局部变量   

#### 构造函数的调用规则

默认情况下，C++编译器至少给一个类添加3个函数

1. 默认构造函数(空实现)
2. 默认析构函数(空实现)
3. 默认拷贝构造函数

#### 深拷贝与浅拷贝

浅拷贝

简单的赋值拷贝操作

如果利用编译器提供的**拷贝构造函数**，会做浅拷贝操作

带来的问题：

可能造成堆区的内存重复释放

利用深拷贝解决问题

在堆区中重新申请空间，进行拷贝操作

~~~c++
Person(const Person &p)
{
    // 普通成员
    m_age = p.m_age;
	// 堆区成员
    // 深拷贝操作
    m_Height = new int(*p.m_Height);
}
~~~
#### 初始化列表
C++提供初始化列表语法，用来初始化属性，简化了代码
语法：构造函数():属性1(值1),属性2(值2),...{}
~~~c++
class Persion{
public：
	int a;
	int b;
	int c;
	// 初始化列表用于初始化属性
	Persion():a(10),b(20),c(30)
	{
		// 构造函数体
		// 不可以在类外定义使用
	}
};
~~~
#### 类对象作为类成员
C++类中的成员可以是另一个类的对象，称之为对象成员
~~~c++
// 例如
class A{};
class B{
	A a;
	int b;
};
~~~
当创建对象B时，A的构造函数先被调用
构造对象时先构造其他类的对象，再构造自身
析构函数相反，反应的是栈的特性？不是，在堆中定义也如此

c++中，成员变量和成员函数是分开存储的，每个非静态成员只会诞生一份函数实例，多个同类型对象会公用一块代码

#### this与this指针
C++通过提供特殊的对象指针，this指针，解决了多个同类型对象公用一块代码时进行自调用的问题，this指针只想背调用的成员函数所属的对象
**this指针时银汉每一个非静态成员函数内的一种指针**，并且无需定义

**用途：**
+ 当形参和成员变量同名时，可以用this指针来区分
+ 在类的非静态成员函数中返回对象本身，可以使用return \*this

链式编程思想
~~~c++
Person{
public:
	int age;
	Persion(int age){
		this->age = age;
	}
	Person& PersonAddAge(Person &p)
	{
		this->age+=p->age;
		return *this;
	}
}

void test()
{
	Persion p1(10);
	Persion p2(10);
	// 链式编程思想
	p2.PersonAddAge(p1).PersonAddAge(p1).PersonAddAge(p1);
	// 加了三次
}
~~~

#### 空指针访问成员函数
C++中空指针可以调用成员函数，但是要注意有没有用到this指针
如果用到了this指针，需要加以判断来保证代码的健壮性

传入的指针是空，访问类成员时会崩，非法访问空指针NULL

#### const修饰成员函数
常函数：
+ 成员函数加const后称之为常函数
+ 常函数内不得修改成员属性
+ 成员属性声明时加关键字mutable后，在常函数中依然可以修改

常对象：
+ 声明对象前加const
+ 常对象只能调用常函数

this指针的本质是指针常亮 指针的指向时不可以修改的
this指针不可以修改指针的指向，但是可以修改它指向的值
~~~c++
void showPerson() const {}
等同于
const Person * const this
~~~

mutable 修饰的成员属性在常函数和常变量中可以修改


### 友元
在程序里，有些私有属性也想让类外特殊的一些函数或者类进行访问，这时需要用到友元技术
友元让一个函数或者类访问另一个类中私有成员
关键字 friend
#### 友元的三种实现
+ 全局函数做友元
+ 类做友元
+ 成员函数做友元

##### 全局函数做友元
~~~c++
// 类定义
class Building
{

	friend void test01(Building *building);
private:
 	std::string m_BedRoom;
public:
 	std::string m_SittingRoom;
 	Building() {
 	std::cout<<"BedRoom is : keting"<<std::endl;
 	std::cout<<"SittingRoom is : woshi"<<std::endl;
 	m_SittingRoom = "keting";
 	m_BedRoom = "woshi";
 	std::puts(" ");
	}
};

// 全局友元函数
  

void test01(Building \*building)

{

 std::cout<<"visiting SittingRoom :\t" \
 		  << building->m_SittingRoom <<std::endl;
 std::cout<<"visiting BedRoom :\t" \
 		  << building->m_BedRoom <<std::endl;
}

~~~

##### 类做友元
~~~c++
// 被访问类
class Building
{
 	friend class good;
private:
 	string m\_Bedroom;
public:
	string m\_SittingRoom;
	Building(string sittingroom,string bedroom):m\_Bedroom(bedroom),m\_SittingRoom(sittingroom){}
};

// 访问类 需要在构造函数中初始化要访问的类
类名是good
private:
	Building *building;
good::good()
{
	building = new Building("----sittingroom----","----bedroom----");
}
void good::visit()
{
 	cout<<"vistt:\t"<<building->m_SittingRoom<<endl;
 	cout<<"vistt:\t"<<building->m_Bedroom<<endl;
}

~~~
##### 成员函数做友元

