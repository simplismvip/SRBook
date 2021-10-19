//
//  SRChartsHeaderView.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit

// MARK: -- 表格页Charts headerView --
class SRChartsHeaderView: SRBaseView {
    private let bookName = UILabel()
    
    open var dataSource = [SRBook]() {
        willSet {drawPieChartView(newValue)}
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func drawPieChartView(_ models: [SRBook]) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
