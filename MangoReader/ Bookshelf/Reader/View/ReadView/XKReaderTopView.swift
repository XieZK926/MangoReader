//
//  XKReaderTopView.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/27.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class XKReaderTopView: UIView {
    var pageTitle: String? {
        didSet {
            titleLable.text = pageTitle
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLable)
        titleLable.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = kColor666
        return label
    }()
}
