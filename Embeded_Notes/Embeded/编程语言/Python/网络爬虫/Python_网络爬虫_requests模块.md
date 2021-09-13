# Python requests模块
[requests模块手册](https://2.python-requests.org//zh_CN/latest/index.html)
## requests模块的作用
发送http请求，获取响应数据

## requests模块发送get请求
通过requests向百度首页发送请求，获取该页面的源码  
```python 
import requests

# 目标url
url = "https://www.baidu.com"

# 向目标发送get请求
reponse = requests.get(url)

# 打印响应内容
print(reponse.text)
```

## response 响应对象
运行源码，会有好多乱码，这是因为编解码使用的字符集不同造成的  
可以使用这样的方法解决中文乱码问题  

```python
import requests
# 目标url
url = 'https://www.baidu.com'

response,encoding = 'utf8'
# 向目标url发送get请求
response = requests.get(url)

# 打印相应的内容
print(reponse.text)
```
或者
```
import requests
# 目标url
url = 'https://www.baidu.com'

# 向目标url发送get请求
response = requests.get(url)

# 打印相应的内容
print(reponse.content.decode())
```

+ `response.text` 是 `requests` 模块按照 `charset` 模块推测出的编码字符集进行解码的结果
+ 网络传输的字符串都是 `bytes` 类型的，所以 `response.text = reponse.content.decode('推测出的编码字符集')`
+ 可以在网页源码中搜索 `charset`，尝试参考该编码字符集，注意存在不准确的情况

### response.text 和 response.content的区别
+ response.text
	+ 类型：str
	+ 解码类型：requests模块自动更具HTTP头部相应的编码做出有根据的推测，推测的文本编码
+ response.content
	+ 类型：bytes
	+ 解码类型：没有指定

### 通过对 response.content进行decode解决中文乱码
+ response.content.decode()
	+ 默认utf8
+ response.content.decode("GBK")
+ 常见的字符编码集
	+ utf-8	
	+ gbk
	+ gb2312
	+ ascii
	+ iso-8859-1

### response响应对象的其他常用属性或方法
response是发送请求获取的响应对象，除了text、content获取响应内容之外，还有其他常用的属性或者方法
+ response.url 响应的url：有时候响应的url和请求的url并不一致
+ response.status_code：响应状态码 
+ response.request.headers：响应对应请求头
+ response.headers：响应头
+ response.request.\_cookies：响应对应请求的cookie，返回cookieJar类型
+ response.cookie：相应的cookie(经过了set-cookie动作，返回cookieJar)
+ response.json()：自动将json字符串类型的响应内容转换为python对象

## requests模块发送请求
### 发送带header的请求
利用 `requestes.get(url)` 爬取到的内容会比使用浏览器爬取到的内容少很多，因为少了**请求头**的信息

#### 携带请求头发送请求的方法
**resquests.get(url,headers=headers)**  
+ headers参数接收字典形式的请求头
+ 请求头字段名作为key，字段对应的值作为value


```
import requests
# 目标url
url = 'https://www.baidu.com'

headers = {User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:92.0) Gecko/20100101 Firefox/92.0}

# 向目标url发送get请求
response = requests.get(url)

# 打印相应的内容
print(reponse.content.decode())
```

### 发送带参数的请求
#### 在url中携带参数
直接对含有参数的url发起请求，例如

`url = 'https://www.baidu.com/s?wd=python'`

#### 通过params携带参数字典
1. 构建请求参数字典
2. 想接口发送请求时带上参数字典，参数字典设置给 `params`

```python
import requests
# 目标url

headers = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:92.0) Gecko/20100101 Firefox/92.0'}

url = 'https://www.baidu.com/s?wd=python'

# 参数字典
kw = {'wd':'python'}

# 向目标url发送get请求
response = requests.get(url,headers = headers,params=kw )
```