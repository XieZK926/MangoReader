//
//  XKReaderTextView.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/27.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class XKReaderTextView: UIView {

    /// 当前页模型(使用contentSize绘制)
    var pageModel: ReadPageModel! {
        didSet{
            frameRef = DZMCoreText.GetFrameRef(attrString: pageModel.content, rect: CGRect(origin: CGPoint.zero, size: kReaderRect.size))
        }
    }
    
    /// 当前页内容(使用固定范围绘制)
    var content:NSAttributedString! {
        
        didSet{
            frameRef = DZMCoreText.GetFrameRef(attrString: content, rect: CGRect(origin: CGPoint.zero, size: kReaderRect.size))
        }
    }
    
    /// CTFrame
    var frameRef:CTFrame? {
        didSet{
            if frameRef != nil { setNeedsDisplay() }
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // 正常使用
        backgroundColor = UIColor.clear
        
        // 可以修改为随机颜色便于调试范围
//        backgroundColor = DZM_COLOR_ARC
    }
    
    /// 绘制
    override func draw(_ rect: CGRect) {
        
        if (frameRef == nil) {return}
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.textMatrix = CGAffineTransform.identity
        
        ctx?.translateBy(x: 0, y: bounds.size.height);
        
        ctx?.scaleBy(x: 1.0, y: -1.0);
        
        CTFrameDraw(frameRef!, ctx!);
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
