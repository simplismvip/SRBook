//
//  SRUserInfoController.swift
//  SReader
//
//  Created by JunMing on 2020/4/27.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import ZJMKit
import HandyJSON

struct SRUserInfo: HandyJSON {
    var title: String?
    var subtitle: String?
    var photo: String?
    var event: String?
    var type: String?
}

class SRUserInfoController: UITableViewController {
    private var dataSource = [SRUserInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
        registerEvent()
        title = "详细信息"
        tableView.register(RSBookUserInfoCell.self, forCellReuseIdentifier: "RSBookUserInfoCell")
        view.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.estimatedRowHeight = 50
        tableView.separatorColor = view.backgroundColor
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "RSBookUserInfoCell")
        if cell == nil { cell = RSBookUserInfoCell(style: .default, reuseIdentifier: "RSBookUserInfoCell") }
        (cell as? RSBookUserInfoCell)?.model = dataSource[indexPath.row]
        return cell ?? RSBookUserInfoCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = dataSource[indexPath.row].event {
            jmRouterEvent(eventName: event, info: nil)
        }
    }
    
    private func reloadData() {
        let user = SRUserManager.share.user
        let items: [[String: Any]] = [
            ["photo": user.photo ?? "", "title": "头像", "type": "0", "event": "kBookEventPhoto"],
            ["subtitle": user.name, "title": "昵称", "type": "5", "event": "kBookEventNickName"],
            ["subtitle": user.userid ?? "", "title": "账号"],
            ["subtitle": user.level.Level, "title": "等级"],
            ["subtitle": "\(user.bookdou)书豆", "title": "书豆"],
            ["subtitle": user.gender ?? "", "title": "性别", "type": "1", "event": "kBookEventGender"],
            ["subtitle": user.email ?? "", "title": "邮箱", "type": "5", "event": "kBookEventEmail"]]
        dataSource = SRDataTool.parse(items: items)
        tableView.reloadData()
    }
}

extension SRUserInfoController {
    
    private func registerEvent() {
        jmRegisterEvent(eventName: "kBookEventPhoto", block: { [weak self] _ in
            self?.setHeaderUrl()
        }, next: false)
        
        jmRegisterEvent(eventName: "kBookEventNickName", block: { [weak self] item in
            self?.jmShowAlert("输入昵称", "", "请勿输入敏感、非法昵称") { (text) in
                if let text = text {
                    SRNetManager.updateUser(key: "name", value: text) { (result) in
                        SRUserManager.share.user.name = text
                        self?.reloadData()
                    }
                }
            }
        }, next: false)
        
        jmRegisterEvent(eventName: "kBookEventGender", block: { [weak self] item in
            self?.setUserSex()
        }, next: false)
        
        jmRegisterEvent(eventName: "kBookEventEmail", block: { [weak self] _ in
            self?.jmShowAlert("输入邮箱", "", "请输入正确格式邮箱") { (text) in
                if let text = text {
                    SRNetManager.updateUser(key: "email", value: text) { (result) in
                        SRUserManager.share.user.email = text
                        self?.reloadData()
                    }
                }
            }
        }, next: false)
    }
    
    private func setUserSex() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction(title: "男", style: .default) { (action) -> Void in
            SRNetManager.updateUser(key: "gender", value: "男") { (result) in
                SRUserManager.share.user.gender = "男"
                self.reloadData()
            }
        }
        
        let existingPhoto = UIAlertAction(title: "女", style: .default) { (action) -> Void in
            SRNetManager.updateUser(key: "gender", value: "女") { (result) in
                SRUserManager.share.user.gender = "女"
                self.reloadData()
            }
        }

        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(takePhoto)
        alertController.addAction(existingPhoto)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    private func setHeaderUrl() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction(title: "相机拍照", style: .default) { (action) -> Void in
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let existingPhoto = UIAlertAction(title: "使用相册", style: .default) { (action) -> Void in
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }

        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(takePhoto)
        alertController.addAction(existingPhoto)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
}

extension SRUserInfoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = Dictionary(uniqueKeysWithValues: info.map {key, value in (key.rawValue, value)})
        if let image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            if let data = image.jmCompressImage(maxLength: 153600), let image = UIImage(data: data) {
                SRNetManager.upload(image: image) { (result) in
                    switch result {
                    case .Success(let upload):
                        if let headerurl = upload.url {
                            SRNetManager.updateUser(key: "photo", value: headerurl) { (result) in
                                SRUserManager.share.user.photo = headerurl
                                self.reloadData()
                            }
                        }
                    default:
                        SRLogger.error("上传失败！")
                    }
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

class RSBookUserInfoCell: SRComp_BaseCell {
    let nextBtn = UIButton(type: .system)
    let icon = SRImageView(frame: .zero)
    let title = UILabel()
    let subtitle = UILabel()
    var model: SRUserInfo? {
        willSet {
            title.text = newValue?.title
            subtitle.text = newValue?.subtitle
            nextBtn.isHidden = newValue?.event == nil
            icon.setImage(url: newValue?.photo)
            icon.isHidden = newValue?.photo == nil
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(icon)
        addSubview(title)
        addSubview(subtitle)
        addSubview(nextBtn)
        
        nextBtn.setImage("nextbackinfo".image, for: .normal)
        nextBtn.isUserInteractionEnabled = false
        nextBtn.tintColor = UIColor.gray
        
        icon.layer.cornerRadius = 20
        icon.layer.masksToBounds = false
        title.jmConfigLabel(font: UIFont.jmRegular(14), color: UIColor.jmHexColor("#333333"))
        subtitle.jmConfigLabel(font: UIFont.jmRegular(12))
        
        layoutVertical()
    }

    func layoutVertical() {
        nextBtn.snp.makeConstraints { (make) in
            make.right.equalTo(snp.right).offset(-8)
            make.height.equalTo(44)
            make.width.equalTo(34)
            make.centerY.equalTo(snp.centerY)
        }
        
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.height.equalTo(self)
        }
        
        icon.snp.makeConstraints { (make) in
            make.right.equalTo(nextBtn.snp.left)
            make.height.width.equalTo(40)
            make.centerY.equalTo(snp.centerY)
        }
        
        subtitle.snp.makeConstraints { (make) in
            make.right.equalTo(nextBtn.snp.left)
            make.height.equalTo(self)
        }
        
        addBottomLine { (make) in
            make.left.equalTo(snp.left).offset(20)
            make.right.equalTo(snp.right).offset(-20)
            make.height.equalTo(1)
            make.bottom.equalTo(self)
        }
    }
    
    deinit {
        SRLogger.debug("⚠️⚠️⚠️类\(NSStringFromClass(type(of: self)))已经释放")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("⚠️⚠️⚠️ Error")
    }
}
