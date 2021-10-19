//
//  SRWriteCommentController.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit
import RxSwift
import RxCocoa
import ZJMKit

class SRWriteCommentController: SRBaseController {
    private lazy var bag = DisposeBag()
    private let input = SRInPutView()
    private let rate = UILabel()
    private let rateValue: Int = 0
    private let model: SRBook
    init(model: SRBook) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setipViews()
        
        jmBarButtonItem(left: false, title: "发布", image: nil) { [weak self]_ in
            if SRUserManager.isLogin {
                self?.navigationItem.rightBarButtonItem?.isEnabled = false
                guard let bookid = self?.model.bookid else { return }
                guard let rate = self?.rateValue else { return }
                guard let content = self?.input.textView.text else { return }
                SRNetManager.writeComments(bookid: bookid, content: content, rate: rate) { (result) in
                    SRToast.toast("评论内容加速审核中，请耐心等待～")
                    self?.navigationController?.popViewController(animated: true)
                }
                
            } else {
                self?.login()
            }
        }
        
        input.textView.rx.text.orEmpty.map { $0.count == 0 }.share(replay: 1).distinctUntilChanged().subscribe(onNext: { [weak self] (mainHide:Bool) in
            self?.navigationItem.rightBarButtonItem?.isEnabled = !mainHide
        }).disposed(by: bag)
    }
    
    private func setipViews() {
        title = model.title
        view.addSubview(input)
        view.addSubview(rate)
        
        rate.text = "⭐️⭐️⭐️⭐️⭐️"
        rate.textAlignment = .center
        rate.font = UIFont.jmMedium(23)
        rate.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            make.height.equalTo(64)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            } else {
                make.top.equalTo(view.snp.top)
            }
        }
        
        input.snp.makeConstraints { (make) in
            make.top.equalTo(rate.snp.bottom).offset(10)
            make.width.equalTo(view)
            make.height.equalTo(250)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
