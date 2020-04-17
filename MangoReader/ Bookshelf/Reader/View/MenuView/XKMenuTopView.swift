//
//  XKReaderTopView.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/16.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class XKMenuTopView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var readMenu: XKReaderMenu?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backButton)
        addSubview(titleView)
        addSubview(lineView)
        titleView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(kStatusBarHeight/2)
        }
        
        self.backgroundColor = .white
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var backButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "arrow_back_dark"), for: .normal)
        btn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        btn.frame = CGRect(x: 10, y: kStatusBarHeight, width: 44, height: 44)
        return btn
    }()
    
    lazy var titleView: UILabel = {
        let title = UILabel()
        title.text = ""
        return title
    }()
    
    lazy var rightButton: UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    lazy var lineView: UIView = {
        let line = UIView(frame: CGRect(x: 0, y: self.height - 1, width: kScreenWidth, height: 1))
        line.backgroundColor = kColorLine
        return line
    }()

    
    
    
    @objc private func backAction() {
        readMenu?.delegate?.backButtonDidClicked()
    }
    
    @objc func updateUI() {
        let config = XKReaderConfig.shared()
        self.backgroundColor = config.reader_menu_color
        self.titleView.textColor = config.menu_text_color
        if config.themeType == .night {
            self.lineView.backgroundColor = UIColor.hexString("#505050")
            self.backButton.setImage(UIImage(named: "arrow_back_white"), for: .normal)
        } else {
            self.lineView.backgroundColor = kColorLine
            self.backButton.setImage(UIImage(named: "arrow_back_dark"), for: .normal)
        }
    }

}
