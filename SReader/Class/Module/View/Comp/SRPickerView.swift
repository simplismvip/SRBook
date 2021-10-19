//
//  SRPickerView.swift
//  SReader
//
//  Created by JunMing on 2020/7/14.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class SRPickerView: SRBaseView {
    open var dataSource: [String]? {
        willSet {
            if let vn = newValue {
                Observable.just(vn)
                .bind(to: pickerView.rx.items(adapter: stringPickerAdapter))
                .disposed(by: autoDisposeBag)
            }
        }
    }

    private let cancle = UIButton(type: .system)
    private let conform = UIButton(type: .system)
    private let autoDisposeBag = DisposeBag()
    private let pickerView = UIPickerView()
    
    // 最简单的pickerView适配器（显示普通文本）
    private let stringPickerAdapter = RxPickerViewStringAdapter<[String]>(
        components: [],
        numberOfComponents: { _,_,_  in 1 },
        numberOfRowsInComponent: { (_, _, items, _) -> Int in
            return items.count},
        titleForRow: { (_, _, items, row, _) -> String? in
            return items[row]}
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
        
        cancle.setTitleColor(UIColor.textGary, for: .normal)
        conform.setTitleColor(UIColor.textGary, for: .normal)
        cancle.setTitle("取消", for: .normal)
        conform.setTitle("确定", for: .normal)
         
        cancle.jmAddAction { [weak self](_) in
            self?.removeViews()
        }
        
        conform.jmAddAction { [weak self](_) in
            self?.removeViews()
            if let row = self?.pickerView.selectedRow(inComponent: 0) {
                self?.jmRouterEvent(eventName: kBookEventPickerViewSelect, info: self?.dataSource?[row] as AnyObject?)
            }
        }
    }
    
    private func layoutViews() {
        addSubview(conform)
        addSubview(cancle)
        addSubview(pickerView)
        cancle.translatesAutoresizingMaskIntoConstraints = false
        conform.translatesAutoresizingMaskIntoConstraints = false
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        cancle.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(self)
        }
        
        conform.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(self)
        }
        
        pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(cancle.snp.bottom)
            make.width.equalTo(self)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(self)
            }
        }
    }
    
    private func removeViews() {
        guard let sView = self.superview else { return }
        self.snp.updateConstraints { (make) in
            make.top.equalTo(sView.snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("implemented")
    }
}
