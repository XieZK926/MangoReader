//
//  BaseResponseModel.swift
//  SaaSForDriver
//
//  Created by rober_x on 2019/5/14.
//  Copyright © 2019 xie. All rights reserved.
//

import UIKit
import HandyJSON
struct BaseResponseModel: HandyJSON {
    var errorCode: String?
    var data: Any?
    var message: String?
    
}
struct XKError: HandyJSON  {
    init() {
    }
    
    
    var errmsg: String?
    var errcode : String?
    
    init(code: String?, msg: String?) {
        self.errcode = code
        self.errmsg = msg
    }
}
