//
//  SRCommentController.swift
//  SReader
//
//  Created by JunMing on 2020/4/20.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMAlertView
import ZJMKit

// MARK: -- 评论页面 --
class SRCommentController: SRBookBaseController {
    private let commentBtn = UIButton(type: .system)
    private let model: SRBook
    init(model: SRBook) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerEvent()
        layoutSubviews()
        reloadData(name: "comment", local: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        commentBtn.titleLabel?.font = UIFont.jmRegular(17.round)
        commentBtn.jmImagePosition(style: UIButton.RGButtonImagePosition.left, spacing: 5)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        commentBtn.jmAddShadow(UIColor.black)
    }
    
    public func layoutSubviews() {
        jmBarButtonItem(left: false, title: "加入书架", image: nil) { _ in
            SRLogger.debug("加入书架")
        }
        
        title = model.title
        tableView.tableHeaderView = SRCommentHeaderView(frame: CGRect.Rect(view.jmWidth, 150.round))
        
        commentBtn.setImage("comment_edit".image, for: .normal)
        commentBtn.setTitle("写评论", for: .normal)
        commentBtn.tintColor = UIColor.white
        commentBtn.backgroundColor = UIColor.baseRed
        commentBtn.layer.cornerRadius = 10
        
        view.addSubview(commentBtn)
        commentBtn.snp.makeConstraints { (make) in
            make.height.equalTo(34)
            make.width.equalTo(120)
            make.centerX.equalTo(view.snp.centerX)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalTo(view.snp.bottom).offset(-10)
            }
        }
    }

    override func reloadData(name: String? = nil, local: Bool = false, finish: @escaping (Bool) -> Void = { _ in }) {
        if let bookid = model.bookid {
            SRToast.show()
            SRNetManager.comments(bookid: bookid) { (result) in
                SRToast.hide()
                switch result {
                case .Success(let vmodel):
                    if let comments = vmodel.first?.comments {
                        let rate = comments.reduce(0) { $0 + $1.rate }
                        let aveRate = (comments.count > 0) ? (rate/comments.count) : 0
                        let header = self.tableView.tableHeaderView as? SRCommentHeaderView
                        let subtitle = "\(rate)人评分 \(aveRate)分"
                        header?.refashData(model: self.model, subtitle: subtitle)
                    }
                    
                    self.dataSource = vmodel
                    finish(true)
                default:
                    SRLogger.error("请求失败")
                }
                self.tableView.reloadData()
            }
        } else {
            SRToast.toast("请求发生了错误，稍后再试！")
        }
    }
    
    private func registerEvent() {
        commentBtn.jmAddAction(event: .touchUpInside) {[weak self] sender in
            if SRUserManager.isLogin {
                if let model = self?.model {
                    self?.push(vc: SRWriteCommentController(model: model))
                }
            } else {
                self?.login()
            }
        }
        
        // 跳到作者信息
        jmRegisterEvent(eventName: kBookEventAuthorInfo, block: { [weak self] _ in
            if let model = self?.model, model.author != nil {
                self?.push(vc: SRAuthorController(model: model))
            }
        }, next: false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let point = scrollView.panGestureRecognizer.velocity(in: scrollView.panGestureRecognizer.view)
        if point.y > 0 {
           // 下
            UIView.animate(withDuration: 0.8) {
                self.commentBtn.alpha = 1.0
            }
        } else {
            // 上
            UIView.animate(withDuration: 0.8) {
                self.commentBtn.alpha = 0.0
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
