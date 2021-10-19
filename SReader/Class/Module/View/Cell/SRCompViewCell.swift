//
//  SRTableViewCell.swift
//  SReader
//
//  Created by JunMing on 2021/6/10.
//

import UIKit

class SRCompViewCell: UITableViewCell {
    public var content: SRBookContent? // 内容区域
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    func refreshData(model: SRViewModel, row: Int) {
        addContentViewIfNotExist(model)
        configBkgView(model)
        SRBookFactory.refresh(model: model, content: content, row: row)
    }
    
    deinit {
        SRLogger.debug("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}

// Private Method
extension SRCompViewCell {
    private func addContentViewIfNotExist(_ model: SRViewModel) {
        if content == nil {
            let contView = SRBookFactory.content(model: model)
            contentView.addSubview(contView)
            contView.snp.makeConstraints { (make) in
                make.edges.equalTo(contentView)
            }
            content = contView
        }
    }
    
    private func configBkgView(_ model: SRViewModel) {
        
    }
}
