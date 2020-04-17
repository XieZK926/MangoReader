//
//  DZMReadParser.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// 解析完成
typealias DZMParserCompletion = (_ readModel: XKRecordModel?) ->Void

class DZMReadParser: NSObject {
    
    // MARK: -- 内容分页
    
    /// 内容分页
    ///
    /// - Parameters:
    ///   - attrString: 内容
    ///   - rect: 显示范围
    ///   - isFirstChapter: 是否为本文章第一个展示章节,如果是则加入书籍首页。(小技巧:如果不需要书籍首页,可不用传,默认就是不带书籍首页)
    /// - Returns: 内容分页列表
    @objc class func pageing(attrString: NSAttributedString, rect:CGRect, isFirstChapter:Bool = false) ->[ReadPageModel] {
        
        var pageModels:[ReadPageModel] = []
        
//        if isFirstChapter { // 第一页为书籍页面
//
//            let pageModel = ReadPageModel()
//
//            pageModel.range = NSMakeRange(DZM_READ_BOOK_HOME_PAGE, 1)
//
//            pageModel.contentSize = DZM_READ_VIEW_RECT.size
//
//            pageModels.append(pageModel)
//        }
        
        let ranges = DZMCoreText.GetPageingRanges(attrString: attrString, rect: rect)
        if !ranges.isEmpty {
            
            let count = ranges.count
            
            for i in 0..<count {
                
                let range = ranges[i]
                
                let pageModel = ReadPageModel()
                
                let content = attrString.attributedSubstring(from: range)
                pageModel.range = range
                pageModel.content = content
                pageModel.page = NSNumber(value: i)
                pageModel.totalPage = NSNumber(value: count)
                pageModels.append(pageModel)
            }
        }
        
        return pageModels
    }
    
    
    // MARK: -- 内容整理排版
    
    /// 内容排版整理
    ///
    /// - Parameter content: 内容
    /// - Returns: 整理好的内容
    @objc class func contentTypesetting(content: String) ->String {
        
        // 替换单换行
        var content = content.replacingOccurrences(of: "\r", with: "")
        /// 段落头部双圆角空格
         let DZM_READ_PH_SPACE: String = "　　"
        // 替换换行 以及 多个换行 为 换行加空格
        content = content.replaceCharacters(from: "\\s*\\n+\\s*", to: "\n" + DZM_READ_PH_SPACE)
        // 返回
        return content
    }
    
    
    // MARK: -- 解码URL
    
    /// 解码URL
    ///
    /// - Parameter url: 文件路径
    /// - Returns: 内容
    @objc class func encode(url:URL) ->String {
        
        var content = ""
        
        if url.absoluteString.isEmpty { return content }
        
        // utf8
        content = encode(url: url, encoding: String.Encoding.utf8.rawValue)
        
        // 进制编码
        if content.isEmpty { content = encode(url: url, encoding: 0x80000632) }
        
        if content.isEmpty { content = encode(url: url, encoding: 0x80000631) }
        
        if content.isEmpty { content = "" }
        
        return content
    }
    
    /// 解析URL
    ///
    /// - Parameters:
    ///   - url: 文件路径
    ///   - encoding: 进制编码
    /// - Returns: 内容
    @objc class func encode(url:URL, encoding:UInt) ->String {
        
        do{
            return try NSString(contentsOf: url, encoding: encoding) as String
            
        }catch{}
        
        return ""
    }
}
