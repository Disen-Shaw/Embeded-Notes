# C++模板
建立通用的模具，大大提高复用性
## 模板的特点
模板不可以直接使用，它只是一个框架
模板的通用型不是万能的

## 函数模板
C++的另一种思想称为泛型编程，主要利用的技术就是模板
C++提供两种模板机制：函数模板、累模板

### 函数模板语法
#### 函数木板的作用
建立一个通用函数，其函数返回值类型和形参类型可以不具体指定，用一个**虚拟的类型**代表
#### 语法
~~~c++
template<typename T>
函数声明或者定义
~~~
#### 解释
template：声明创建模板
typename：表面漆后面的符号是一种数据类型，可以用class代替
T：**通用的数据类型**，名称可以替换，通常为大写字母
~~~c++
template<typename T>
void mySwap(T &a,T &b)
{
	T temp = a;
	a = b;
	b = temp;
}
~~~
有两种方式使用函数模板：
现有 int a = 10,int b = 20;
1. 自动类型推导
~~~c++
mySwap(a,b);
~~~
2. 显示指定类型
~~~c++
mySwap<int>(a,b);		// opencv中的那个！！！！
~~~
**类型参数化，类似于重载的加强版**

## 函数模板注意事项
注意事项：
+ 自动类型推到，必须推导出**一致的数据类型**T，才可以使用
+ 模板必须要**确定**出T的数据类型，才可以使用

## 普通函数与函数模板的区别
普通函数与函数模板的区别：
+ 普通函数调用时可以发生自动类型转换(隐式类型转换)
+ 函数模板调用时，如果利用自动类型推导，不会发生隐式类型转换
+ 如果利用显示指定类型的方式，可以发生隐式类型转换

例如：
~~~c++
int myAdd01(int a,int b)
{
	return a+b;
}

void test01()
{
	int a = 10;
	int b = 20;
	char c = 'c';
	cout<<myAdd01(a,c)<<endl;
}
// c自动被转化为ASCII码99
~~~
函数模板：
~~~c++
template<class T>
T mAdd02(T a,T b)
{
	return a+b;
}
~~~
推荐使用显示类型转换

## 普通函数与函数模板的调用规则
1. 如果函数模板和普通函数都可以实现，**优先调用普通函数**
2. 可以通过**模板参数列表强制调用函数模板**
~~~c++
myPrint<>(a,b);
~~~
3. 函数模板**可以发生重载**
4. **如果函数模板可以产生更好的匹配，优先调用函数模板**

既然提供了模板，不需要在提供普通函数，会出现二义性

## 模板的局限性
模板的通用型不是万能的
例如：
~~~c++
template<class T>
void fun(T a,T b)
{
	a = b;
}
~~~
代码中提供的赋值操作，如果传入的a和b是一个数组，就无法实现
另外例如：
~~~c++
template<class T>
void fun(T a,T b)
{
	if(a == b)
	{
		return true;
	}
	else
	{
		return false;
	}
}
~~~
如果函数传入类对象，程序就无法正常运行
**解决方法：进行具体化操作**
~~~c++
template<> bool fun(Person &p1,Person &p2)
{
	if((p1.xxx==p2.xxx)&&(p1.xxxx=p2.xxxx))
	{
		return true;
	}
	else
	{
		return false;
	}
}
~~~
### 总结：
利用具体化的模板，可以解决自定义类型的通用化
学习模板并不是为了写模板，而是在**STL**能够运用系统提供模板


## 类模板中的成员函的创建时机
类模板中的成员函数和普通类中的成员函数创建时机是有区别的
+ 普通类中的成员函数在对象创建时就可以创建
+ 类模板中的成员函数在函数调用时才创建

~~~c++
class Person1{
public:
	void fun1()
	{
		std::cout<<"Person1"<<std::endl;
	}
}

class Person2{
public:
	void fun1()
	{
		std::cout<<"Person2"<<std::endl;
	}
}

template<class T>
class Myclass{
public:
	T obj;
	// 类模板中的成员函数
	void fun1()
	{
		obj.Person1();
	}
	void fun2())
	{
		obj.Person2();
	}
}
~~~

### 总结
类模板中的成员函数不是直接创建，而是调用时才会创建


## 类模板对象做函数参数
类模板实例化出来的对象也可以作为函数的参数

### 一共有三种传入方式
1. 指定传入的类型
	直接显示对象的数据类型
	
~~~c++
#include <iostream>
using namespace std;

