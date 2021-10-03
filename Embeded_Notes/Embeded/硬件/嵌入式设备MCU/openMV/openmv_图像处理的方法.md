---
date updated: '2021-10-03T09:27:05+08:00'

---

# openmv图像处理的方法

## 感光元件

**sensor模块，用于设置采光元件的参数**

```python
import sensor#引入感光元件的模块

# 设置摄像头
sensor.reset()#初始化感光元件
sensor.set_pixformat(sensor.RGB565)#设置为彩色
sensor.set_framesize(sensor.QVGA)#设置图像的大小
sensor.skip_frames()#跳过n张照片，在更改设置后，跳过一些帧，等待感光元件变稳定。

# 一直拍照
while(True):
    img = sensor.snapshot()#拍摄一张照片，img为一个image对象

```

### 初始化感光元件

通过

```python
sensor.reset()
```

来对感光元件进行初始化

### 设置彩色/黑白

通过

```python
sensor.set_pixformat()
```

设置像素模式

- sensor.GRAYSCALE：灰度，每个像素8bit
- sensor.RGB565：彩色，每个像素16bit

### 设置图像大小

通过

```python
sensor.set_framesize()
```

设置图像大小

- sensor.QQCIF: 88x72
- sensor.QCIF: 176x144
- sensor.CIF: 352x288
- sensor.QQSIF: 88x60
- sensor.QSIF: 176x120
- sensor.SIF: 352x240
- sensor.QQQQVGA: 40x30
- sensor.QQQVGA: 80x60
- sensor.QQVGA: 160x120
- sensor.QVGA: 320x240
- sensor.VGA: 640x480
- sensor.HQQQVGA: 80x40
- sensor.HQQVGA: 160x80
- sensor.HQVGA: 240x160
- sensor.B64X32: 64x32 (用于帧差异 image.find_displacement())
- sensor.B64X64: 64x64 用于帧差异 image.find_displacement())
- sensor.B128X64: 128x64 (用于帧差异 image.find_displacement())
- sensor.B128X128: 128x128 (用于帧差异 image.find_displacement())
- sensor.LCD: 128x160 (用于LCD扩展板)
- sensor.QQVGA2: 128x160 (用于LCD扩展板)
- sensor.WVGA: 720x480 (用于 MT9V034)
- sensor.WVGA2:752x480 (用于 MT9V034)
- sensor.SVGA: 800x600 (仅用于 OV5640 感光元件)
- sensor.XGA: 1024x768 (仅用于 OV5640 感光元件)
- sensor.SXGA: 1280x1024 (仅用于 OV5640 感光元件)
- sensor.UXGA: 1600x1200 (仅用于 OV5640 感光元件)
- sensor.HD: 1280x720 (仅用于 OV5640 感光元件)
- sensor.FHD: 1920x1080 (仅用于 OV5640 感光元件)
- sensor.QHD: 2560x1440 (仅用于 OV5640 感光元件)
- sensor.QXGA: 2048x1536 (仅用于 OV5640 感光元件)
- sensor.WQXGA: 2560x1600 (仅用于 OV5640 感光元件)
- sensor.WQXGA2: 2592x1944 (仅用于 OV5640 感光元件)

### 跳过一些帧

通过

```python
sensor.skip_frames(n=x) 
```

来设置跳过x张照片，在更改设置后，跳过一些帧，等待感光元件便稳定

### 获取一张图像

通过

```python
sensor.snapshot() 
```

拍摄一张照片，返回一个image对象。

### 自动增益

通过

```python
sensor.set_auto_gain()
```

- True：开启
- False：关闭

在使用颜色追踪时，需要关闭自动增益

### 白平衡

通过

```python
sensor.set_auto_whitebal()
```

- True：开启
- False：关闭

在使用颜色追踪时，需要关闭自动白平衡

### 曝光

通过

```python
sensor.set_auto_exposure(enable[\, exposure_us])
```

- enable 打开（True）或关闭（False）自动曝光
- 如果 enable 为 False， 则可以用 exposure_us 设置一个固定的曝光时间（以微秒为单位）。

### 设置窗口ROI

```python
sensor.set_windowing(roi)
```

