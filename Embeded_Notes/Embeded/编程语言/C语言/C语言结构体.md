# C语言结构体
## 基本概念

自定义的数据类型，允许用户存储不同的数据类型

### 定义与说明

**结构体定义**

~~~c
struct 结构体名
{
    列表成员
}
~~~

> 通过结构体创建变量的方式由三种

+ struct 结构体名 变量名
+ struct 结构体名 变量名={成员名...}
+ struct关键字可以省略
+ 定义结构体时顺便创建变量

## 结构体指针

**正常用**

~~~c++
// 链表的示例
struct Links
{
    int value;
    Links *next;
};
// 主函数
int main(void)
{
    Links *head = (Links*)malloc(12*5);
    Links links[5];
    for (unsigned  i = 0; i < 4; i++)
    {
        (links+i)->next=(links+i+1);
        (links+i)->value=i;
    }
    (links+4)->next = NULL;
    (links+4)->value = 4;
    for (unsigned i = 0; i < 5; i++)
    {
        cout<<(links+i)->value<<"\t";
    }
    puts("");   
}
~~~

## 结构体做函数参数

结构体做参数分为两种情况

1. 值传递

   值传递不改变实参

2. 地址传递

   **直接对实参地址进行操作**

## 结构体中const使用场景

用const来防止误操作

~~~c++
struct Student
{
    string name;
    int age;
    int score;
};
// 值传递
void PrintStudent(Student s)
{
    cout << "姓名为：" << s.name << "\t"
         << "年龄为：" << s.age << "\t"
         << "分数为：" << s.score << "\t"
         << endl;
}
// 每次值传递都会复制一个新的结构体，占用内存！
/* 可通过地址传递来优化 */
void PrintStudent(Student *s)
{
    cout<<"姓名为："<<s->name<<"\t"
        <<"年龄为："<<s->age<<"\t"
        <<"分数为："<<s->score<<endl;
}
// 如果采用地址传递会产生危险！！！
// 可能会误改
/* 优化 */
void PrintStudent(const Student *s)
{
    cout<<"姓名为："<<s->name<<"\t"
        <<"年龄为："<<s->age<<"\t"
        <<"分数为："<<s->score<<endl;
}
int main(void)
{
    Student s = {"张三", 15, 70};
    // 通过函数打印结构体变量信息
    PrintStudent(s);
}
~~~
