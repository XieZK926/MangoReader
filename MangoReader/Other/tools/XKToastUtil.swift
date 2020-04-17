//
//  XKToastUtil.swift
//  SaaSForDriver
//
//  Created by rober_x on 2019/5/23.
//  Copyright © 2019 xie. All rights reserved.
//

import UIKit
import SVProgressHUD
class XKToastUtil: NSObject {
//    在appdelegate中初始化
    class func defaultConfig() {
        SVProgressHUD.setDefaultStyle(.light)
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
        SVProgressHUD.setMaximumDismissTimeInterval(20)
        SVProgressHUD.setMaxSupportedWindowLevel(.alert)
    }
    
   
    class func showSuccessToast(status: String) {
        SVProgressHUD.setDefaultMaskType(.none)

        SVProgressHUD.showSuccess(withStatus: status)
        
    }
    
    class func showInfoToast(status: String) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.showInfo(withStatus: status)
    }
    
    class func showfaildToast(status: String) {
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.showError(withStatus: status)
        
    }
    
    class func showLoading(status: String?, mask: Bool = false) {
        SVProgressHUD.setDefaultMaskType(mask ? .gradient : .none)
        SVProgressHUD.show(withStatus: status)    
    }
    
    
    class func hiddenLoading() {
        SVProgressHUD.dismiss()
    }
}

extension BookDetailViewController {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        XKToastUtil.hiddenLoading()
    }
}