ROI：`Region Of Interest`，图像处理中的术语“感兴趣区”。就是在要处理的图像中提取出的要处理的区域.
![](https://book.openmv.cc/assets/05-01-001.png)

    sensor.set_framesize(sensor.VGA) # 高分辨率
    sensor.set_windowing((640, 80)) #取中间的640*80区域

### 设置翻转

#### 水平翻转

sensor.set_hmirrror(True)

#### 垂直方向翻转

sensor.set_vflip(True)

## 图像的基本运算

![](https://book.openmv.cc/assets/05-02-001.jpg)

### 获取/设置像素点

可以通过`image.get_pixel(x, y)`方法来获取一个像素点的值。

- image.get_pixel(x, y)
  - 对于灰度图: 返回(x,y)坐标的灰度值.
  - 对于彩色图: 返回(x,y)坐标的(r,g,b)的tuple.

可以通过`image.set_pixel(x, y, pixel)`方法，来设置一个像素点的值。

- image.set_pixel(x, y, pixel)
  - 对于灰度图: 设置(x,y)坐标的灰度值。
  - 对于彩色图: 设置(x,y)坐标的(r,g,b)的值。

### 获取图像的宽度和高度

- image.width()\
  返回图像的宽度(像素)

- image.height()\
  返回图像的高度(像素)

- image.format()\
  灰度图会返回 sensor.GRAYSCALE，彩色图会返回 sensor.RGB565。

- image.size()\
  返回图像的大小(byte)

### 图像的运算

- image.invert()

取反，对于二值化的图像，0(黑)变成1(白)，1(白)变成0(黑)。

- image.nand(image)\
  与另一个图片进行与非（NAND）运算。
- image.nor(image)\
  与另一个图片进行或非（NOR）运算。
- image.xor(image)\
  与另一个图片进行异或（XOR）运算。
- image.xnor(image)\
  与另一个图片进行异或非（XNOR）运算。
- image.difference(image)\
  从这张图片减去另一个图片。比如，对于每个通道的每个像素点，取相减绝对值操作。这个函数，经常用来做移动检测。

## 使用图像的统计信息

如果我想知道一个区域内的平均颜色或者占面积最大的颜色
就要使用统计信息`Statistics`

### ROI感兴趣的区域

![](https://book.openmv.cc/assets/05-03-001.jpg)
roi的格式是(x, y, w, h)的tupple.

- x:ROI区域中左上角的x坐标
- y:ROI区域中左上角的y坐标
- w:ROI的宽度
- h:ROI的高度

### Statistics

    image.get_statistics(roi=Auto)

roi是目标区域。
注意，这里的roi，bins之类的参数，一定要**显式**地标明

    img.get_statistics(roi=(0,0,10,20))

如果是 img.get_statistics((0,0,10,20))，ROI不会起作用。

灰度的

- statistics.mean() 返回灰度的**平均数**(0-255) (int)。你也可以通过statistics[0]获得。

- statistics.median() 返回灰度的**中位数**(0-255) (int)。你也可以通过statistics[1]获得。

- statistics.mode() 返回灰度的**众数**(0-255) (int)。你也可以通过statistics[2]获得。

- statistics.stdev() 返回灰度的**标准差**(0-255) (int)。你也可以通过statistics[3]获得。

- statistics.min() 返回灰度的**最小值**(0-255) (int)。你也可以通过statistics[4]获得。

- statistics.max() 返回灰度的**最大值**(0-255) (int)。你也可以通过statistics[5]获得。

- statistics.lq() 返回灰度的**第一四分数**(0-255) (int)。你也可以通过statistics[6]获得。

- statistics.uq() 返回灰度的**第三四分数**(0-255) (int)。你也可以通过statistics[7]获得。

下面的是LAB三个通道的平均数、中位数，众数，标准差，最小值，最大值，第一四分数，第三四分数

- l_mean，l_median，l_mode，l_stdev，l_min，l_max，l_lq，l_uq，
- a_mean，a_median，a_mode，a_stdev，a_min，a_max，a_lq，a_uq，
- b_mean，b_median，b_mode，b_stdev，b_min，b_max，b_lq，b_uq，

例如
检测左上方的区域中的颜色值

```python
import sensor, image, time

sensor.reset() # 初始化摄像头
sensor.set_pixformat(sensor.RGB565) # 格式为 RGB565.
sensor.set_framesize(sensor.QVGA)
sensor.skip_frames(10) # 跳过10帧，使新设置生效
sensor.set_auto_whitebal(False)               # Create a clock object to track the FPS.

ROI=(80,30,15,15)

while(True):
    img = sensor.snapshot()         # Take a picture and return the image.
    statistics=img.get_statistics(roi=ROI)
    color_l=statistics.l_mode()
    color_a=statistics.a_mode()
    color_b=statistics.b_mode()
    print(color_l,color_a,color_b)
    img.draw_rectangle(ROI)
```

## 画图

视觉系统通常需要给使用者提供一些反馈信息。直接在图像中现实出来很直观。

- 颜色可以是灰度值(0-255)，或者是彩色值(r, g, b)的tupple。默认是白色
- 其中的color关键字必须**显示**的标明**color=**

```python
image.draw_line((10,10,20,30), color=(255,0,0))
image.draw_rectangle(rect_tuple, color=(255,0,0))
```

### 画线

image.draw_line(line_tuple, color=White) 在图像中画一条直线

- line_tuple的格式是(x0, y0, x1, y1)，意思是(x0, y0)到(x1, y1)的直线
- 颜色可以是灰度值(0-255)，或者是彩色值(r, g, b)的tupple。默认是白色

### 画框

image.draw_rectangle(rect_tuple, color=White) 在图像中画一个矩形框

- rect_tuple 的格式是 (x, y, w, h)。

### 画圆

image.draw_circle(x, y, radius, color=White) 在图像中画一个圆。

- x,y是圆心坐标
- radius是圆的半径

### 画十字

image.draw_cross(x, y, size=5, color=White) 在图像中画一个十字

- x,y是坐标
- size是两侧的尺寸

### 写字

image.draw_string(x, y, text, color=White) 在图像中写字 8x10的像素

- x,y是坐标。使用\n, \r, and \r\n会使光标移动到下一行。
- text是要写的字符串。
