//
//  SRWishListWriting.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//

import UIKit
import ZJMKit
import RxCocoa
import RxSwift
import ZJMAlertView

// MARK: -- SRWishListWriteVC 填写心愿单 --
class SRWishListWriteVC: SRBaseController {
    private let autoDisposeBag = DisposeBag()
    private let pickerView = SRPickerView()
    private var booktype: String?
    private let input = SRInPutView()
    private let leftTitle = UILabel()
    private let publisher = SRWishListView()
    private let bookpage = SRWishListView()
    private let cover = SRWishListView()

    private let author = SRWishListView()
    private let bookName = SRWishListView()
    private let selectBtn = SRWishListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的心愿单"
        setupSubviews()
        registerMsgEvent()
        observer()
        // keyboardObserver()
    }
    
    func registerMsgEvent() {
        selectBtn.btn.jmAddAction { [weak self](_) in
            self?.selectType()
        }
        
        jmRegisterEvent(eventName: kBookEventPickerViewSelect, block: { [weak self](row) in
            self?.booktype = (row as? String)
            self?.selectBtn.btn.setTitle(self?.booktype, for: .normal)
        }, next: false)
        
        jmBarButtonItem(left: false, title: "保存", image:nil ) { [weak self](_) in
            if let weakself = self {
                JMAlertManager.jmShowAnimation(nil)
                let title = weakself.bookName.textField.text
                let author = weakself.author.textField.text
                let type = weakself.booktype
                let page = Int(weakself.bookpage.textField.text ?? "0")
                let publisher = weakself.publisher.textField.text
                let desc = weakself.input.textView.text
                let cover = weakself.cover.textField.text
                let item = SRWishList(title: title, author: author, booktype: type, descr: desc, cover: cover, publisher: publisher, pages: page)
                SRNetManager.writeWish(wish: item) { (result) in
                    JMAlertManager.jmHide(nil)
                    SRToast.toast("心愿单加速审核中，请耐心等待～")
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // 监听输入变化
    func observer() {
        let auth = author.textField.rx.text.orEmpty.map { $0.count > 0 }.share(replay: 1)
        let name = bookName.textField.rx.text.orEmpty.map { $0.count > 0 }.share(replay: 1)
        let desc = input.textView.rx.text.orEmpty.map { $0.count > 0 }.share(replay: 1)
        let observable = Observable.combineLatest(auth, name, desc) { $0 && $1 && $2 }.share(replay: 1)
        observable.distinctUntilChanged().subscribe(onNext: { [weak self] (bool) in
            self?.navigationItem.rightBarButtonItem?.tintColor = bool ? UIColor.textBlack : UIColor.textGary
            self?.navigationItem.rightBarButtonItem?.isEnabled = bool
        }).disposed(by: autoDisposeBag)
    }
    
    func keyboardObserver() {
        // 键盘已经弹出并是系统键盘，这时候就不用再处理了
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification).subscribe { [weak self](notify) in
            if let frame = notify.element?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self?.changeBottomToolViewStatus(hide: true, height: -(frame.size.height - 64))
            }
        }.disposed(by: autoDisposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification).subscribe { [weak self](notify) in
            self?.changeBottomToolViewStatus(hide: true)
        }.disposed(by: autoDisposeBag)
    }
    
    // MARK: - 显示/隐藏底部工具弹框
    func changeBottomToolViewStatus(hide: Bool, height: CGFloat? = nil){
        var offset: CGFloat = hide ? (0) : -200
        if let height = height { offset = height }
        UIView.animate(withDuration: 0.2) {
            self.input.snp.updateConstraints({ (make) in
                make.bottom.equalTo(self.view.snp.bottom).offset(offset)
            })
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        selectBtn.btn.jmImagePosition(style: .right, spacing: 5)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(false)
    }
}

// MARK: -- Private Method
extension SRWishListWriteVC {
    private func selectType() {
        view.endEditing(false)
        pickerView.snp.updateConstraints { (make) in
            make.top.equalTo(view.snp.bottom).offset(-160.round)
        }
    }
    
    private func setupSubviews() {
        pickerView.dataSource = ["玄幻", "武侠", "科幻", "言情", "教育", "文学", "历史", "其他"]
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            make.height.equalTo(160.round)
            make.top.equalTo(view.snp.bottom)
        }
        
        let listTxt = [("书名","必填项"), ("作者","必填项"), ("类型",""), ("封面","可不填"), ("页数","可不填"), ("出版社","可不填")]
        let listview = [bookName, author, selectBtn, cover, bookpage, publisher]
        
        var temp = view.snp.top
        if #available(iOS 11.0, *) {
            temp = view.safeAreaLayoutGuide.snp.top
        }
        
        for (index, wishView) in listview.enumerated() {
            wishView.config(listTxt[index].0, listTxt[index].1)
            view.addSubview(wishView)
            wishView.snp.makeConstraints { (make) in
                make.left.width.equalTo(view)
                make.height.equalTo(45.round)
                make.top.equalTo(temp)
            }
            temp = wishView.snp.bottom
        }
        
        leftTitle.text = "简介"
        leftTitle.jmConfigLabel(font: UIFont.jmRegular(14.round), color: UIColor.textBlack)
        input.textView.font = UIFont.jmRegular(14.round)
        input.placeholder = "请输入简介。。。"
        view.addSubview(input)
        view.addSubview(leftTitle)
        leftTitle.snp.makeConstraints { (make) in
            make.top.equalTo(temp)
            make.left.equalTo(view).offset(10.round)
            make.width.equalTo(50.round)
            make.height.equalTo(44.round)
        }
    
        input.snp.makeConstraints { (make) in
            make.left.equalTo(leftTitle.snp.right)
            make.top.equalTo(leftTitle)
            make.right.equalTo(view)
            make.height.equalTo(200.round)
        }
    }
}

fileprivate class SRWishListView: JMBaseView {
    private let title = UILabel()
    public let textField = UITextField()
    public let btn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        addSubview(btn)
        addSubview(textField)
        
        btn.setImage("select_btn".image?.origin, for: .normal)
        btn.setTitle("请选择", for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = UIFont.jmRegular(14.round)
        title.jmConfigLabel(font: UIFont.jmRegular(14.round), color: UIColor.textBlack)
        textField.font = UIFont.jmRegular(14.round)
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.round)
            make.top.equalTo(self)
            make.width.equalTo(50.round)
            make.height.equalTo(44.round)
        }
     
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(title.snp.right)
            make.top.bottom.equalTo(title)
            make.right.equalTo(self).offset(-10.round)
        }
        
        btn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(textField)
            make.width.equalTo(80.round)
        }
        
        addLineToView(color: UIColor.menuBkg) { (make) in
            make.left.equalTo(10.round)
            make.right.equalTo(-10.round)
            make.height.equalTo(0.8)
            make.bottom.equalTo(self)
        }
    }
    
    public func config(_ title: String?, _ placeholder: String?) {
        self.title.text = title
        if placeholder == "" {
            textField.isHidden = true
        } else {
            btn.isHidden = true
            textField.placeholder = placeholder
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: SRWishListWriteVC {
    
}
