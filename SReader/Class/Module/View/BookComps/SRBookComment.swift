//
//  RSBookComment.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
// -- 详情页评论 --

import UIKit
import ZJMKit

final class SRBookComment: SRBookBaseView {
    private let commentView = SRBookCommentView() // 昵称
    private let allComment = UIButton(type: .system) // 头像
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        commentView.backgroundColor = UIColor.baseWhite
        commentView.layer.cornerRadius = 8.round
        commentView.layer.masksToBounds = true
        
        allComment.setTitle("查看全部评论", for: .normal)
        allComment.tintColor = UIColor.darkText
        allComment.jmAddAction { [weak self] _ in
            self?.jmRouterEvent(eventName: kBookEventJumpCommentPage, info: nil)
        }
    }
    
    private func setupViews() {
        addSubview(commentView)
        commentView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(10.round)
            make.height.equalTo(100.round)
            make.right.equalTo(self.snp.right).offset(-10.round)
        }
        commentView.remakeContent()
        
        addSubview(allComment)
        allComment.snp.makeConstraints { make in
            make.top.equalTo(commentView.snp.bottom)
            make.height.equalTo(44.round)
            make.left.right.equalTo(commentView)
        }
        
        addBottomLine { (make) in
            make.height.equalTo(3.round)
            make.bottom.left.right.equalTo(self)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        allComment.titleLabel?.font = UIFont.jmAvenir(14.round)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

// 评论数据以SRModel返回，进行了不同字段映射
extension SRBookComment: SRBookContent {
    func refresh<T: SRModelProtocol>(model: T) {
        if let comment = SRViewModel.attachment(model: model)?.comment {
           commentView.refresh(model: comment)
        }
    }
}
