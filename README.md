# SRBook

#### 介绍
使用Swift完成的电子书完整项目。本来有好多想加的功能为了赶紧提交上架放弃或屏蔽了，但是提交ipa后发现AppStore上架图书类需要提供出版资质放弃上架。索性把iOS端代码放出来（服务端是Fastapi写的代码暂时不放出来），有需要的同学可以参考下。当然有能上架的方法都小伙伴也可以支支招😁😁😁

#### 截图

## ![001](./srbookimage.png)

![002](./002.png)

#### 软件架构

都是利用业余时间完成的，无论是电子书阅读器组件的代码结构还是主项目的代码结构都有很大的优化空间。本来想利用版本迭代把未添加功能和代码结构优化下，比如全部使用RxSwift替换优化冗余代码，使用Swinject优化组件通信，抽出来显示UI为公共部分单独组件等等。现在没办法上架动力也没有了😂😂😂，不过有想发的同学可以自己搞下！

#### 安装教程

1.  git clone git@github.com:simplismvip/SRBook.git 下载主项目
2.  git clone git@github.com:simplismvip/ZJMKit.git 下载工具组件
3.  git clone git@github.com:simplismvip/Ebook.git 下载电子书解析组件
4.  git clone git@github.com:simplismvip/ZJMAlertView.git 下载弹窗组件
5.  将下载好的组件和主项目放到同一个文件夹下面，名字要和podfile中对应。**(具体看目录结构截图)**
6.  执行pod install 安装所需的第三方库和本地组件

#### 目录结构

![001](./001.png)

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
