# CSS 字体属性

定义 **字体系列** 的大小、粗细和文字样式(如斜体)

## 字体系列

CSS 使用 **font-family** 属性定义文本的字体系列

```css
p {
	font-family: "Microsoft YaHei"
}
div {
	font-family: Arial, "Microsoft YaHei"
}
```

- 各种字体之间必须使用逗号隔开
- 一般情况下如果有空格隔开的多个单词组成的字体，加引号
- 尽量使用系统默认自带的字体，保证在任何用户的浏览器中都能够正确显示

## 字体大小

CSS 使用 **font-size** 属性定义字体大小\

```html
p {
	font-size: 20px;
}
```

- px(像素) 大小是网页常用
- 谷歌浏览器文字的默认大小为 16px
- 不同浏览器可能默认显示的字号大小不一致，尽量给一个明确的大小，不要默认
- 可以给 body 指定整个页面的文字大小

## 字体粗细

CSS 使用 **font-weight** 属性设置文本文字的粗细

```css
	.bold {
		font-weight: bold;
	}
```

- normal：正常的字体
- bold：粗体
- bolder：IE5+ 特粗体
- lighter：IE5+ 细体
- number：IE5+ 100|200|300|400|500|600|700|800|900
  - 400 是 normal

实际开发中更推荐 **使用数字加粗或者变细**

## 文字样式

CSS 使用 **font-style** 属性设置文本风格

```css
p {
	font-style: normal;
}
```

- normal：默认值，浏览器会显示标准字样
- italic：浏览器会显示斜体的字体样式

## 字体复合属性

可以把上面的属性样式综合来写，可以更节约代码

```css
body {
	font: font-style font-weight font-size/line-height font-family;
}
```

+ 符合属性顺序不可以颠倒，且各个属性用空格隔开
+ 不需要设置的属性可以省略，**但是必须保留 font-size 和 font-family 属性**

