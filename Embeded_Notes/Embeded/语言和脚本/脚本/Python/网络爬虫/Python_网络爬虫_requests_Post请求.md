# requests的POST请求
## POST请求应用
+ 登录注册(Web工程师看来，POST比GET更安全，url中不会暴露用户的帐号密码信息)
+ 需要传输大文本内容(POST请求对数据的长度没有要求)

## requests发送POST请求的方法
```python
response = requests.post(url, data)
```
+ data参数接受一个字典
+ **其他参数和发送GET请求完全一致**

