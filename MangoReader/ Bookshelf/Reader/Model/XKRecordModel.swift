//
//  XKReadModel.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/19.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class XKRecordModel: NSObject {
    var bookId: String?
    var bookName: String?
    var author: String?
    var coverImg: String?
    var brief: String?
    var totalNumber: Int = 9999
    var currentChapter: ChapterModel?
    var buyList: [String]? = []
}
