//
//  XKAdCoverView.swift
//  MangoReader
//
//  Created by rober_x on 2020/3/3.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
// 广告遮罩层
protocol XKAdCoverViewDelegate {
    func loadAndShowAdView()
}
class XKAdCoverView: UIView {
    var delegate: XKAdCoverViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hiddenView)))
        
        let btn = XKGradientButton(frame: CGRect(x: 0, y: 0, width: kScreenWidth * 0.7, height: 46))
        btn.setTitle("阅读下一章", for: .normal)
        btn.addTarget(self, action: #selector(visitVideoAction), for: .touchUpInside)
        btn.backgroundColor = kColor333
        btn.layer.cornerRadius = 23
        btn.layer.masksToBounds = true
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.setTitleColor(.white, for: .normal)
        self.addSubview(btn)
        btn.center = CGPoint(x: kScreenWidth / 2, y: kScreenHeight - 150)
        
        
        let label = UILabel()
        label.text = "看完30秒小视频，即可阅读下一章"
        label.textColor = kColorLine
        label.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn.snp_bottom).offset(20)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func visitVideoAction() {
        self.delegate?.loadAndShowAdView()
    }
    @objc func hiddenView() {
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            self.alpha = 0
        }) { (co) in
            self.isHidden = true
        }
    }
}
