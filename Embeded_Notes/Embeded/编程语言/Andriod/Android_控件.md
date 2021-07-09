# Android 控件
## TextView
基础属性
1. layout_width：组件的宽度 一般用dp
2. layout_herght：组件的高度
3. id：为组件设置的id
4. text：设置显示的文本
5. textColor：字体颜色
6. textStyle：字体风格 normal(无效果),bold(加粗),italic(斜体)
7. textSize：字体大小，一般单位是sp
8. background：控件的背景颜色，可以是图片
	+ 设置图片：android:background="@+图片的位置"
9. gravity：控件内容的对齐方式TextView中是文字，ImageView是图片

`单位不同主要是用于适配`
### 颜色
以"#"开头
前两位表示透明度
+ 00是纯透明
+ FF是完全不透明

后面六位分别表示红、绿、蓝
实际开发时，text等的内容应该卸载value文件夹的对应文件中
\<string name="对象名">张雷\</strng>
### 带阴影的TextView
设置阴影颜色：android:shadowColor
设置阴影的模糊程度：android:shadowRadius
+ 设为0.1就变成字体颜色了，建议使用3

设置阴影在水平方向偏移：android:shadowDx
设置阴影在竖直方向偏移：android:shadowDy

### 实现跑马灯效果的TextView
内容单行显示：android:singleLine
是否可以获取焦点：android:focusable
控制师徒在触摸模式下是否可以聚焦android:focusableInTouchMode
在哪里省略文本：android:Lellopsize
字幕动画重复次数：android:marqueeRepeatLimit


## Button







