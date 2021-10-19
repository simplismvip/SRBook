//
//  SRNavgetionController.swift
//  SReader
//
//  Created by JunMing on 2020/3/26.
//  Copyright © 2020 JunMing. All rights reserved.
//

import UIKit

class SRNavgetionController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        navigationBar.barTintColor = UIColor.white
        navigationBar.shadowImage = UIImage()
//        navigationBar.backgroundColor = UIColor.white
        navigationBar.tintColor = UIColor.textBlack
        navigationBar.isTranslucent = true
//        self.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count == 1 {
            // hidesBottomBarWhenPushed这个属性使用时需要注意 需要满足1、2才有效
            // 1、已经添加到导航控制器的子控制器；
            // 2、最顶部的控制器;
            // 3、https://www.jianshu.com/p/4c94fc74f1e6
            // viewController是将要被push的控制器
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    /*
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
