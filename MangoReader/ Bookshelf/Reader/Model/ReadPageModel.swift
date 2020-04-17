//
//  ReadPageModel.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/27.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class ReadPageModel: UIView {

    /// 当前页内容
    var chapterTitle: String!
    
    /// 当前页内容
    var content:NSAttributedString!

    /// 当前页范围
    var range: NSRange!
    
    /// 当前页序号
    var page: NSNumber!
    
    var totalPage: NSNumber!
    
    var chapterNumber: Int! = 1

    /// 获取显示内容(考虑可能会变换字体颜色的情况)
    var showContent:NSAttributedString! {
        
        let textColor = XKReaderConfig.shared().reader_text_color
        let tempShowContent = NSMutableAttributedString(attributedString: content)
        tempShowContent.addAttributes([.foregroundColor : textColor], range: NSMakeRange(0, content.length))
        return tempShowContent
    }

}
