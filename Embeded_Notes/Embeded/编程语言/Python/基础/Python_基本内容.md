# Python 基础内容

## 简单的 ==hello world==

```python
print("hello world")
```

使用方式类似于 `shell` 脚本

## Python 关键字

<table class="reference">
<tbody><tr><td>and</td><td>exec</td><td>not</td></tr>
<tr><td>assert</td><td>finally</td><td>or</td></tr>
<tr><td>break</td><td>for</td><td>pass</td></tr>
<tr><td>class</td><td>from</td><td>print</td></tr>
<tr><td>continue</td><td>global</td><td>raise</td></tr>
<tr><td>def</td><td>if</td><td>return</td></tr>
<tr><td>del</td><td>import</td><td>try</td></tr>
<tr><td>elif</td><td>in</td><td>while</td></tr>
<tr><td>else</td><td>is</td><td>with </td></tr>
<tr><td>except</td><td>lambda</td><td>yield</td></tr>
</tbody></table>

## 基本语法

### 行和缩进

Python 中不使用大括号来表示代码快，而使用行缩进来表示不同的代码快\
不同的缩进次数代表不同块的代码片段

### 多行语句

在写入长句时如果一行写不下，可以通过 `\` 来进行换行操作，例如

```python
total = item_one + \
        item_two + \
        item_thre
```

### 引号的使用

Python 的引号可以使用 `单引号、双引号和三引号` 来表示字符串\
其中三引号可以由多行组成，编写多行文本的快捷语法，常用于文档字符串，在文件的特定地点，被当做注释

### 注释

Python 注释采用 `#` 开头

## 数据类型和变量

- 字符串类型 String
- 数字 number
- 列表 list
  ```python
  ['uCOS-II','FreeRTOS','uCLinux']
  ```
- 字典 dict
  ```python
  ['name':'李华','mession':'English Letter']
  ```
- 逻辑 Bool


