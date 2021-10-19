//
//  JMSearchController.swift
//  eBooks
//
//  Created by JunMing on 2019/11/25.
//  Copyright © 2019 赵俊明. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class JMSearchController: UIViewController {
    private let bag = DisposeBag()
    private let searchBar = JMSearchBarView(frame: CGRect.Rect(kWidth, 44.round))
    private let mainView = JMSearchMainView(frame: CGRect.zero)
    private let searchResult = JMSearchResultView(frame: CGRect.zero)
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            }else{
                make.top.equalTo(self.topLayoutGuide.snp.top)
            }
            make.width.equalTo(self.view)
            make.height.equalTo(44.round)
        }
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        view.addSubview(searchResult)
        searchResult.snp.makeConstraints { (make) in
            make.edges.equalTo(self.mainView)
        }
        
        registerEvent()
        searchViewDidScroll()
        regietSearchBarEvent()
    }
    
    private func registerEvent() {
        jmRegisterEvent(eventName: kBookEventSearchDidSelect, block: { [weak self] model in
            if let smodel = model as? JMSearchModel, let bookid = smodel.bookid {
                SRNetManager.bookinfo(bookid: bookid) { (result) in
                    switch result {
                    case .Success(let book):
                        self?.push(vc: SRBookDetailController(model: book))
                    default:
                        SRToast.toast("请求结果错误！")
                    }
                }
            }
        }, next: false)
        
        jmRegisterEvent(eventName: kBookEventHotSearchDidSelect, block: { [weak self] model in
            if let smodel = model as? SRBook {
                self?.push(vc: SRBookDetailController(model: smodel))
            }
        }, next: false)
    }
}

extension JMSearchController {
    func regietSearchBarEvent() {
        // 文本存在的时候隐藏，不存在显示
        // $0.count > 0
        searchBar.textField.rx.text.orEmpty.map { $0.count == 0 }.share(replay: 1).distinctUntilChanged().subscribe(onNext: { [weak self] (mainHide: Bool) in
            self?.switchMainAndListView(mainHide: mainHide)
        }).disposed(by: bag)
        
        // 当文本框内容改变时，将内容输出到控制台上
        searchBar.textField.rx.text.orEmpty.filter { $0.count > 0 }.distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                // self.searchRun($0)
                SRLogger.debug("内容输出:\($0)")
                let querytext = $0
                DispatchQueue.global().async {
                    let data = SRSearchTool.fetchSearchResultData(querytext)
                    DispatchQueue.main.async {
                        self?.searchResult.reloadDatasource(data)
                    }
                }
            }).disposed(by: bag)
        
        // 状态可以组合
        searchBar.textField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { _ in
                SRLogger.debug("开始编辑内容!")
            }).disposed(by: bag)
        
        // 在用户名输入框中按下 return 键
        searchBar.textField.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
            [weak searchBar] in
            searchBar?.textField.becomeFirstResponder()
            SRLogger.debug("search:\($0)")
        }).disposed(by: bag)
        
        // 取消按钮
        searchBar.cancel.rx.tap.subscribe(onNext: { [weak self] in
            SRLogger.debug("Cancle action")
//            if let title = self?.searchBar.textField.text {
//                SRNetManager.weiteHoutSearch(searchKey: title) { (_) in }
//            }
            if let nav = self?.navigationController {
                nav.popViewController(animated: true)
            } else {
                self?.dismiss(animated: true, completion: nil)
            }
        }).disposed(by: bag)
    }
    
    // 监听文本显示/隐藏List
    func switchMainAndListView(mainHide: Bool) {
        SRLogger.debug("mainHide:\(mainHide)")
        self.searchBar.textField.hideClose(mainHide)
        UIView.animate(withDuration: 0.3, animations: {
            self.mainView.alpha = mainHide ? 1:0
            self.searchResult.alpha = mainHide ? 0:1
        }) { (true) in
            self.mainView.isHidden = !mainHide
            self.searchResult.isHidden = mainHide
        }
    }
    
    // 监听滚动
    func searchViewDidScroll() {
        Observable.combineLatest(
            mainView.tableView.rx.contentOffset,
            searchResult.tableView.rx.contentOffset)
            .subscribe(onNext: { [weak self] (_) in
                self?.view.endEditing(true)
        } ).disposed(by: bag)
    }
}
