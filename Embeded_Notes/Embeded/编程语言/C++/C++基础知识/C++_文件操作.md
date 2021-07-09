# C++的文件操作
程序运行时产生的临时的数据都属于数据，程序一旦结束，数据就会被释放
**通过文件可以将数据持久化**
C++中对文件操作需要包含头文件
\<fstream>
文件类型分为两种：
+ 文本文件：文件以文本的ASCII码形式存储在计算机中
+ 二进制文件：文件以文本的二进制形式存储在计算机中，一般不可以直接读懂

操作文件的三大类：
+ ofstream：写操作
+ ifstream：读操作
+ fstream：读写操作

## 文本文件
### 写文件
写文件包含5个步骤
1. 包含头文件
	+ include \<fstream>
2. 创建流对象
	+ ofstraem ofs;
3. 打开文件
	+ ofs.open("文件路径",打开方式);
4. 写数据
	+ ofs << "写入的数据"；
5. 关闭文件

文件打开方式：

|打开方式|解释|
|---|----|
|ios::in|为读文件而打开文件|
|ios::out|为写文件而打开文件|
|ios::ate|初始位置：文件尾|
|ios::app|追加方式写文件|
|ios::trunc|如果文件存在，则先删除，再创建文件|
|ios::binary|二进制方式打开文件|

~~~c++
int main()
{
    ofstream ofs;
    ofs.open("test.txt",ios::out);
    ofs << "hello,world" ;
    ofs.close();
}
~~~

**文件打开方式可以用|配合多个使用**

### 读文件
与写文件创建的对象类不同
1. 包含头文件
	+ include \<fstream>
2. 创建流对象
	+ ifstraem ofs;
3. 打开文件
	+ ofs.open("文件路径",打开方式);
4. 写数据
	+ ofs << "写入的数据"；
5. 关闭文件
~~~c++
// 方法1
while(ifs>>buf)
{
	cout<<buf<<endl;
}
// 方法2
while(ifs.getline(buf,sizeof(buf)))
{
	cout<<buf<<endl;
}
// 方法3
string buf;
while(getline(ifs,buf))
{
	cout<<buf<<endl;
}
// 方法4
while( ( c=ifs.get() ) != EOF )
{
	cout << c;
}
~~~


## 二进制文件
以二进制形式对文件进行读写操作
打开方式要指定为**ios::binary**

### 写文件
二进制写文件主要利用流对象调用成员函数write
函数原型：ostream &write(const char \*buffer,int len)
参数解释：
buffer为缓冲区，指向一片内存
len是读写的字节数

**读写文件操作最好用C语言中的数据类型**

~~~c++
class Persion{
public:
    char m_Name[64]; 
    int m_Age;  
};


ofstream ofs;
ofs.open("persion.txt",ios::out|ios::binary);
    
Persion p = {"张三",18};

ofs.write((const char *)&p,sizeof(Persion));
ofs.close();
~~~

### 读文件
二进制方式读文件主要利用流对象调用成员函数read
函数原型：istream &read(char \*buffer,int len);
参数解释：字符串指针buffer只想内存中的一段存储空间，len是读写的字节数


~~~c++
int main()
{
    ifstream ifs;
    ifs.open("./persion.txt", ios::binary | ios::in);
    if (!ifs.is_open())
    {
        cout << "open filed!" << endl;
        return -1;
    } 
    Persion p;
    ifs.read((char *)&p,sizeof(Persion));
    
    cout<<p.m_Name<<endl;
    cout<<p.m_Age<<endl;

    ifs.close();
}
~~~










