//
//  SRExtensions+View.swift
//  SReader
//
//  Created by JunMing on 2020/5/1.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
    /// 添加
    func addBottomLine(color: UIColor = .groupTableViewBackground,  _ closure: (_ make: ConstraintMaker) -> Void) {
        let line = UIView()
        line.backgroundColor = color
        addSubview(line)
        line.snp.makeConstraints { closure($0)}
    }
    
    /// 可以设置阴影参数
    func shadowLayer(radius: CGFloat = 5, opacity: Float = 0.1, offSet: CGSize = CGSize.zero) {
        layer.shadowColor = UIColor.textBlack.cgColor
        layer.shadowRadius = radius
        layer.shadowOffset = offSet
        layer.shadowOpacity = opacity
    }
    
    /// 随机设置View
    func randBkgColor() {
        for view in self.subviews {
            view.backgroundColor = UIColor.jmRandColor
        }
    }
}

extension UIViewController {
    func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func present(vc: UIViewController) {
        modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @discardableResult
    func commonAction(title: String? = nil,
                      message: String? = nil,
                      preferredStyle: UIAlertController.Style,
                      stringArray: [String],
                      styleArray: [UIAlertAction.Style],
                      alertSelectBlock: ((Int) -> Void)? = nil) -> UIAlertController {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        for (i, aString) in stringArray.enumerated() {
            let btnAction = UIAlertAction(title: aString, style: styleArray[i] ?? UIAlertAction.Style.default) { _ in
                alertSelectBlock?(i)
            }
            alertVC.addAction(btnAction)
        }
        return alertVC
    }
}

extension UITableViewCell {
    // MARK: - 重用cell
    static func dequeueReusableCell(_ tableView: UITableView, _ identifier: String) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            tableView.register(self, forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        }
        return cell ?? UITableViewCell()
    }
}

extension UIStoryboard {
    class func useVC(name: String, bundle: Bundle? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: name, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: name)
    }
}

extension UIImageView {
    func setImage(url: String?, placeholder: UIImage? = nil, complate: ((UIImage, URL?) -> Void)? = nil ) {
        if let headerUrl = url {
            self.kf.setImage(with: URL(string: headerUrl), placeholder: placeholder) { (result) in
                switch result {
                case .failure(let error):
                    SRLogger.error("%@", error.errorDescription ?? "")
                case .success(let resultImage):
                    complate?(resultImage.image, resultImage.source.url)
                }
            }
        } else {
            self.image = placeholder
        }
    }
}
