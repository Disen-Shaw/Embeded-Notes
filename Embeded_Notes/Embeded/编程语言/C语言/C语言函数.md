# C语言函数
## 函数作用

+ 省略重复的代码，降低冗余
+ 使程序模块化，利于阅读

**函数指标**

1. 头文件：包含指定的头文件
2. 函数名称：函数名成要与头文件声明的一致
3. 功能：函数的功能
4. 参数：参数类型要与之匹配
5. 返回值：根据需要接受返回值

**常用函数**

~~~c
#include<time.h>
time_t time(time_t *t);
//功能：
    //获取系统当前时间
//参数：常设置为NULL
//返回值：
    //当前系统时间
#include<stdlib.h>
void strand(unsigned int seed);
//功能：
    //用来设置rand()产生的随机数时的随机种子
//参数：
    //如果每次seed相同，rand()产生的随机数相等
#include<stdlib.h>
int rand(void);
// 功能：
	// 返回一个随机数值
// 返回值：
	// 随机数
~~~

## 函数的定义和使用

**函数的定义**

~~~c
返回类型 函数名(参数列表)
{
	代码体
}
~~~

+ 不同函数中变量名可以相同，因为作用域不同

+ 在函数调用过程中，将实参传递给形参

+ 在函数调用结束后会在内存中销毁

  会在栈区自动销毁

## 多参数函数的使用
用到了标准库中的stdarg宏
例如：
```c
#include <stdarg.h>
#include <stdio.h>

float average(int n_values, ...) {
  va_list var_arg;
  int count;
  float sum = 0;
  /*
   * 准备访问可变参数
   */
  va_start(var_arg, n_values);
  /*
   * 添加取自可变参数列表的值
   */
  for (count = 0; count < n_values; count++) {
    sum += va_arg(var_arg, int);
  }
  va_end(var_arg);
  return sum / n_values;
}

int main(int argc, char *argv[]) {
  float a = average(2, 3, 4, 5, 6, 7, 8);
  printf("%f\n", a);
  return 0;
}
```
### 使用方法
定义结构体：  
va_list var_args;  
使用结构体  
va_start(var_arg,n_values);  
相应的处理  
for (count = 0; count < n_values; count++) {  
	sum += va_arg(var_arg, int);  
}  
将每个参数相加  
最后va_end()



