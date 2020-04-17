//
//  ChannelModel.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/17.
//  Copyright © 2020 xb. All rights reserved.
//
// 发现页的model


import UIKit
import HandyJSON

struct ChannelModel: HandyJSON {
    var channelName: String?
    var hotlist: Array<BookModel>?
    var scorelist: Array<BookModel>?
    var visitorslist: Array<BookModel>?
    var recommendlist: Array<BookModel>?
}
