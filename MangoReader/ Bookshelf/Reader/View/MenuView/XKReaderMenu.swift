//
//  XKReaderMenu.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/16.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
let kTopBarHeight: CGFloat = kNavBarHeight
let kBottomMenuHeight: CGFloat = 140 + kSafeBarHeight
let kSettingMenuHeight: CGFloat = 186 + kSafeBarHeight
@objc protocol XKReaderMenuDelegate {
    /// 点击返回
    func backButtonDidClicked()
    /// 点击目录
    func readMenuClickCatalogue(readMenu: XKReaderMenu?)
    /// 点击日夜间
    func readMenuClickDayAndNight(readMenu: XKReaderMenu?)
    /// 点击上一章
    func readMenuClickLastChapter(readMenu: XKReaderMenu?)
    /// 点击下一章
    func readMenuClickNextChapter(readMenu: XKReaderMenu?)
    /// 点击改变字体大小
    func readMenuClickChangeFont(readMenu: XKReaderMenu?, fontSize: CGFloat)
    /// 切换背景色
    func readMenuClickChangeBgColor(readMenu: XKReaderMenu?)
    
}
class XKReaderMenu: NSObject {
    
    /// 控制器
    private weak var vc: ReaderViewController!
    
    /// 阅读主视图
    private weak var contentView: XKReaderContentView?
    
    /// 代理
    private(set) weak var delegate: XKReaderMenuDelegate?
    
    private var isMenuShow: Bool = false
    private var isAnimateComplete:Bool = true

    
    convenience init(vc: ReaderViewController, delegate: XKReaderMenuDelegate) {
        self.init()
        self.vc = vc
        self.delegate = delegate
        self.contentView = vc.contentView
        
        contentView?.addSubview(topView)
        contentView?.addSubview(bottomView)
        contentView?.addSubview(lightnessView)
        contentView?.addSubview(settingView)
        initTapGestureRecognizer()
        
    }
    
    /// 导航栏
    lazy var topView: XKMenuTopView = {
        let view = XKMenuTopView(frame: CGRect(x: 0, y: -kNavBarHeight, width: kScreenWidth, height: kNavBarHeight))
        view.isHidden = !isMenuShow
        view.readMenu = self
        return view
    }()
    
    /// 菜单k栏
    lazy var bottomView: XKMenuBottomView = {
        let view = XKMenuBottomView.sharedView()
        view.readMenu = self
        view.isHidden = !isMenuShow
        view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kBottomMenuHeight)
        return view
    }()
    
    lazy var lightnessView: XKLightSettingView = {
        let view = XKLightSettingView.sharedView()
        view.isHidden = !isMenuShow
        view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kBottomMenuHeight)
        return view
    }()
    
    lazy var settingView: XKReaderSettingView = {
        let view = XKReaderSettingView.sharedView()
        view.isHidden = !isMenuShow
        view.readMenu = self
        view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: kSettingMenuHeight)
        return view
    }()


    

    
    
    // MARK: 日夜间遮盖
    /// 初始化日夜间遮盖
    lazy var cover: UIView = {
        let cover = UIView()
        cover.alpha = 0
        cover.isUserInteractionEnabled = false
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        vc.view.addSubview(cover)
        cover.frame = vc.view.bounds
        return cover
    }()
    
    /// 添加单机手势
    private func initTapGestureRecognizer() {
        // 单击手势
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(touchSingleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        self.contentView?.addGestureRecognizer(singleTap)
    }
    
    // 触发单击手势
    @objc private func touchSingleTap() {
        
        showMenu(isShow: !isMenuShow)
    }
    
     /// 点击这些控件不需要执行手势
    private let ClassStrings:[String] = ["XKMenuTopView","XKMenuBottomView","XKReaderSettingView","XKLightSettingView","UIButton","UIControl","UISlider"]

}


extension XKReaderMenu {
    //
    func showMenu(isShow: Bool)  {
        /// 是不是和原来状态一样
        if(isShow == isMenuShow || !isAnimateComplete) {
            return
        }
        isMenuShow = isShow
        isAnimateComplete = false
        if(isShow) {
            self.bottomView.isHidden = false
            self.topView.isHidden = false
        } else {
            self.showLightnessView(isShow: false)
            self.showSettingView(isShow: false)
        }

        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            self.showTopView(isShow: isShow)
            self.showBottomView(isShow: isShow)
        }) { (complted) in
            self.isAnimateComplete = true
            self.bottomView.isHidden = !isShow
            self.topView.isHidden = !isShow

        }
        
        
    }
    
    func showBottomView(isShow: Bool, animated: Bool = false) {
        if (animated) {
            UIView.animate(withDuration: ANIMATION_DURATION) {
                let y: CGFloat = isShow ? kScreenHeight - kBottomMenuHeight : kScreenHeight
                self.bottomView.y = y
            }
            return
        }
        let y: CGFloat = isShow ? kScreenHeight - kBottomMenuHeight : kScreenHeight
        self.bottomView.y = y
    }
    
    func showTopView(isShow: Bool, animated: Bool = false) {
        if (animated) {
            UIView.animate(withDuration: ANIMATION_DURATION) {
                let y: CGFloat = isShow ? 0 : -kTopBarHeight
                self.topView.y = y
            }
            return
        }
        let y: CGFloat = isShow ? 0 : -kTopBarHeight
        self.topView.y = y
    }
    
    func showLightnessView(isShow: Bool, animated: Bool = false) {
        if(isShow) {
            self.lightnessView.isHidden = false
        }
        if (animated) {
            UIView.animate(withDuration: ANIMATION_DURATION) {
                let y: CGFloat = isShow ? kScreenHeight - kBottomMenuHeight : kScreenHeight
                self.lightnessView.y = y
            }
            return
        }
        let y: CGFloat = isShow ? kScreenHeight - kBottomMenuHeight : kScreenHeight
        self.lightnessView.y = y

    }
    
    func showSettingView(isShow: Bool, animated: Bool = false) {
        if(isShow) {
            self.settingView.isHidden = false
        }
        if animated {
         
            UIView.animate(withDuration: ANIMATION_DURATION) {
                let y: CGFloat = isShow ? kScreenHeight - kSettingMenuHeight : kScreenHeight
                self.settingView.y = y
            }
            return
        }
        let y: CGFloat = isShow ? kScreenHeight - kSettingMenuHeight : kScreenHeight
        settingView.y = y
    }
}


extension XKReaderMenu: UIGestureRecognizerDelegate {
   /// 手势拦截
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
       
       let classString = String(describing: type(of: touch.view!))
       
       if ClassStrings.contains(classString) {
           
           return false
       }
       
       return true
   }
       
}
