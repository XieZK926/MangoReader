//
//  BookModel.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/5.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
import HandyJSON
class BookModel: HandyJSON {
    var bookId: String?
    var bookName: String?
    var author: String?
    var brief: String?
    var words: CGFloat = 0
    var coverImg: String?
    var category: String?
    var catename: String?
    var keywords: String?
    var visitors: String?
    var lastupdate: String?
    var gender: String?
    var state: String?
    
    required init() {
    }
    
}

//"bookId": 2580,
//"bookName": "千亿遗嘱",
//"author": "左小煮粥",
//"brief": "他愿意牺牲感情，牺牲事业。\r\n 然而，六年后，他却带着未婚妻高
//调回来，指名道姓要她设计婚纱。\r\n 这样还不算，有了名正言顺的未婚妻，却难忘 旧爱，要她给他做情妇?\r\n",
//"words": 34384,
//"coverImg": "http://host/20170515164959-705.jpg", "state": "已完结",
//"category": 40,
//
//"catename": "都市", "isvip": 1,
//"keywords": "宠婚,总裁,", "score": "2.7",
//"visitors": "879 万",
//"lastupdate ": "2017-05-31 10:39:39"， "gender": "男频"
