//
//  XiaobiHeader.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import Foundation
import UIKit

import SnapKit
import HandyJSON
import SVProgressHUD
import Kingfisher
import SwiftyJSON
//import SwiftMessages



/// 腾讯开屏广告
let kGDTAppID = "1105344611"
let kGDTPlacementID = "9040714184494018"
let kGDTMobSDKAppId = "1105344611"

#if TEST

let kBaseURL = "http://118.31.169.165/bookapi/Mangguo/"

#else

let kBaseURL = "http://118.31.169.165/bookapi/Mangguo/"

#endif

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

let kColor333 = UIColor.hexString("#333333")
let kColor666 = UIColor.hexString("#666666")
let kColor999 = UIColor.hexString("#999999")
let kColorLightGray = UIColor.hexString("#fafafa")
let kColorLine = UIColor.hexString("#E7E7E7")

let kColorTint = UIColor.hexString("#FD454A")


let kMainGrayTextColor = UIColor.init(red: 0x7d/255.0, green: 0x7d/255.0, blue: 0x7d/255.0, alpha: 1)

let kMainBgColor = UIColor.hexString("#f5f5f5")


/// iphone X, XS, XR
let isIphoneX = kScreenHeight >= 812 ? true : false

let kStatusBarHeight : CGFloat = isIphoneX ? 44 : 20

/// kNavBarHeight
let kNavBarHeight : CGFloat = isIphoneX ? 88 : 64

/// kTabBarHeight
let kTabBarHeight : CGFloat = isIphoneX ? 49 + 34 : 49

let kSafeBarHeight : CGFloat = isIphoneX ? 20 : 0

/// 动画时间
let ANIMATION_DURATION: TimeInterval = 0.2

