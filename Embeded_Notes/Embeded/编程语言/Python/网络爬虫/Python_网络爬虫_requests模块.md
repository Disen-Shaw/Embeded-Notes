# Python requests模块 
#network  [requests模块手册](https://2.python-requests.org//zh_CN/latest/index.html)
<br>
## requests模块的作用
发送http请求，获取响应数据

[Python_网络爬虫_requests_Get请求](Python_网络爬虫_requests_Get请求.md)  



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
