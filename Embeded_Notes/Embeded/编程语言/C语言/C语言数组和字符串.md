# C语言数组及字符串
## 数组相关概念

**数组概念**

**内存中连续相同类型的变量空间,数组名是指向数组首地址的指针常量**
遍历通常使用for循环加sizeof
数组元素   [ ]  必须是常量表达式
数组必须预先知道大小
数组下标不要越界，否则会发生运行异常

## 冒泡排序、

**冒泡排序思想**

把最大的数放到最后面(看排列升序还是降序)
外层控制行，执行次数为元素个数-1
内层控制列，执行次数为元素个数-1-外层执行次数

## 二维数组

多用于制作地图类的东西

## 字符数组和字符串

**定义字符数组**

~~~c
char arr[5] = {'h','e','l','l','o'};
~~~

**定义字符串**

字符串结束标志为 \0 

~~~~c
char arr[] = "hello";
char * arr[] = "helo";
char arr[5] = {'h','e','l','l','o','\0'};
数字0等同于\0，但是不等同于'0
~~~~

**字符串的输入与输出**

~~~c
  signed char str[100];
printf("输入字符串\n");
scanf("%s",str);
printf("刚才输入的字符串为\n%s",str);
~~~

**输入函数：**

1. gets()：

~~~c
#include<stdio.h>
char *gets(char *s)
从标准输入读取字符，直到出现换行符或者读取到文件结尾为止
	返回值：
		成功：读入的字符串
		失败：NULL
	    
	#include<stdio.h>
	void main(void)
	{
	    char str[100];
	    gets(str);
	    printf("%s",str);
	}
	~~~
	
	gets(str)与scanf("%s",str)的区别
	
	scanf("%s",str)不允许含有空格，但是也可以通过正则表达式来完成输入空格
	
	~~~c
	scanf("%[^\n]",ch);
	这样可以输入空格
	~~~
	
2. fgets()

   ~~~c
   #include<stdio.h>
   char *fget(char *s,int size,FILE *stream);
   从stream指定的文件内读取字符，保存到s所指的内存空间，直到出现换行符、读取到文件结尾或者已经读取到size-1个字符为止，最后会自动加上'\0'作为结尾
   参数：
       s：字符串
       size：指定的最大读取字符串长度
       stream：文件指针，如果读取为键盘输入
       则固定位stdin
   返回值：
       成功：成功读取到的字符串
       出错：NULL
   获取字符串少于元素个数会有\n，反之没有
   #include<stdio.h>
   void main(void)
   {
       char str[100];
       fgets(str,sizeof(str),stdin);
       printf("%s",str);
   }
   ~~~

**输出函数**

1. puts()

   ~~~c
   #include<stdio.h>
   int puts(const char *s);
   标准输出s字符串，在输出完成后悔自定加\n
   参数：
       s：字符串首地址
   返回值：
       成功：非负数
       失败：-1
   ~~~

2. fputs()

   ~~~c
   #include<stdio.h>
   int fputs(const char *str,FILE *stream);
   将str所指的字符写入到stream指定文件夹中，字符串结束符'\0'不写入文件(这点类似于printf()函数)
   参数：
       str：字符串
       stream：文件指针，如果把字符串输出到屏幕，固定写为stdout
   返回值：
       成功：
   ~~~

   

**字符串的拼接**

~~~c
  signed char ch1[] = "hello";
  signed char ch2[] = "world";
  signed char ch3[20];
  unsigned char i = 0; 
while(ch1[i] != '\0')
{
    ch3[i] = ch1[i];
    i++
}
  unsigned char j = 0;
while(ch2[j] != '\0')
{
    ch3[i+j] = ch1[j];
    j++;
}
ch3[i+j] = '\0';
~~~

**字符数组与字符串区别**

+ C语言中没有字符串这种数据类型，可以通过char数组替代

+ 字符串一定是char数组，但是char数组不一定是字符串

+ 数字0(和字符'\0'等价)结尾的char数组就是一个字符串

  字符串是特殊的字符数组

**计算字符串长度**

**函数**：

~~~c
#include<stdio.h>
#include<string.h>
strlen()函数
~~~