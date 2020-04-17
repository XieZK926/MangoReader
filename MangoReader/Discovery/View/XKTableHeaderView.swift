//
//  XKTableHeaderView.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/17.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class XKTableHeaderView: UIView {
//    var didRefresh: ()->Void?
    typealias VoidBlock = ()->Void
    var didTaped: VoidBlock?

    var type: Int = 0
    convenience init(frame: CGRect, type: Int) {
        self.init(frame: frame)
        self.type = type
        initSubView()
    }
    
    func initSubView() {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = kColor333
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview().offset(5)
        }

        let button = UIButton()
        button.setTitle("  换一换", for: .normal)
        button.setImage(UIImage(named: "switch"), for: .normal)
        button.setTitleColor(kColor333, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonDidClicked), for: .touchUpInside)
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview().offset(5)
        }
        
        let button2 = UIControl()
        let btnTitle = UILabel()
        btnTitle.textColor = kColor333
        btnTitle.font = UIFont.systemFont(ofSize: 14)
        btnTitle.text = "查看更多"
        button2.addSubview(btnTitle)
        let btnImg = UIImageView()
        btnImg.image = UIImage(named: "arrow_right")
        button2.addSubview(btnImg)
        button2.addTarget(self, action: #selector(buttonDidClicked), for: .touchUpInside)
        self.addSubview(button2)
        
        button2.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalTo(titleLabel.snp_bottom)
        }
        
        btnTitle.snp.makeConstraints { (make) in
            make.left.centerY
                .equalToSuperview()
        }
        btnImg.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.left.equalTo(btnTitle.snp_right)
        }

        button.isHidden = true
        button2.isHidden = true
        
        switch type {
        case 0:
            titleLabel.text = "24小时热读榜"
            break
        case 1:
            titleLabel.text = "超高好评书籍"
            button.isHidden = false
            break
        case 2:
            titleLabel.text = "人气榜"
            button2.isHidden = false
            break
        default:
            titleLabel.text = "大家都在看"
            button2.isHidden = false
            break
        }
    }
    
    @objc func buttonDidClicked() {
        self.didTaped?()
    }
}
