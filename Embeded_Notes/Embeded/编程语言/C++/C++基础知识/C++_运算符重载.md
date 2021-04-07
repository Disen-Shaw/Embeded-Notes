# C++运算符**重载**
对已有的运算符重新进行定义，赋予其另一种功能
关键字： operator**X**,**X**是运算符
可以通过全局函数重载，也可以通过成员函数重载
## 加号重载运算符
**实现两个自定义数据类型相加的运算**
### 实例：
#### 成员函数完成重载
~~~c++
class Persion
{
public:
	int m_Money;
	Persion(int money)
	{
		this->m_Money = money;
	}
	Persion operator+(Persion &p1)
	{
		Persion temp(0);
		temp.m_Money = this->m_Money + p1.m_Money;
		return temp;
	}
};
~~~
本质：
p1(10),p2(20);
Persion p3 = **p1.operator+(p2);**
#### 全局函数完成重载
~~~c++
class Persion
{
public:
	int m_Money;
	Persion(int money)
	{
		this->m_Money = money;
	}
};
Persion operator+(Persion &p1,Persion &p2)
{
	Persion temp(0);
	temp.m\_Money = p1.m\_Money+p2.m\_Money;
	return temp;
}
~~~
本质：
p1(10),p2(20)
Persion p3 = **operator+(p1,p2);**

**运算符重载也可以发生函数重载**
例如：
~~~c++
class Persion
{
	public:
	int m_Money;
	Persion(int money)
	{
		this->m_Money = money;
	}
	Persion operator+(Persion &p1)
	{
		Persion temp(0);
		temp.m_Money = this->m_Money + p1.m_Money;
		return temp;
	}
	// 重载函数
	Persion operator+(int money)
	{
		Persion temp(0);
		temp.m_Money = this->m_Money + money ;
		return temp;
	}
};
~~~

对于内置数据类型的表达式的运算符不可以发生重载
不可以滥用重载运算符
`加法重载同样适用于-、*、/运算`

## 左移运算符重载
可以输出自定义数据类型
不会利用成员函数重载<<运算符，因为无法实现cout在左侧
只能利用全局运算符重载左移运算符
采用向类中添加友元信息来操作类内成员
~~~c++
class Persion
{
	friend ostream &operator<<(ostream &cout,Persion &p);
private:
	int m_Money;
public:
	Persion(int money)
	{
		this->m_Money = money;
	}
	Persion operator+(Persion &p1)
	{
	Persion temp(0);
	temp.m_Money = this->m_Money + p1.m_Money;
	return temp;
	}	
};
ostream &operator<<(ostream &cout,Persion &p)
{
	cout<<p.m_Money;
	return cout;
}
~~~
ostream为标准输出流对象，全局只有一个
`返回引用是为了一直对一个数据进行操作`
## 递增运算符重载
通过重载递增运算符，实现自己的整形数据
### 前置递增
~~~c++
TestInteger &operator++()
{
	m\_int++;
	return \*this;
}
~~~
### 后置递增返回的时值
利用(int)参数来区分前置递增和后置递增
~~~c++
TestInteger operator++(int)
{
	TestInteger temp = \*this;
	m\_int++;
	return temp;
}
~~~


## 赋值运算符重载
C++编辑器至少给一个类添加4个函数
+ 默认构造函数(函数体为空)
+ 默认析构函数(函数体为空)
+ 默认拷贝函数,对属性值进行拷贝
+ 赋值运算符operator=，对属性进行拷贝

如果类中有属性指向堆区，做赋值操作也会出现深浅拷贝的问题

运用深拷贝来解决重复释放同一区域内存的问题

应该先判断是否有属性在堆区，如果有，先释放干净，然后进行深拷贝

~~~c++
class Test
{
	/* 友元 */
	friend ostream &operator<<(ostream &cout, Test &t);
private:
	int *m_Var;
public:
	Test(int var);
	~Test();
	Test &operator=(Test &t)
	{
	if (this->m_Var != NULL)
	{
	delete this->m_Var;
	this->m_Var = NULL;
	}
		this->m_Var = new int(*t.m_Var);
		return *this;
	}
};
Test::Test(int var)
{
	m_Var = new int(var);
}
Test::~Test()
{
	if (this->m_Var != NULL)
{
	delete this->m_Var;
	this->m_Var = NULL;
}
	cout << "调用析构函数" <<endl;
}
ostream &operator<<(ostream &cout, Test &t)
{
	cout << \*t.m\_Var;
	return cout;
}
~~~

## 关系运算符重载
关系运算符，可以让两个自定义类型对象进行对比操作
返回类型为bool类型
~~~c++
class Person
{
private:
	string m_Name;
	int m_Age;
public:
	Person(string name, int age)
	{
	this->m_Name = name;
	this->m_Age = age;
	}
	~Person();
	bool operator==(Person &p)
	{
		if (this->m_Name == p.m_Name && this->m_Age == p.m_Age)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	bool operator!=(Person &p)
	{
		if (this->m_Name == p.m_Name && this->m_Age == p.m_Age)
		{
			return false;
		}
		else
		{
			return true;
		}
	}
};
~~~

## 函数调用运算符重载
函数电泳运算符()也可以重载
重载后的使用方式非常像函数的调用，因此称为仿函数
没有固定写法

放函数很灵活了，没有专门的写法

构建方法类似于之前的重构