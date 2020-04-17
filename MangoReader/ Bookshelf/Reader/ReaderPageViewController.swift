//
//  ReaderPageViewController.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/18.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
let kTitleViewHeight: CGFloat = 54

let kBottomViewHeight: CGFloat = 44

let kReaderRect: CGRect = CGRect(x: 18, y: kStatusBarHeight + kTitleViewHeight, width: kScreenWidth - 18 * 2, height: kScreenHeight - kStatusBarHeight - kSafeBarHeight - kTitleViewHeight - kBottomViewHeight)

class ReaderPageViewController: UIViewController {
    
    var pageModel: ReadPageModel? {
        didSet {
            readView.pageModel = pageModel
            topView.pageTitle = pageModel?.chapterTitle
            bottomView.pageModel = pageModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = XKReaderConfig.shared().reader_bg_color
        self.view.addSubview(readView)
        self.view.addSubview(bottomView)
        self.view.addSubview(topView)

        // Do any additional setup after loading the view.
        
    }
    
    
    private lazy var readView: XKReaderTextView = {
        let view = XKReaderTextView(frame: kReaderRect)
        return view
    }()
    
    private lazy var topView: XKReaderTopView = {
        let view = XKReaderTopView(frame: CGRect(x: 0, y: kStatusBarHeight, width: kScreenWidth, height: kTitleViewHeight))
        return view
    }()
    
    private lazy var bottomView: XKReaderBottomView = {
        let view = XKReaderBottomView(frame: CGRect(x: 0, y: readView.bottom   , width: kScreenWidth, height: kBottomViewHeight))
          return view
    }()
    
    

}
