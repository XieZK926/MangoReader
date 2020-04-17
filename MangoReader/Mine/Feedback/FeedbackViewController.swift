//
//  FeedbackViewController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {
    private let topBarHeight: CGFloat = 49
    private var moveLine : UIView?
    private var buttonArray: Array<UIButton> = []
    private var controllers: Array<UIViewController> = []
    private var selectedButton: UIButton?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(titleView)
        self.view.addSubview(mainScroll)
        setupSubChildren()
        title = "问题反馈"

        // Do any additional setup after loading the view.
    }
    
    lazy var titleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenWidth, height: topBarHeight))
        view.backgroundColor = kColorLine;
        let array = ["产品问题", "缺少书籍"]
        for i in 0 ..< 2 {
            let button = XKMenuButton(frame: CGRect(x: CGFloat(i) * (kScreenWidth / 2), y: 0, width: kScreenWidth / 2, height: view.height), title: array[i])
            button.addTarget(self, action: #selector(menuItemClicked(sender:)), for: .touchUpInside)
            buttonArray.append(button)
            button.tag = 100 + i
            button.backgroundColor = UIColor.white
            view.addSubview(button)
            if (i == 0) {
                selectedButton = button
                selectedButton?.isSelected = true
            }
        }

        moveLine = UIView(frame: CGRect(x: 0, y: view.height - 3, width: kScreenWidth/2, height: 3))
        moveLine?.backgroundColor = kColorTint
        view.addSubview(moveLine!)
        
        let lineView = UIView(frame: CGRect(x: 0, y: view.height - 1, width: kScreenWidth, height: 1))
        lineView.backgroundColor = kColorLine
        view.addSubview(lineView)
        

        return view
    }()
    
    lazy var mainScroll: UIScrollView = {
        let scroll = UIScrollView(frame: CGRect(x: 0, y: kNavBarHeight + topBarHeight, width: kScreenWidth, height: kScreenHeight - kNavBarHeight - topBarHeight))
            // 设置内容视图的相关属性
        scroll.contentSize = CGSize(width: CGFloat(2) * kScreenWidth, height: 0)
        scroll.backgroundColor = kMainBgColor
        scroll.bounces = false
        scroll.isPagingEnabled = true
        scroll.delegate = self
        if #available(iOS 11.0, *) {
            scroll.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return scroll
    }()
    
    func setupSubChildren() {
        let vc1 =  AppProblemsViewController()
    
        self.addChild(vc1)
        

        vc1.view.frame = CGRect(x: 0, y: 0, width: mainScroll.bounds.width, height: mainScroll.bounds.height)
        
        mainScroll.addSubview(vc1.view)

        
        let vc2 =  BookRegisterViewController()
        self.addChild(vc2)
        controllers = [vc1, vc2]
   
    }
    
    @objc func menuItemClicked(sender: UIButton) {
        if (sender == selectedButton) {
            return
        }
        sender.isSelected = true
        selectedButton?.isSelected = false
        selectedButton = sender
        UIView.animate(withDuration: 0.26) {
            self.moveLine?.x = sender.x
        }
        mainScroll.setContentOffset(CGPoint(x: CGFloat(sender.tag - 100) * mainScroll.bounds.width, y: 0), animated: false)
    }
    
}

extension FeedbackViewController: UIScrollViewDelegate {
     // 当scrollview处于滚动状态时, offset发生改变,就会调用此函数. 直到停止.
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
          
            
            //计算偏移的相对位移
            // 根据滚动视图的横向移动数值 和 宽度值 ,计算当前页码
            let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)

    //        let relativeLacation = mainScrollView.contentOffset.x / mainScrollView.frame.width - CGFloat(leftIndex)
    //        if relativeLacation == 0 { return }
    //        //更新UI
    //        updateTitleStyle(relativeLacation)
            
            
            let newVc = controllers[currentPage];
            
            if let _ = newVc.view.superview {
                return
            } else {
                newVc.view.frame = CGRect(x: CGFloat(currentPage) * mainScroll.bounds.width , y: 0, width: mainScroll.bounds.width, height: mainScroll.bounds.height)
                mainScroll.addSubview(newVc.view)
            }
        }
        
        // 结束减速时触发（减速到停止）
        public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

            // 根据滚动视图的横向移动数值 和 宽度值 ,计算当前页码
            let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            
            /// 当前item
            let currentItem = buttonArray[currentPage]
            
            /// 点击
            menuItemClicked(sender: currentItem)
            
        }}







