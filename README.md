# LisheKit
LisheKit 






创建podspec文件，为自己的项目添加pod支持[https://www.cnblogs.com/pengsi/p/6783797.html]

##### 1.上传项目源码:
把项目源码上传到gitHub仓库, https://github.com/PengSiSi/iOS_PSCategory
再clone到本地，如果项目本来就在gitHub的仓库中，直接clone到本地即可.

##### 2.上传项目源码:
用终端命令cd到本地项目目录并执行如下命令:
pod spec create #项目名字#

这时候本地就生成一个#项目名字#.podspec文件

#### 3.用编辑器打开.podspec文件,我用的Xcode打开的.

#### 4.为源代码添加对应的Tag;
`
	git tag '0.0.1' //版本号 
	git push --tags //提交标签
`
#### 5.验证podspec文件:
pod spec lint #项目名字#.podspec --verbose
注意:  任何的警告、错误都是不能被添加到Spec Repo中

#### 6. 通过Trunk推送给Cocoapods服务器:
