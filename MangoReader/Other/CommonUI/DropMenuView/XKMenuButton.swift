//
//  XKMenuButton.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/2.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class XKMenuButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    convenience init(frame: CGRect, title: String) {
        self.init(frame: frame)
        let boldString =  NSAttributedString.init(string: title, attributes:  [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : kColorTint])
        
        let normalString =  NSAttributedString.init(string: title, attributes:  [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : kColor666])
        self.setAttributedTitle(normalString, for: .normal)
        self.setAttributedTitle(boldString, for: .selected)
    }
        
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
}
