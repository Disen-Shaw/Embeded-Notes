# 寻找色块
## find_blobs函数
追踪小球是OpenMV用的最多的功能了，通过`find_blobs`函数可以找到色块。
```python
image.find_blobs(thresholds, roi=Auto, x_stride=2, y_stride=1, invert=False, area_threshold=10, pixels_threshold=10, merge=False, margin=0, threshold_cb=None, merge_cb=None)
```
+ thresholds是颜色的阈值
	+ 这个参数是一个列表，可以包含多个颜色。如果只需要一个颜色，那么在这个列表中只需要有一个颜色值，如果想要多个颜色阈值，那这个列表就需要多个颜色阈值
	+ 在返回的色块对象blob可以调用code方法，来判断是什么颜色的色块