//
//  XKReaderBottomView.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/27.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class XKReaderBottomView: UIView {

    var pageModel: ReadPageModel? {
        didSet {
            pageLabel.text = "本章：第\( pageModel!.page.intValue + 1)/\(pageModel!.totalPage.intValue)页"
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(pageLabel)
        pageLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var pageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = kColor666
        return label
    }()
}