template<class T1,class T2>
class Person{
public:
	T1 m_name;
	T2 m_age;
	Person(T1 name,T2 age)
	{
		this->m_name = name;
		this->m_age = age;
	}
	void person_function()
	{
		cout<<"姓名为"<<this->m_name \
				<<"年龄为"<<this->m_age;
	}
};

void printPerson(Person<string,int>&p)
{
	p.person_function();
}

int main()
{
	Person<string,int>p("擎天柱",1000);
	printPerson(p);
};
~~~

2. 参数化模板
	将对象中的参数变为模板进行传递
	
~~~c++
template <class T1,class T2>
void printPerson_(Person<T1,T2>&p)
{
	p.person_function();
}
void test2()
{
	Person<string,int>p("威震天",1000);
	printPerson(p);
};

~~~
	
3. 整个类模板化
	将整个对象类型进行模板化传递
	

## 模板类的继承
继承中子类要给父类进行定义
子类继承父类所有的属性，只是有的属性无法访问
因此在给子类的属性赋予模板属性时，要给父类赋予模板属性
~~~c++
#include <iostream>
using namespace std;

template<class T>
class Base{
public:
	T base_obj;
};

template <class T1,class T2>
class Son:public Base<T1>
{
public:
	Son()
	{
		cout<<"T1的类型为"<<typeid(T1).name()<<endl;
		cout<<"T2的类型为"<<typeid(T2).name()<<endl;
	}
	T2 son_ojb;
};

void test()
{
	Son<int,char>s;
}
int main()
{
	test();
	return 0;
}
~~~


## 类模板成员函数的类外实现
类外实现需要加上模板参数列表
~~~c++
#include <iostream>
using namespace std;

template<class T1,class T2>
class Person{
public:
	T1 name;
	T2 age;
	Person(T1 name,T2 age);
	void showPerson(void);
};

template<class T1,class T2>
Person<T1,T2>::Person(T1 name, T2 age)
{
	this->name  = name;
	this->age  = age;
}	

template<class T1,class T2>
void Person<T1,T2>::showPerson()
{
	cout<<"姓名：\t"<<this->name<<"\n"
			<<"年龄：\t"<<this->age<<endl;
}
int main(void)
{
	Person<string,int>*p = new Person<string,int>("擎天柱",1000);
	p->showPerson();
	return 0;
}
	
~~~



## 类模板分文件编写
类模板中成员函数**创建时机是在调用阶段，导致文分件编写时链接不到**
解决方法是：
+ 直接包含cpp源文件
+ 将声明和实现写到同一个文件中，并更改后缀名为.hpp

## 类模板和友元
全局函数类内实现，直接在类内声明友元即可
全局函数类外实现，需要提前让编译器知道全局函数的存在

内部类内实现
~~~c++
#include <iostream>
using namespace std；

template <class T1,class T2>
class Person;

template <class T1,class T2>
class Person{
	friend void test(Person<T1,T2>&p)
	{
		cout<<"姓名为:\t"<<p.m_Name<<"\n"
			<<"年龄为:\t"<<p.m_Age<<endl;
	}
private:
	T1 m_Name;
	T2 m_Age;
public:
	Person(T1 name,T2 age)
	{
		this->m_Name = name;
		this->m_Age = age;
	}
	void showPerson()
	{
		cout<<"姓名为:\t"<<this->m_Name<<"\n"
			<<"年龄为:\t"<<this->m_Age<<endl;
	}
};
int main(void)
{
	Person<string,int> *p = new Person<string,int>("擎天柱",1000);
	test(*p);
}
~~~

类外实现
~~~c++
#include <iostream>
using namespace std;

// 提前让编译器直到Person类存在
template <class T1,class T2>
class Person;
// 类外实现友元函数
template <class T1,class T2>
void show(Person<T1,T2>p)
{
	cout<<"姓名为\t"<<p.m_Name<<endl;
	cout<<"年龄为\t"<<p.m_Age<<endl;
}
template <class T1,class T2>
class Person{
	friend void show<>(Person<T1,T2>p);
private:
	T1 m_Name;
	T2 m_Age;
public:
	Person(T1 name,T2 age)
	{
		this->m_Name = name;
		this->m_Age = age;
	}
	void showPerson()
	{
		cout<<"姓名为:\t"<<this->m_Name<<"\n"
			<<"年龄为:\t"<<this->m_Age<<endl;
	}
};
void test()
{
	Person<string,int> p("擎天柱",1000);
	show(p);
}

int main(void)
{
	test();
}
~~~


