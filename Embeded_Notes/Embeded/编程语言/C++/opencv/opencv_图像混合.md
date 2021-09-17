# opencv 图像混合
## 线性混合理论
$g(x)=(1-\alpha)\int_0 (x)+\alpha \int_1 (x)$

其中 $\alpha$ 的取值范围为0～1之间

### 相关API
```c++
void cv::addWeighted(	inputArray src1, 	// 参数1：输入图像Mat-src1
						double alpha, 		// 参数2：输入图像src1的alpha值
						inputArray src2, 	// 参数3：输入图像Mat-src2
						double beta,		// 参数4：输入图像src2的aplha值
						OutputArray dst,	// 参数5：gamma值
						int dtype = -1		// 参数6：输出混合图像
);
```
$dst(I)=saturate(src1(I)-alpha+src2(I)+beta+gamma)$  
**两个图像的大小和类型必须一致才可以**


