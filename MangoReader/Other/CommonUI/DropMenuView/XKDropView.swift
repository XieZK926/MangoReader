//
//  DropView.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/2.
//  Copyright © 2020 xb. All rights reserved.
//

/// 详细筛选视图
import UIKit

protocol XKDropViewDelegate {
    func detailFilter(view: XKDropView, data: Dictionary<String, Any>)
}

class XKDropView: UIView {
    /// 全选按钮
    private var selectedAllBtn: XKMenuButton?
    
    /// 选中的字数
    private var selectedCountBtn: XKMenuButton?
    /// 选中的状态按钮 连载 || 完结
    private var selectedStateBtn: XKMenuButton?
    
    var delegate: XKDropViewDelegate?
    
//    var filterModel: DPFilterModel? {
//        get {
//
//        }
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubViews() {
        addSubview(topView)
        addSubview(middleView)
        addSubview(bottomView)
    }
    
    lazy var topView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.width, height: 42))
        
        let button = XKMenuButton(frame: CGRect.zero, title: "全部")
        button.addTarget(self, action: #selector(selectAll(sender:)), for: .touchUpInside)
        button.isSelected = true
        view.addSubview(button)
        selectedAllBtn = button
        button.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
        }
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: view.height - 1 , width: view.width, height: 1))
        bottomLine.backgroundColor = kColorLine

        view.addSubview(bottomLine);

        
        return view
    }()
    
    lazy var middleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.topView.bottom, width: self.width, height: 75))
        let array = ["全部","50万字以下", "50-100万字", "100万-200万字", "200万-300万字", "300万字以上"]
        for (index, item) in array.enumerated() {
            var lastEndX: CGFloat = 0
            if let lastBtn = view.viewWithTag(100 + index - 1) {
                lastEndX = lastBtn.x + lastBtn.width
            }
            var height:CGFloat = 0
            if let firstBtn = view.viewWithTag(100) {
                height = firstBtn.height
            }
            let i = index / 3
            let j = index % 3 > 0 ? 1 : 0
            let button = XKMenuButton(frame: CGRect(x: 13 + lastEndX * CGFloat(j), y: 10 + CGFloat(i) * (height + 2) , width: 0, height: view.height), title: item)
            button.sizeToFit()
            button.width += 4
            button.tag = 100 + index
            button.addTarget(self, action: #selector(selectTextCount(sender:)), for: .touchUpInside)
            view.addSubview(button)
            if(index == 0) {
                selectedCountBtn = button
                selectedCountBtn?.isSelected = true
            }

        }
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: view.height - 1 , width: view.width, height: 1))
        bottomLine.backgroundColor = kColorLine

        view.addSubview(bottomLine);

                
        return view
    }()
    
    
    lazy var bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: self.middleView.bottom, width: self.width, height: 42))
        let array = ["全部","连载", "完结"]
        for (index, item) in array.enumerated() {
            var lastEndX: CGFloat = 0
            if let lastBtn = view.viewWithTag(100 + index - 1) {
                lastEndX = lastBtn.x + lastBtn.width
            }
            let button = XKMenuButton(frame: CGRect(x: 13 + lastEndX, y: 0, width: 50, height: view.height), title: item)
            button.sizeToFit()
            button.width += 4
            button.height = view.height
            button.tag = 100 + index
            button.addTarget(self, action: #selector(selectState(sender:)), for: .touchUpInside)
            view.addSubview(button)
            if(index == 0) {
                selectedStateBtn = button
                selectedStateBtn?.isSelected = true
            }

        }
                
        return view
    }()
    

}

extension XKDropView {
    @objc func selectAll(sender: XKMenuButton)  {
        if sender.isSelected {
            return
        }
        // 选择所有 的 全部
        selectedAllBtn?.isSelected  = true
        selectedCountBtn?.isSelected = false
        selectedStateBtn?.isSelected = false
        selectedCountBtn = middleView.viewWithTag(100) as? XKMenuButton
        selectedStateBtn = bottomView.viewWithTag(100) as? XKMenuButton
        selectedCountBtn?.isSelected = true
        selectedStateBtn?.isSelected = true
        
        if let delegate = self.delegate {
            delegate.detailFilter(view: self, data: [
                "stateIndex" : 0,
                "countIndex" : 0
            ])
        }
        
    }
    
    @objc func selectTextCount(sender: XKMenuButton)  {
        if(selectedCountBtn == sender) {
            return
        }

        sender.isSelected = true
        selectedCountBtn?.isSelected = false
        selectedCountBtn = sender
        if (sender.tag - 100 == 0) {
            if(selectedStateBtn!.tag - 100 == 0) {
                selectedAllBtn?.isSelected = true
            }

        } else {
           selectedAllBtn?.isSelected = false
            
        }
        if let delegate = self.delegate {
            delegate.detailFilter(view: self, data: [
                "stateIndex" : selectedStateBtn!.tag - 100,
                "countIndex" : selectedCountBtn!.tag - 100
            ])
        }

        
        

    }
    
    @objc func selectState(sender: XKMenuButton)  {
        if(selectedStateBtn == sender) {
            return
        }
        sender.isSelected = true
        selectedStateBtn?.isSelected = false
        selectedStateBtn = sender

        if (sender.tag - 100 == 0) {
            if(selectedCountBtn!.tag - 100 == 0) {
                selectedAllBtn?.isSelected = true
            }
            
        } else {
            selectedAllBtn?.isSelected = false
        }
        
        if let delegate = self.delegate {
            delegate.detailFilter(view: self, data: [
                "stateIndex" : selectedStateBtn!.tag - 100,
                "countIndex" : selectedCountBtn!.tag - 100
            ])
        }

        
    }

    
    

}
