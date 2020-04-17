//
//  CategoryModel.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/24.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
import HandyJSON
struct CategoryModel: HandyJSON {
    var words_screen: [[String: AnyHashable]]?
    var category_list: [CategoryTitle]?
    var list: ListData?
}

struct ListData: HandyJSON {
    var paginate: [String: AnyHashable]?
    var data: [BookModel]?
}

struct CategoryTitle: HandyJSON {
    var cat_name: String?
    var cat_id: String?
}
