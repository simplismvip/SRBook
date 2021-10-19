//
//  RSBookBaseView.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//

import UIKit
import ZJMKit

class SRBookBaseView: JMBaseView {
    public let cover = SRImageView(frame: .zero)
    public let bookName = UILabel()
    public let author = UILabel()
    public var baseModel: SRModelProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cover)
        addSubview(bookName)
        addSubview(author)
        author.jmConfigLabel(font: UIFont.jmRegular(12))
        bookName.jmConfigLabel(font: UIFont.jmRegular(14), color: .black)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
