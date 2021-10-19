//
//  SRBookColumn.swift
//  SReader
//
//  Created by JunMing on 2021/6/11.
//  列布局

import UIKit

final class SRBookColumnVert: SRBookColumnHori {
    
    override public func flowlayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.headerReferenceSize = CGSize.zero
        layout.footerReferenceSize = CGSize.zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        return layout
    }
    
    public override func isScrollEnabled() {
        collectinonView.isScrollEnabled = false
    }
}
