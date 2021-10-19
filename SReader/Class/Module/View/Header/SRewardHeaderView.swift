//
//  SRRewardHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit
import ZJMKit

// MARK: -- Reward打赏 headerView --
class SRewardHeaderView: SRBaseView {
    let cover = SRImageView(frame: .zero)
    let myPayTitle = UILabel()
    let myPaySubtitle = UILabel()
    let myListTitle = UILabel()
    let myListSubtitle = UILabel()
    let bottomTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cover)
        addSubview(myPayTitle)
        addSubview(myPaySubtitle)
        addSubview(myListTitle)
        addSubview(myListSubtitle)
        addSubview(bottomTitle)
        setupView()
        bottomTitle.text = "现在打赏，争取排名上榜哦！"
        myPayTitle.text = "0"
        myPaySubtitle.text = "我的打赏值"
        myListTitle.text = "未上榜"
        myListSubtitle.text = "我的排名"
        
        myPayTitle.jmConfigLabel(font: UIFont.jmAvenir(16.round), color: .black)
        myPaySubtitle.jmConfigLabel(font: UIFont.jmAvenir(12.round))
        myListTitle.jmConfigLabel(font: UIFont.jmAvenir(16.round), color: .black)
        myListSubtitle.jmConfigLabel(font: UIFont.jmAvenir(12.round))
        bottomTitle.jmConfigLabel(font: UIFont.jmAvenir(13.round))
        cover.showShadow = true
    }
    
    public func configData(_ model: SRBook, ranks: [Int]) {
        cover.setImage(url: model.coverurl())
        if let bookid = model.bookid {
            SRNetManager.reward(bookid: bookid) { result in
                switch result {
                case .Success(let reward):
                    self.myPayTitle.text = "\(reward.totalPay ?? 0)"
                    if (reward.totalPay ?? 0) >= (ranks.last ?? 0) {
                        self.myListTitle.text = "1"
                        self.bottomTitle.text = "太棒了，您现在排名第1！"
                    } else {
                        for (index, rank) in ranks.enumerated() {
                            if rank >= (reward.totalPay ?? 0) {
                                self.myListTitle.text = "\(index)"
                                self.bottomTitle.text = "您现在排名第\(index)，再接再厉！"
                                break
                            }
                        }
                    }
                default:
                    SRLogger.debug("")
                }
            }
        }
    }
    
    private func setupView() {
        cover.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20.round)
            make.top.equalTo(self).offset(8.round)
            make.width.equalTo(55.round)
            make.height.equalTo(72.round)
        }
        
        myPayTitle.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(20.round)
            make.top.equalTo(cover)
            make.height.equalTo(24.round)
            make.width.equalTo(120.round)
        }
        
        myPaySubtitle.snp.makeConstraints { (make) in
            make.left.equalTo(myPayTitle)
            make.top.equalTo(myPayTitle.snp.bottom)
            make.height.equalTo(24.round)
            make.width.equalTo(myPayTitle)
        }
        
        myListTitle.snp.makeConstraints { (make) in
            make.left.equalTo(myPayTitle.snp.right).offset(20.round)
            make.top.equalTo(cover)
            make.height.equalTo(24.round)
            make.width.equalTo(60.round)
        }
        
        myListSubtitle.snp.makeConstraints { (make) in
            make.left.equalTo(myListTitle)
            make.top.equalTo(myListTitle.snp.bottom)
            make.height.equalTo(myListTitle)
            make.width.equalTo(myListTitle)
        }
        
        bottomTitle.snp.makeConstraints { (make) in
            make.left.equalTo(cover.snp.right).offset(20.round)
            make.height.equalTo(24.round)
            make.top.equalTo(myPaySubtitle.snp.bottom)
        }
        
        addBottomLine { (make) in
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.height.equalTo(5)
            make.bottom.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
