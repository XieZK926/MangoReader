//
//  XKGradientButton.swift
//  SaaSForDriver
//
//  Created by rober_x on 2019/4/25.
//  Copyright © 2019 xie. All rights reserved.
//

import UIKit

class XKGradientButton: UIButton {

    public var colors: Array<CGColor> = [kColorTint.cgColor,UIColor.hexString("#FF8B8B").cgColor,] {
        didSet {
            gradientLayer.colors = colors
        }
    }
    public var locations: Array<NSNumber> = [0,1] {
        didSet {
            gradientLayer.locations = locations
        }
    }
    
    
//    override func addCorner(radius: CGFloat) {
//        self.layer.cornerRadius = radius
//        self.layer.masksToBounds = true
////        super.addCorner(radius: radius)
////        gradientLayer.cornerRadius = 30
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        layer.addSublayer(gradientLayer)
        self.initUI()
    }
    
    convenience init(frame: CGRect , colors: Array<CGColor>?, _ locations: Array<NSNumber>?) {
        self.init(frame: frame)
        
        layer.addSublayer(gradientLayer)
        guard let colors = colors, let locations = locations else {
            return
        }
        self.colors = colors
        self.locations = locations

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.lightGray
        layer.addSublayer(gradientLayer)
        self.initUI()
    }
    
    
    lazy var gradientLayer: CAGradientLayer = {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1.0, y: 0)
        gradientLayer.frame = CGRect.init(origin: CGPoint.init(), size: self.frame.size)
        gradientLayer.isHidden = !isEnabled
        gradientLayer.cornerRadius = self.frame.size.height / 2
        gradientLayer.masksToBounds = true
        return gradientLayer
    }()
    
    override func setNeedsLayout() {
        gradientLayer.frame = self.bounds
    }
    
    
    override var isEnabled: Bool{
        set{
            super.isEnabled = newValue
            gradientLayer.isHidden = !newValue
        }
        get{
            return super.isEnabled
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.alpha = 0.8
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.alpha = 1
    }
    
    
    
}

extension XKGradientButton {
    fileprivate func initUI() {
        self.locations = [0,1]
        self.colors = [kColorTint.cgColor, UIColor.hexString("#FF8B8B").cgColor]
    }
}
