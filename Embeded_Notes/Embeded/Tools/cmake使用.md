# cmake使用
## 简介
可以生成不同平台对应的makefile文件

## 内容说明
~~~CMakelists
CmAKE_MINMUM_REQUIRED(version xx)	# 版本号定义
PROJETC(xxx)						# 项目名称定义
# ADD_EXECUTABLE(xxx xxx.cxx)			# 添加依赖文件们
AUX_SOURCE_DRICTORY(./ DIR_SRCS)

ADD_EXECUTABLE(main ${DIR_SRCS}$)s
~~~