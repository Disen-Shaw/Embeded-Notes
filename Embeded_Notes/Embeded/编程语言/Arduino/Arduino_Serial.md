# Arduino_Serial函数
## **available()函数**
可用于检查设备是否接收到数据，该函数将会返回等待读取的数据字节数。
avilable()函数属于Stream类，可以被其子类引用
`如Serial, WiFiClient, File等`
语法：
~~~c++
stream.available()
//stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换
Serial.available()
Wificlient.available()
~~~
****
## **begin()函数**
用于设置电脑与Arduino进行串口通讯时的数据传输速率
`可用速率：`
`300, 600, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, or 115200`
语法：
~~~c++
Serial.begin(speed)
// speed：long型，每秒传输字节数
~~~
****
## **end()函数**
用于终止串行通讯，可以让RX和TX引脚用于Arduino的输入(INPUT)或输出(OUTPUT)功能
`可以调用Serial.begin()重新开始串行通讯`
语法：
~~~c++
Serial.end()
~~~
****
## **read()函数**
read() 函数可用于从设备接收到数据中读取一个字节的数据。
函数属于Stream类，可被Stream类的子类所使用
`如Serial, WiFiClient, File等`
语法：
~~~c++
stream.read() 
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换。
Serial.read()
wifiClient.read()
~~~
返回值：
`没有接收到数据，返回值为-1，接收到数据后，返回值为数据流的第一个字符`
### **readBytes()函数**
用于从设备接收的数据中读取信息
读取到的数据信息将存放在缓存变量中
`在读取到指定字节数的信息或者达到设定时间后都会停止函数执行并返回`
`该设定时间可使用（setTimeout）来设置`
~~~c++
stream.readBytes(buffer, length)
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换。
Serial.readBytes(buffer, length)
wifiClient.readBytes(buffer, length)
~~~
参数：
`buffer: 缓存变量/数组。用于存储读取到的信息。允许使用char或者byte类型的变量或数组`  
`length: 读取字节数量。readBytes函数在读取到length所指定的字节数量后就会停止运行。`
`允许使用int类型`
### **readBytesUntil()函数**
readBytesUntil() 函数可用于从设备接收到数据中读取信息。
读取到的数据信息将存放在缓存变量中
返回条件：
+ 读取到指定终止字符
+ 读取到指定字节数的信息
+ 达到设定时间（可使用setTimeout来设置）

当函数读取到终止字符后，会立即停止函数执行。此时buffer（缓存变量/数组）中所存储的信息为设备读取到终止字符前的字符内容

语法：
~~~c++
stream.readBytesUntil(character, buffer, length)
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换  
Serial.readBytesUntil(character, buffer, length)
wifiClient.readBytesUntil(character, buffer, length)
~~~
返回值：
buffer(缓存变量)中存储的字节数。数据类型：size\_t(long)
### **readString()函数**
用于从设备接收到数据中读取数据信息
读取到的信息将以字符串格式返回
语法：
~~~c++
stream.readString()
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换。
Serial.readString()` 
wifiClient.readString()
~~~

### **readStringUntil()函数**
用于从设备接收到的数据中读取信息
读取到的数据信息将以字符串形式返回
返回条件;
+ 读取到指定终止字符
+ 达到设定时间（可使用setTimeout来设置）

语法：
~~~c++
Stream.readStringUntil(terminator)
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换。  
Serial.readStringUntil(terminator)
wifiClient.readStringUntil(terminator)
~~~
参数：
terminator: 终止字符。
`用于设置终止函数执行的字符信息`
`设备在读取数据时一旦读取到此终止字符，将会结束函数执行，允许使用char类型`
返回值：
`接收到的数据，类型为字符串`
****
## **write()函数**
写二进制数据到串口，数据是一个字节一个字节地发送的
**如果以字符形式发送数字使用print()代替。**
语法：
~~~c++
Serial.write(val)  
Serial.write(str)  
Serial.write(buf, len)
~~~
参数：
`val: 作为单个字节发送的数据`
`str: 由一系列字节组成的字符串`
`buf: 同一系列字节组成的数组`
`len: 要发送的数组的长度`
****
## **find()函数**
可用于从设备接收到的数据中寻找指定字符串信息
`当函数找到了指定字符串信息后将会立即结束函数执行并且返回 "true"`
`否则返回 "false" `
find()函数属于Stream类，可以被其子类引用
`如Serial, WiFiClient, File等`
语法：
~~~c++
Stream.find(target)
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换
Serial.find(target)
wifiClient.find(target)
~~~
参数：
`target：被查找字符串。允许使用String或char类型`
****
## **findUntil()函数**
findUntil函数可用于从设备接收到的数据中寻找指定字符串信息。
`当函数找到了指定字符串信息后将会立即结束函数执行并且返回 "true"`
`否则返回 "false" `
返回条件：
+ 读取到指定终止字符串
+ 找到了指定字符串信息
+ 达到设定时间（可使用[[Arduino_setTimeout]]来设置）

findUntil()函数属于Stream类，可以被其子类引用
`如Serial, WiFiClient, File等`
语法：
~~~c++
Stream.findUntil(target, terminator)
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换
Serial.findUntil(target, terminator)
wifiClient.findUntil(target, terminator)
~~~
参数：
`target：被查找字符串。允许使用String或char类型`
****
## **flush()函数**
flush函数可让开发板在所有待发数据发送完毕前，保持等待状态。
`阻塞函数`
flush()函数属于Stream类，可以被其子类引用
`如Serial, WiFiClient, File等`
在没有使用flush函数的情况下，开发板不会等待所有“发送缓存”中数据都发送完毕再执行后续的程序内容。也就是说，开发板是在后台发送缓存中的数据。程序运行不受影响。

相反的，在使用了flush函数的情况下，开发板是会等待所有“发送缓存”中数据都发送完毕以后，再执行后续的程序内容。

语法：
~~~c++
stream.flush()
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换
Serial.flush()
wifiClient.flush()
~~~
****
## **peek()函数**
peek函数可用于从设备接收到的数据中读取一个字节的数据。
每一次调用peek函数，只能读取数据流中的第一个字符
语法：
~~~c++
stream.peek()
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换
Serial.peek()
wifiClient.peek()`
~~~
参数：
`target：被查找字符串。允许使用String或char类型`
****
## **print()函数**
以人类可读的ASCII码形式向串口发送数据，该函数有多种格式。
整数的每一数位将以ASCII码形式发送。
浮点数同样以ASCII码形式发送，默认保留小数点后两位。
`使用类似printf函数`
~~~c++
Serial.print(18,BIN);		// 二进制发送
Serial.print(18,OTC);		// 八进制发送
Serial.print(18,DEC);		// 十进制发送
Serial.print(18,HEX);		// 十六进制发送

Serial.println(3.14159,0);	// 输出3
Serial.println(3.14159,1;	// 输出3.1
Serial.println(3.14159,4;	// 输出3.1415
~~~
可以用F()把待发送的字符串包装到flash存储器。
~~~c++
Serial.print(F(“Hello World”));
~~~
****
## **parseInt()函数**
parseInt函数可用于从设备接收到的数据中寻找整数数值。
parseInt()函数属于Stream类，可以被其子类引用
`如Serial, WiFiClient, File等`
语法：
~~~c++
Serial.prseInt()
stream为概念对象名称。在实际使用过程中，需要根据实际使用的stream子类对象名称进行替换
Serial.parseInt()
wifiClient.parseInt()
~~~
返回值：
`在输入信息中找到的整数值：long`
parseFloat()用法类似，返回值为float
