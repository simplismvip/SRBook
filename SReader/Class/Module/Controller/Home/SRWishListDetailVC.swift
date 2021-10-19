//
//  SRWishListDetailVC.swift
//  SReader
//
//  Created by JunMing on 2021/6/16.
//  SRWishListDetailVC 展示心愿单详情 --

import UIKit
import ZJMAlertView

class SRWishListDetailVC: SRBaseController, UITableViewDelegate, UITableViewDataSource {
    private let model: SRWishList
    private var dataSource = [(String, String?)]()
    private var commentBtn = UIButton(type: .system)
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(SRWishListDetailViewCell.self, forCellReuseIdentifier: "SRWishListDetailViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = view.backgroundColor
        return tableView
    }()
    
    init(model: SRWishList) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        dataSource.append(contentsOf: model.fetchData())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutSubviews()
        eventHandle()
    }
    
    private func eventHandle() {
        commentBtn.jmAddAction { [weak self](_) in
            if let model = self?.model, let bookid = model.bookid, model.isDone {
                SRNetManager.bookinfo(bookid: bookid) { (result) in
                    switch result {
                    case .Success(let book):
                        self?.push(vc: SRBookDetailController(model: book))
                    default:
                        SRToast.toast("请求结果错误！")
                    }
                }
            } else {
                let alert = UIAlertController(title: "帮TA完成心愿单", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
                let sureAction = UIAlertAction(title: "上传电子书", style: .default) { (action) in
                    
                }
                let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(cancleAction)
                alert.addAction(sureAction)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        commentBtn.titleLabel?.font = UIFont.jmRegular(17.round)
        commentBtn.jmImagePosition(style: UIButton.RGButtonImagePosition.left, spacing: 5)
    }
    
    private func layoutSubviews() {
        title = "心愿单详情"
        
        let headre = SRWishListHeaderView(frame: CGRect.Rect(0, 0, view.jmWidth, 84.round))
        headre.model = model
        tableView.tableHeaderView = headre
        commentBtn.tintColor = UIColor.baseRed
        if model.isDone {
            commentBtn.setImage((model.isDone ? "comment_edit" : "comment_edit").image, for: .normal)
            commentBtn.setTitle(model.isDone ? "去读书" : "帮助TA完成心愿", for: .normal)
        } else {
            commentBtn.isHidden = true
        }
        
        view.addSubview(commentBtn)
        view.addSubview(tableView)
        commentBtn.snp.makeConstraints { (make) in
            make.height.equalTo(44.round)
            make.width.equalTo(view)
            make.centerX.equalTo(view.snp.centerX)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(view.snp.bottom)
            }
        }
        
        tableView.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(commentBtn.snp.top)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == dataSource.count - 1 {
            if let height = dataSource[indexPath.row].1?.height(100, font: UIFont.jmAvenir(16.round)) {
                return height + 20.round
            } else {
                return 0
            }
        }
        return 44.round
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = SRWishListDetailViewCell.dequeueReusableCell(tableView, "SRWishListDetailViewCell") as? SRWishListDetailViewCell {
            cell.config(value: dataSource[indexPath.row])
            return cell
        } else {
            return SRWishListDetailViewCell()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("implemented")
    }
}
