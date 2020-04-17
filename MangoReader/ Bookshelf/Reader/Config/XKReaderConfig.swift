//
//  XKReaderConfig.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/17.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
// 阅读器背景颜色
enum ReaderBgColorType {
    case white
    case blue
    case green
    case dark
}

// 主体样式
enum TheameType: Int {
    case day = 0
    case night = 1
}

private let READER_BG_COLORS: [UIColor] = [
    UIColor.hexString("#ffffff"),
    UIColor.hexString("#A3415D"),
    UIColor.hexString("#c8eccd"),
    UIColor.hexString("#001525"),
    UIColor.hexString("#5B3D81"),
    UIColor.hexString("#CFBF8C"),
    UIColor.hexString("#181818")
]

private let READER_TEXT_COLORS: [UIColor] = [
    UIColor.hexString("#333333"),
    UIColor.hexString("#cccccc"),
    UIColor.hexString("#333333"),
    UIColor.hexString("#468096"),
    UIColor.hexString("#bbbbbb"),
    UIColor.hexString("#555555"),
    UIColor.hexString("#808080")
]


private let READER_MENU_COLORS: [UIColor] = [
    UIColor.hexString("#EEEEEE"), /// 日间
    UIColor.hexString("#333333"), /// 夜间
]

private let MENU_TEXT_COLORS: [UIColor] = [
    UIColor.hexString("#666666"), /// 日间
    UIColor.hexString("#ffffff"), /// 夜间
]









private var configure: XKReaderConfig?

class XKReaderConfig: NSObject {
    
    var reader_bg_color: UIColor = READER_BG_COLORS[0]
    var reader_text_color: UIColor = READER_TEXT_COLORS[0]
    
    var reader_menu_color: UIColor = READER_MENU_COLORS[0]
    var menu_text_color: UIColor = MENU_TEXT_COLORS[0]
    
    var fontSize: CGFloat = 16

        /// 背景颜色索引
    var bgColorIndex: Int! = 0 {
        didSet {
            self.reader_bg_color = READER_BG_COLORS[bgColorIndex]
            self.reader_text_color = READER_TEXT_COLORS[bgColorIndex]
        }
    }
    
    var themeType: TheameType = .day {
        didSet {
            self.reader_menu_color = READER_MENU_COLORS[themeType.rawValue]
            self.menu_text_color = MENU_TEXT_COLORS[themeType.rawValue]
        }
    }
    
    var brightness: CGFloat = 0.5
    
    /// 状态栏字体颜色
    var statusTextColor:UIColor! {
        
        // 固定颜色
        return UIColor.hexString("#333333")
    }


    
    /// 保存(使用 DZMUserDefaults 存储是方便配置修改)
    func save() {
        
        let dict = ["bgColorIndex": bgColorIndex ?? 0,
                    "fontSize": fontSize,
                    "themeType": themeType.rawValue,
                    "brightness": brightness
            ] as [String : Any]
    
        XKUserDefaults.setObject(dict, kReaderThemeConfigKey)
    }
    
    /// 获取对象
      class func shared() ->XKReaderConfig {
          
        if configure == nil {
            configure = XKReaderConfig(XKUserDefaults.object(kReaderThemeConfigKey))
        }
        return configure!
      }
      
      init(_ dict:Any? = nil) {
          
          super.init()
          if dict != nil { setValuesForKeys(dict as! [String : Any]) }
          initData(dict)
      }
      
      /// 初始化配置数据,以及处理初始化数据的增删
    private func initData(_ dict: Any?) {
          
          // 背景
        guard let dic = dict as? [String : Any] else {
            return
        }
        if let bgColorIdx =  dic["bgColorIndex"] {
            self.bgColorIndex = bgColorIdx as? Int
        }
        
        if let fontSize = dic["fontSize"] as? CGFloat {
            self.fontSize = fontSize
        }
        
        if let themeType = dic["themeType"] as? Int {
            self.themeType = themeType == 1 ? .night : .day
        }
        
        if let brightness = dic["brightness"] as? CGFloat {
            self.brightness = brightness
        }

          
      }
            
      override func setValue(_ value: Any?, forUndefinedKey key: String) { }

}
