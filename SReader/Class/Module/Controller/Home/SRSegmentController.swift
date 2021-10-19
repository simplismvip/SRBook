//
//  SRSegmentController.swift
//  SReader
//
//  Created by JunMing on 2020/3/26.
//  Copyright © 2020 JunMing. All rights reserved.
//  

import UIKit
import JXSegmentedView
import ZJMKit
import RxSwift
import RxCocoa
import ZJMAlertView

class SRSegmentController: UIViewController {
    private var showAD = false
    private let bag = DisposeBag()
    private let segmentedView = JXSegmentedView(frame: CGRect.Rect(0, 0, JMTools.jmWidth(), 44))
    private var vcs = [SRHomeController(vctype: .JINGXUAN),
                       SRHomeController(vctype: .XSMI),
                       SRHomeController(vctype: .TUSHU)]
    private lazy var listContainerView: JXSegmentedListContainerView = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    private var segmentedDataSource: JXSegmentedBaseDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = UIColor.baseRed
        segmentedView.indicators = [indicator]
        
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isItemSpacingAverageEnabled = false
        dataSource.titleSelectedColor = UIColor.baseRed
        dataSource.isTitleZoomEnabled = true
        dataSource.titleSelectedZoomScale = 1.3
        dataSource.isTitleStrokeWidthEnabled = true
        dataSource.isSelectedAnimable = true
        dataSource.titles = ["每日推荐", "小说迷", "精选图书"]
        segmentedDataSource = dataSource
        
        // segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        navigationItem.titleView = segmentedView
        
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        listContainerView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        jmBarButtonItem(left: false, title: nil, image: "book_search".image) { [weak self](_) in
            self?.push(vc: JMSearchController())
        }
        
        jmRegisterEvent(eventName: kBookEventJumpYinSi, block: { [weak self] urlPath in
            if let urlStr = urlPath as? String, let bundle = SRTools.bundlePath(urlStr, "html") {
                let webVC = SRWebViewController()
                webVC.loadRequest(URL(fileURLWithPath: bundle))
                self?.push(webVC)
            }
        }, next: false)
        
        if SRTools.showYinSi() {
            let sheetItem = JMAlertModel(className: "SRComp_YINSI")
            sheetItem.title = "感谢您信任并使用追书阅读器！本服务需联网，申请通知权限用于为您提供数据更新，优惠活动等信息服务，点击同意即表示您同意上述服务，感谢您信任并使用追书阅读器！本服务需联网，申请通知权限用于为您提供数据更新，优惠活动等信息服务，点击同意即表示您同意上述服务,以及《隐私政策》、《服务协议》。"
            sheetItem.sheetType = .center

            let sheetManager = JMAlertManager(superView: view, item: sheetItem)
            sheetManager.update()
        }
        
//        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification).subscribe { (notify) in
//            SRLogger.debug("didEnterBackgroundNotification")
//
//        }.disposed(by: bag)
//
//        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification).subscribe { (notify) in
//            SRLogger.debug("didBecomeActiveNotification")
//            let adBook = SRBookADController()
//            adBook.modalPresentationStyle = .fullScreen
//            self.present(adBook, animated: false, completion: nil)
//        }.disposed(by: bag)
        
        // 监听发送按钮
        NotificationCenter.default.rx.notification(NSNotification.Name(rawValue:"kSendBookUseWiFi")).subscribe { [weak self] (notify) in
            if let model = notify.element?.userInfo?["model"] as? SRBook {
                var ip = "http://192.168.0.10"
                if let nIP = SRTools.getIP() { ip = nIP }
                self?.jmShowAlert(model.title, "请在👇输入对方地址", ip, handler: { text in
                    if let urlStr = text, let localpath = model.localPath(), let urlname = model.urlname {
                        SRNetWork.epub(urlStr, filePath: localpath, fileName: urlname) { status, response, desc in
                            if status { SRTools.setIP(urlStr) }
                            DispatchQueue.main.async(execute: {
                                let toast = status ? "发送成功🐶！" : "发送失败😭"
                                SRToast.toast(toast)
                            })
                            SRLogger.debug(response as Any)
                        }
                    }
                })
            } else {
                SRToast.toast("发送失败😭")
            }
            SRLogger.debug(notify)
        }.disposed(by: bag)
    }
    
    // fix bug: https://juejin.im/post/5e8f1239e51d4546cf777d3b
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !showAD && !SRTools.isVip {
//            let adBook = SRBookADController()
//            adBook.modalPresentationStyle = .fullScreen
//            self.present(adBook, animated: false, completion: nil)
            showAD.toggle()
        }
        
        // 处于第一个item的时候，才允许屏幕边缘手势返回
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

extension SRSegmentController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension SRSegmentController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return vcs[index]
    }
}

