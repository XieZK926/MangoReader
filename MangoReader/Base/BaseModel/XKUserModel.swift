//
//  XKUser.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/15.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

import HandyJSON

class UserInstance: NSObject {
    private override init() {
        super.init()
    }
    
    static let shared = UserInstance()
    var userId: String?
    
    
//    private var _token: String?
//    var token: String? {
//        set {
//            _token = newValue
//            UserDefaults.standard.set(_token, forKey: USER_TOKEN)
//        }
//        get {
//            if _token != nil  {
//                return _token
//            }
//            return UserDefaults.standard.object(forKey: USER_TOKEN) as? String
//        }
//    }
    
//    var userPhone: String? {
//        set {
//            _userPhone = newValue
//            UserDefaults.standard.set(_userPhone, forKey: USER_PHONE)
//        }
//        get {
//            if _userPhone != nil  {
//                return _userPhone
//            }
//            return UserDefaults.standard.object(forKey: USER_PHONE) as? String
//        }
//    }
    
    
    /// 发起退出请求
    func requestLoginOut(callBack: ((Bool)->Void)?) {
        
    }
    
    /// 清楚登录状态
    func clearLoginData() {
        /// 清除推送绑定
//        if let phone = UserInstance.shared.userPhone {
//            UMessage.removeAlias(phone , type: "phone") { (data, error) in
//                if (error != nil) {
//                    UserInstance.shared.userPhone = nil
//                }
//            }
//        }
        
        /// cookie
        
        /// token
        /// user
//        self.user = nil
        
        
      
        /// 清除本地推送
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    
    
}

struct UserModel: HandyJSON {
   
    var id: String?

    /// 手机号
    var username: String?
    
    /// 公司
    var companyName: String?
    
    /// 昵称name
    var nickName: String?
    
    /// 车牌号
    var licenseNumber: String?

    /// 头像
    var img: String?

    /// 职工号
    var empNo: String?

    /// 用户状态
    var useStatus: String?
    
    /// 驾照资格
    var cardType: String?

    
    
}
