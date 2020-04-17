//
//  BaseNavigationController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBarAppearence()
    }
    func setupNavBarAppearence() {
            // 设置导航栏默认的背景颜色
        WRNavigationBar.defaultNavBarBarTintColor = UIColor.hexString("#ffffff")
        
        // 设置导航栏所有按钮的
        WRNavigationBar.defaultNavBarTintColor = UIColor.hexString("#666666")
        WRNavigationBar.defaultNavBarTitleColor = UIColor.hexString("#333333")
        
        // 统一设置导航栏样式
        WRNavigationBar.defaultStatusBarStyle = .default
        
        // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
        WRNavigationBar.defaultShadowImageHidden = false
//            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//
//                                                                                                 forBarMetrics:UIBarMetricsDefault];
//        WRNavigationBar.defaultNavBarBackgroundImage = UIImage(named: "arrow_back_dark")
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -100, vertical: 0), for: .default)
//        UIBarButtonItem.appearance().setBackButtonBackgroundVerticalPositionAdjustment(20, for: .default)
//        UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage(named: "arrow_back_dark"), for: .normal, barMetrics: .default)

    }

}
extension BaseNavigationController{
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
