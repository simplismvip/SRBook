//
//  SRWebViewController.swift
//  SReader
//
//  Created by JunMing on 2020/5/14.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import WebKit
class SRWebViewController: UIViewController {
    let progress = UIProgressView(frame: CGRect.zero)
    lazy private var webView: WKWebView = {
        // 创建网页加载的偏好设置
        let prefrences = WKPreferences()
        prefrences.javaScriptEnabled = false
        
        //配置网页视图
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = prefrences
        
        let web = WKWebView(frame: .zero, configuration: webConfiguration)
        web.navigationDelegate = self
        web.uiDelegate = self
        return web
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.addSubview(progress)
        progress.tintColor = UIColor.blue
        progress.backgroundColor = UIColor.lightGray
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        progress.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }else{
                make.top.equalTo(view.snp.top)
            }
            make.width.equalTo(view)
            make.height.equalTo(2)
        }
    }
    
    func loadRequest(_ url: URL)  {
        webView.load(URLRequest(url: url))
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _ = object as? WKWebView else { return }
        if keyPath == "title" {
            title = webView.title
        }else if keyPath == "estimatedProgress" {
            progress.alpha = 1.0
            progress.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
                    self.progress.alpha = 0
                }) { (finish) in
                    self.progress.setProgress(0, animated: false)
                }
            }
        }
//        else {
//            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//        }
    }
    
    deinit {
        SRLogger.debug("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放")
        webView.removeObserver(self, forKeyPath: "title")
    }
}

// MARK: WKNavigationDelegate
extension SRWebViewController: WKNavigationDelegate {
    // 视图开始载入的时候显示网络活动指示器
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // 载入结束后，关闭网络活动指示器
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension SRWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let targetFrame = navigationAction.targetFrame, !targetFrame.isMainFrame {
            guard let url = navigationAction.request.url else { return nil }
            loadRequest(url)
        }else {
            guard let emailUrl = navigationAction.request.url else { return nil }
            if emailUrl.absoluteString.hasPrefix("mailto:") {
                UIApplication.shared.open(emailUrl, options: [:], completionHandler: nil)
            }
        }
        return nil
    }
}


class SRLoggerController: SRWebViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "错误日志"
//        jmBarButtonItem(title: "发送", image: nil) { [weak self] _ in
//
//        }
    }
}
