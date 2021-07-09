# Andriod工程构成
## 工程构成
### Andioid
工程文件
app：工程文件
Gradle Script：构建脚本

### Project
project：以目录形式展示
#### 主目录三大文件夹
+ idea：工程目录
+ app：核心目录,资源
+ Gradle：构建器
#### 附属文件及文件夹
gradle-wrapper.properties文件：构建器
gradlew：Linux的构建
gradlew.bat：Windows构建
local.properties：SDK格式
settings.gradle：项目中所有的文件
External Libraries：第三方库

build/outputs/apk/debug/app-debug.apk：APK文件
libs：项目中用到的第三方库
src：
andriodTest：安卓测试
main：JAVA和res
res：
drawable开头一般用于存放文件
layout防止布局文件
mipmap一般用于放应用图标
values用于存放样式、颜色等
AndroidManifest.xml：清单文件、注册、图标等
test文件夹：单元测试
.gitignore：模块测试，管理模块
`Gradle目录下的文件是管理工程`




















