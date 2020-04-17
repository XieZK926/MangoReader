//
//  BookDetailModel.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/19.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
import HandyJSON

class BookDetailModel: BookModel {
    var chapterlist: ChapterModel?
    var hotlist: Array<BookModel>?
    var score: String?
}
