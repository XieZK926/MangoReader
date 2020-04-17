//
//  ChapterModel.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/5.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
import HandyJSON

struct ChapterModel: HandyJSON {
    var chapterId: String?
    var title: String?
    var add_time: String?
    var words: Int = 0
    var updateTime: String?
    var chapterNumber: Int = 1
    var content: String?
    var currentPage: Int = 0

    var pageModels: [ReadPageModel]? {
        get {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            let config = XKReaderConfig.shared()
            let attributedString = NSAttributedString(string: content!, attributes:
                [NSAttributedString.Key.foregroundColor : config.reader_text_color,
                 NSAttributedString.Key.font : UIFont.systemFont(ofSize: config.fontSize),
                 NSAttributedString.Key.kern : NSNumber(value: 2),
                 NSAttributedString.Key.paragraphStyle: paragraphStyle
                ])
            let models = DZMReadParser.pageing(attrString: attributedString, rect: kReaderRect)
            for model in models {
                model.chapterTitle = title
                model.chapterNumber = chapterNumber
            }
            return models
        }
    }
    /// 总页数
    var pageNumbers: Int {
        get {
            return pageModels?.count ?? 0
        }
    }
    
    
    func updateFontSize() {
        
    }
    
}
//"chapterId": 2870415, "chapterNumber": 319,
//"title": "第三百一十九章 终章", "updateTime": "2019-09-22 15:07:03"
//"add_time": "2019-04-19 12:52:52", "words": 2281,
//int
//int string int datetime
//                            bookId chapterId
//类型 是否必要参数 数值 是
//数值 是
//        "content"
