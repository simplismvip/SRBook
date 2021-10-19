//
//  SRFeedbackController.swift
//  SReader
//
//  Created by JunMing on 2021/7/13.
//

import UIKit
import RxSwift
import RxCocoa
import ZJMAlertView

class SRFeedbackController: SRBaseController {
    private let quesTitle = UILabel()
    private let inputText = SRInPutView()
    private let imageTitle = UILabel()
    private let imageView = SRImageView()
    private let bkgView = UIView()
    private let phone = UITextField()
    private let phoneBkg = UIView()
    private var imageUrl: String?
    private lazy var bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configViews()
        setupEvent()
        view.backgroundColor = UIColor.groupTableViewBackground
    }
    
    private func setupEvent() {
        jmBarButtonItem(left: false, title: "提交", image: nil) { [weak self]_ in
            JMAlertManager.jmShowAnimation(nil)
            let content = self?.inputText.textView.text
            SRNetManager.feedback(content: content, imageUrl: self?.imageUrl, phone: self?.phone.text) { (result) in
                JMAlertManager.jmHide(nil)
                switch result {
                case .Success(let result):
                    SRToast.toast(result.descr ?? "感谢您的反馈和建议！")
                    self?.navigationController?.popViewController(animated: true)
                default:
                    SRLogger.error("上传失败！")
                }
            }
        }
        
        inputText.textView.rx.text.orEmpty
            .map { $0.count == 0 }
            .share(replay: 1)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] (mainHide: Bool) in
                self?.navigationItem.rightBarButtonItem?.isEnabled = !mainHide
            }).disposed(by: bag)
        
        imageView.jmAddblock { [weak self] in
            self?.setHeaderUrl()
        }
    }
    
    private func setupViews() {
        view.addSubview(quesTitle)
        view.addSubview(imageTitle)
        view.addSubview(inputText)
        view.addSubview(bkgView)
        bkgView.addSubview(imageView)
        view.addSubview(phoneBkg)
        phoneBkg.addSubview(phone)
        
        quesTitle.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
            make.height.equalTo(44.round)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalTo(view.snp.top)
            }
        }
        
        inputText.snp.makeConstraints { (make) in
            make.width.left.equalTo(view)
            make.top.equalTo(quesTitle.snp.bottom)
            make.height.equalTo(180.round)
        }
        
        imageTitle.snp.makeConstraints { (make) in
            make.left.width.height.equalTo(quesTitle)
            make.top.equalTo(inputText.snp.bottom)
        }
        
        bkgView.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.top.equalTo(imageTitle.snp.bottom)
            make.height.equalTo(100.round)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(80.round)
            make.centerY.equalTo(bkgView.snp.centerY)
            make.left.equalTo(bkgView).offset(10)
        }
        
        phoneBkg.snp.makeConstraints { (make) in
            make.left.width.equalTo(view)
            make.height.equalTo(44.round)
            make.top.equalTo(bkgView.snp.bottom).offset(10)
        }
        
        phone.snp.makeConstraints { (make) in
            make.left.equalTo(phoneBkg).offset(10)
            make.right.equalTo(phoneBkg.snp.right).offset(-10)
            make.top.bottom.equalTo(phoneBkg)
        }
    }
    
    private func configViews() {
        title = "用户反馈"
        quesTitle.text = "问题和意见"
        quesTitle.jmConfigLabel(font: UIFont.jmRegular(15))
        inputText.placeholder = "请输入意见和建议..."
        inputText.backgroundColor = UIColor.white
        imageTitle.text = "相关问题照片"
        imageTitle.jmConfigLabel(font: UIFont.jmRegular(15))
        phone.placeholder = "联系方式"
        imageView.imageView.image = "add_wallpaper".image
        bkgView.backgroundColor = UIColor.white
        phoneBkg.backgroundColor = UIColor.white
    }
    
    private func setHeaderUrl() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension SRFeedbackController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let info = Dictionary(uniqueKeysWithValues: info.map {key, value in (key.rawValue, value)})
        if let image = info[UIImagePickerController.InfoKey.editedImage.rawValue] as? UIImage {
            if let data = image.jmCompressImage(maxLength: 153600), let image = UIImage(data: data) {
                self.imageView.imageView.image = image
                SRNetManager.upload(image: image) { (result) in
                    switch result {
                    case .Success(let upload):
                        self.imageUrl = upload.url
                    default:
                        SRLogger.error("上传失败！")
                    }
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}
