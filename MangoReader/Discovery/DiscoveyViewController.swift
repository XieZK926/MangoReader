//
//  DiscoveyViewController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit
class DiscoveyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()

        // Do any additional setup after loading the view.
    }
    
    func setupNavItems() {
        self.navigationItem.titleView = scrollMenu
        
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    private lazy var searchButton: UIBarButtonItem = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btn.setImage(UIImage(named: "sousuo"), for: .normal)
        btn.addTarget(self, action: #selector(gotoSearch), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    @objc func gotoSearch() {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    private lazy var titles: [String] = {
           return ["男生", "女生"]
    }()
    
    
    private lazy var viewControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        for index in 0...titles.count-1 {
            let vc = DiscoveryChildViewController()
            
            var type: ChannelType = .male
            switch index {
                case 0:
                    type =  .male
                    break
                case 1:
                    type = .female
                    break
                default:
                    type = .male
                break
            }
            vc.type = type
            addChild(vc)
            vcs.append(vc)
        }
        return vcs
    }()
    
    private lazy var scrollMenu: LCSlideMenu = {
        
        /* -- LCSlideMenu -- */
        let slideMenu = LCSlideMenu(frame: CGRect(x: 0, y: 0, width: 150, height: 40), titles: titles,targetVC:self, childControllers: viewControllers)
        slideMenu.indicatorType = .followText
        slideMenu.titleStyle = .transfrom
        slideMenu.isShowIndicatorView = true
        slideMenu.isNeedMask = false

        slideMenu.coverView.layer.cornerRadius = slideMenu.coverHeight * 0.2
    //        slideMenu.circleIndicatorColor = UIColor.white.cgColor
        slideMenu.selectedColor = kColorTint
        slideMenu.unSelectedColor = UIColor.hexString("#666666")
        slideMenu.indicatorView.backgroundColor = kColorTint
        slideMenu.changeItemTitle(0, old: 1)
        slideMenu.width =  slideMenu.getWidth
        
        return slideMenu
    }()

     lazy var mainScroll: UIScrollView = {
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            // 设置内容视图的相关属性
        scroll.contentSize = CGSize(width: CGFloat(titles.count) * kScreenWidth, height: 0)
        scroll.backgroundColor = kMainBgColor
        scroll.bounces = false
        scroll.isPagingEnabled = true
        scroll.delegate = self
        return scroll
    }()
        
}

extension DiscoveyViewController: UIScrollViewDelegate {
    
}


