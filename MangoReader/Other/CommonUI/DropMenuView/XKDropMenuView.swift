//
//  DropMenuView.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/1.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
let kAnimationDuration = 0.26
let kShowViewHeight: CGFloat = 164

protocol XKDropMenuViewDelegate {
    func menuDidSelectCategoryBy(selectedModel: DPFilterModel?)
}

class XKDropMenuView: UIView {
    
    var delegate: XKDropMenuViewDelegate?

    var titles: Array<CategoryTitle> = [] {
        didSet {
            
        }
    }
    
    private var selectedCateBtn: XKMenuButton?
    private var selectedTypeBtn: XKMenuButton?

    
    convenience init(frame: CGRect, titles: Array<CategoryTitle>) {
        self.init(frame: frame)
        self.titles = titles
        self.addSubview(titlesScrollView)
        self.addSubview(bottomView)
           
    }
    

    
    var selectData: DPFilterModel = DPFilterModel()
    
    private lazy var titlesScrollView: UIView = {
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 42))
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.backgroundColor = .white
        scroll.contentSize = CGSize(width: (titles.count + 1) * 50, height: 0)
        
        for i in 0 ... titles.count {
            var title = "全部"
            if(i != 0) {
                title = titles[i - 1].cat_name!
            }
            let titleBtn = XKMenuButton(frame: CGRect(x: CGFloat(i * 50), y: 0, width: 50, height: 42), title: title)
            if(i == 0) {
                titleBtn.isSelected = true
                selectedCateBtn = titleBtn
            }
            titleBtn.addTarget(self, action: #selector(itemDidClicked(sender:)), for: .touchUpInside)
            titleBtn.tag = 100 + i
            scroll.addSubview(titleBtn)
        }
        return scroll
    }()
    
    private lazy var bottomView: UIView = {
        
        let view = UIView(frame: CGRect(x: 0, y: titlesScrollView.bottom, width: kScreenWidth, height: 42))
        view.backgroundColor = .white
        let topLine = UIView()
        topLine.backgroundColor = kColorLine
        view.addSubview(topLine);
        
        let array = ["按人气", "按评分"]
        let btn = XKMenuButton(frame: CGRect(x: 15, y: 0, width: 0, height: 42), title: "按人气")
        btn .addTarget(self, action: #selector(filterTypeSelected(sender:)), for: .touchUpInside)
        btn.tag = 101
        btn.isSelected = true
        selectedTypeBtn = btn
        view.addSubview(btn)
        
        let sepLine = UIView(frame: .zero)
        sepLine.backgroundColor = UIColor.hexString("#C9C9C9")
        view.addSubview(sepLine)
        
        let btn2 = XKMenuButton(frame: CGRect(x: 15, y: 0, width: 0, height: 42), title: "按评分")
        btn2.tag = 102
       btn2 .addTarget(self, action: #selector(filterTypeSelected(sender:)), for: .touchUpInside)
       view.addSubview(btn2)
        
        btn.snp_makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.height.equalToSuperview()
        }
        
        sepLine.snp_makeConstraints { (make) in
            make.left.equalTo(btn.snp_right).offset(15)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(1)
        }
        
        btn2.snp_makeConstraints { (make) in
            make.left.equalTo(sepLine.snp_right).offset(15)
            make.top.height.equalToSuperview()
            
        }

        
        
        topLine.snp_makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = kColorLine

        view.addSubview(bottomLine);
        bottomLine.snp_makeConstraints { (make) in
           make.leading.trailing.bottom.equalToSuperview()
           make.height.equalTo(1)
        }
        
         
        let openBtn = UIButton(frame: CGRect.zero)
        openBtn.setTitle("筛选", for: .normal)
        openBtn.backgroundColor = UIColor.hexString("#efefef")
        openBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        openBtn.setTitleColor(kColor666, for: .normal)
        openBtn.layer.cornerRadius = 10;
        openBtn.layer.masksToBounds = true
        openBtn .addTarget(self, action: #selector(openDetailFilterView), for: .touchUpInside)
        view.addSubview(openBtn)
        
        openBtn.snp_makeConstraints { (make) in
            make.width.equalTo(42)
            make.height.equalTo(20)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        
        
        

        return view
    }()
    
    
    @objc func itemDidClicked(sender: XKMenuButton) {
        if sender.isSelected {
            return
        }
        print("点击了")
        selectedCateBtn?.isSelected = false
        sender.isSelected = true
        selectedCateBtn = sender
        if(sender.tag == 100) {
            self.selectData.cate_Index = nil
        } else {
            self.selectData.cate_Index = titles[sender.tag - 101]
        }
        self.delegate?.menuDidSelectCategoryBy(selectedModel: selectData)
        
    }
    
    
    @objc func filterTypeSelected(sender: XKMenuButton) {
        if sender.isSelected {
            return
        }
        sender.isSelected = true
        selectedTypeBtn?.isSelected = false
        selectedTypeBtn = sender
        self.selectData.filterType = sender.tag - 100
        self.delegate?.menuDidSelectCategoryBy(selectedModel: selectData)

    }
    
    @objc func openDetailFilterView(sender: UIButton) {
        if(sender.isSelected) {
            hideBackGroundView()
        } else {
            animateForDetailFilter()
        }
    }
    
    private lazy var showView: XKDropView = {
        let view = XKDropView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0))
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
//        view.isOpaque = false
        view.delegate = self
        return view
    }()

    


    
    
    /// 透明背景图
    private lazy var backGroundView: UIView = {
        let view = UIView(frame: CGRect(x:self.x, y: self.y + self.height, width: kScreenWidth, height: kScreenHeight))
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        view.isOpaque = false
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backTapped(sender:))))
        return view
    }()
    
    @objc func backTapped(sender: UITapGestureRecognizer) {
        hideBackGroundView()
    }
    
    
    func animateForDetailFilter() {
        superview?.addSubview(backGroundView)
        backGroundView.addSubview(showView)

        UIView.animate(withDuration: kAnimationDuration, animations: {
            self.backGroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }) { (show) in
            UIView.animate(withDuration: 0.8,
                           delay: 0.1,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 1,
                           options: .curveEaseInOut,
                           animations: {
                            self.showView.height = kShowViewHeight
            }, completion: nil)

        }
    }
    
    func hideBackGroundView() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 2,
                       options: .curveEaseInOut,
                       animations: {
                        self.showView.height = 0
        }, completion: {(show) in
        })
        UIView.animate(withDuration: kAnimationDuration,delay: 0.3, animations: {
            self.backGroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }) { (show) in
            self.backGroundView.removeFromSuperview()
        }

    }
    

}

extension XKDropMenuView: XKDropViewDelegate {
    func detailFilter(view: XKDropView, data: Dictionary<String, Any>) {
        let stateIndex: Int  = data["stateIndex"] as! Int
        let countIndex: Int = data["countIndex"] as! Int
        selectData.state_Index = stateIndex
        selectData.wordsType = countIndex
        self.delegate?.menuDidSelectCategoryBy(selectedModel: selectData)
    }
}
