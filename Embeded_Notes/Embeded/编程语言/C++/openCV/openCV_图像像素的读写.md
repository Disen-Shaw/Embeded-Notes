# opencv 图像的像素读写

知识点：
C++中的像素遍历与访问
+ 数组遍历
+ 指针方式遍历(快)


Python中像素遍历与访问
+ 数组遍历

可以通过遍历图像的横纵来修改像素点的取值


~~~c++
void function_image::Change_Image(Mat &image)
{
	int w = image.cols;
	int h = image.rows;
	int dims = image.channels();
	for(int row=0;row<h;row++)
	{
		for(int col=0;col<w;col++)
		{
			if(dims==1)
			{
				int pv = image.at<uchar>(row,col);
				image.at<uchar>(row,col) = 255-pv;
			}
			if(dims==3)
			{
				Vec3b bgr = image.at<Vec3b>(row,col);
				image.at<Vec3b>(row,col)\[0\]=255-bgr\[0\];
				image.at<Vec3b>(row,col)\[1\]=255-bgr\[1\];
				image.at<Vec3b>(row,col)\[2\]=255-bgr\[2\];
			}
		}
	}

	namedWindow("read and write",WINDOW\_FREERATIO);
	imshow("read and write",image);
	waitKey(0);
}
~~~
指针操作
~~~c++
for(int row=0;row<h;row++)
{
	uchar *current = image.ptr<uchar>(row);
	for(int col=0;col<w;col++)
 	{
		if(dims==1)
		{
			int py = *current;
 			*current++ = 255-py;
		}
		if(dims==3)
		{
			*current++ = 255 - *current;
			*current++ = 255 - *current;
			*current++ = 255 - *current;
 		}
 	}
}
~~~














