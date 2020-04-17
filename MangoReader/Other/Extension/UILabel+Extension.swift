//
//  UILabel+Extension.swift
//  SaaSForDriver
//
//  Created by rober_x on 2019/5/7.
//  Copyright © 2019 xie. All rights reserved.
//

import UIKit

extension UILabel {
    func changeWordSpace(_ space:CGFloat) -> Void {
//        guard let labelText = self.text else { return }
        let labelText = self.text ?? ""
        let attributedString = NSMutableAttributedString.init(string: labelText)
        
//        .kern 字间距 .paragraphStyle 行间距
        attributedString.addAttribute(.kern, value: space, range: NSMakeRange(0, labelText.length))
        self.attributedText = attributedString;
    }
    
    func changeLinesSpace(_ space:CGFloat) -> Void {
        guard let labelText = self.text else { return }
        
        let attributedString = NSMutableAttributedString.init(string: labelText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        //        .kern 字间距 .paragraphStyle 行间距
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, labelText.length))
        self.attributedText = attributedString;
        self.sizeToFit()
        
    }
    
}
