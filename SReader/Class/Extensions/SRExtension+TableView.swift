//
//  SRExtension+TableView.swift
//  SReader
//
//  Created by JunMing on 2021/8/3.
//

import UIKit

private let onceToken = "SROnceToken"
private let collectionOnceToken = "collectionOnceToken"
private let SREmptyViewTag = 12345;

// MARK: - Protocol -
protocol SREmptyDataProtocol {
    func configEmptyView() -> UIView?
}

extension SREmptyDataProtocol {
    /// 配置空数据提示图用于展示
    func configEmptyView() -> UIView? {
        if SRGloabConfig.share.isLoding {
            return nil
        } else {
            return SREmptyView()
        }
    }
}

// MARK: - UITableView -
extension UITableView {
    func setEmtpyDelegate(target: SREmptyDataProtocol) {
        self.emptyDelegate = target
        DispatchQueue.once(token: onceToken) {
            let cls = UITableView.self
            let originalSelector = #selector(self.reloadData)
            let swizzledSelector = #selector(self.jm_reloadData)
            guard let originalMethod = class_getInstanceMethod(cls, originalSelector) else { return }
            guard let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else { return }
            let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if didAddMethod {
                class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else{
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    func showEmptyView() {
        if isEmpty() {
            if let view = emptyDelegate?.configEmptyView() {
                if let subView = viewWithTag(SREmptyViewTag) {
                    subView.removeFromSuperview()
                }
                view.tag = SREmptyViewTag;
                addSubview(view)
                view.snp.makeConstraints { (make) in
                    make.width.equalTo(160.round)
                    make.height.equalTo(130.round)
                    make.centerX.equalTo(self.snp.centerX)
                    make.centerY.equalTo(self.snp.centerY).offset(-20)
                }
            }
        } else {
            if let view = viewWithTag(SREmptyViewTag) {
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func jm_reloadData() {
        self.jm_reloadData()
        if isEmpty() {
            if let view = emptyDelegate?.configEmptyView() {
                if let subView = viewWithTag(SREmptyViewTag) {
                    subView.removeFromSuperview()
                }
                view.tag = SREmptyViewTag;
                addSubview(view)
                view.snp.makeConstraints { (make) in
                    make.width.equalTo(160.round)
                    make.height.equalTo(130.round)
                    make.centerX.equalTo(self.snp.centerX)
                    make.centerY.equalTo(self.snp.centerY).offset(-20)
                }
            }
        } else {
            if let view = viewWithTag(SREmptyViewTag) {
                view.removeFromSuperview()
            }
        }
    }
    
    private func isEmpty() -> Bool {
        let secs = dataSource?.numberOfSections?(in: self) ?? 1
        func getEmpty(_ section: Int) -> Bool {
            var isEmpty = true
            for i in 0..<section {
                if let rows = dataSource?.tableView(self, numberOfRowsInSection: i) {
                    if rows > 0 {
                        isEmpty = false
                        break
                    }
                }
            }
            return isEmpty
        }
        return getEmpty(secs)
    }
    
    //MARK:- ***** Associated Object *****
    private struct AssociatedKeys { static var emptyKey = "tableView_emptyViewDelegate" }
    private var emptyDelegate: SREmptyDataProtocol? {
        get { return (objc_getAssociatedObject(self, &AssociatedKeys.emptyKey) as? SREmptyDataProtocol) }
        set {
            if let nv = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.emptyKey, nv, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
}

// MARK: - UICollectionView -
extension UICollectionView {
    func setEmtpyDelegate(target: SREmptyDataProtocol) {
        self.emptyDelegate = target
        DispatchQueue.once(token: collectionOnceToken) {
            let cls = UICollectionView.self
            let originalSelector = #selector(self.reloadData)
            let swizzledSelector = #selector(self.jm_reloadData)
            guard let originalMethod = class_getInstanceMethod(cls, originalSelector) else { return }
            guard let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else { return }
            let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            if didAddMethod {
                class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else{
                method_exchangeImplementations(originalMethod, swizzledMethod)
            }
        }
    }
    
    @objc func jm_reloadData() {
        self.jm_reloadData()
        if isEmpty() {
            if let view = emptyDelegate?.configEmptyView() {
                if let subView = viewWithTag(SREmptyViewTag) {
                    subView.removeFromSuperview()
                }
                view.tag = SREmptyViewTag;
                view.center = self.center
                addSubview(view)
            }
        }else {
            if let view = viewWithTag(SREmptyViewTag) {
                view.removeFromSuperview()
            }
        }
    }
    
    private func isEmpty() -> Bool {
        let secs = dataSource?.numberOfSections?(in: self) ?? 1
        func getEmpty(_ section:Int) -> Bool {
            var isEmpty = true
            for i in 0..<section {
                if let rows = dataSource?.collectionView(self, numberOfItemsInSection: i) {
                    if rows > 0 {
                        isEmpty = false
                        break
                    }
                }
            }
            return isEmpty
        }
        return getEmpty(secs)
    }
    
    //MARK:- ***** Associated Object *****
    private struct AssociatedKeys { static var emptyKey = "tableView_emptyViewDelegate" }
    private var emptyDelegate: SREmptyDataProtocol? {
        get { return (objc_getAssociatedObject(self, &AssociatedKeys.emptyKey) as? SREmptyDataProtocol) }
        set {
            if let nv = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.emptyKey, nv, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }
}
