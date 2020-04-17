//
//  DPFilterModel.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/2.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
//enum WordCount {
//    case defealt,
//
//}
class DPFilterModel: NSObject {
    ///   男生女生
    var type_Index: Int = 1
    
    /// 类别
    var cate_Index: CategoryTitle?
    
    
    /// 人气 or 评分
    var filterType: Int = 0
    /// 字数
    var wordsType: Int = 0 {
        didSet {
            if(wordsType != 0) {
                self.isDeatilSelectAll = false
            }
        }
    }
    
    /// 状态 完结 连载
    var state_Index: Int = 0 {
        didSet {
            if(state_Index != 0) {
                self.isDeatilSelectAll = false
            }
        }
    }

    
    /// 是否选中全部
    var isDeatilSelectAll: Bool = true {
        didSet {
            if(isDeatilSelectAll) {
                self.state_Index = 0
                self.wordsType = 0
            }
        }

    }
    
    func resetDetailFilter() {
        self.state_Index = 0
        self.wordsType = 0
        isDeatilSelectAll  = true
    }
    
    
    
}
