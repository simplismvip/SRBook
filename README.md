# SRBook

#### 介绍
使用Swift完成的电子书项目，已经完成了功能，因App Store上架图书类需要提供出版资质放弃上架。把代码开源出来，有需要的同学可以参考下。

#### 截图

## ![001](./srbookimage.png)

#### 软件架构
软件架构说明

#### 安装教程

1.  git clone git@github.com:simplismvip/SRBook.git 下载主项目
2.  git clone git@github.com:simplismvip/ZJMKit.git 下载工具组件
3.  git clone git@github.com:simplismvip/Ebook.git 下载电子书解析组件
4.  git clone git@github.com:simplismvip/ZJMAlertView.git 下载弹窗组件
5.  将下载好的组件和主项目放到同一个文件夹下面
6.  执行pod install 安装所需的第三方库和本地组件

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


#### 说明

1.  目前完成EPUB和TXT格式解析。支持大部分电子书类app已有的功能。
2.  本来计划在目前的基础上再开出一个页面上架一些PDF图书，阅读器也会添加PDF阅读支持。
3.  面前完成文字转语音，使用苹果提供的框架，但是因为着急上架这个功能没完成把这个屏蔽了。
4.  目前完成Wi-Fi传书功能，让iOS设备成为服务器支持上传图书到app，代码已经添加，功能入口没有添加。
5.  服务端使用是我使用Fastapi开发，主要接口都是可用的。但是封面和图书资源的服务器马上到期了，估计快不能用了。
6.  
