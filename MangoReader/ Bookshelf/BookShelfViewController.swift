//
//  BookShelfViewController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit

class BookShelfViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        setupNavItems()
    }
    
    func initLayout() {
        
    }
    
    func setupNavItems() {
         self.navigationItem.titleView = scrollMenu
         self.navigationItem.rightBarButtonItem = searchButton
    }
    
    private lazy var searchButton: UIBarButtonItem = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        btn.setImage(UIImage(named: "sousuo"), for: .normal)
        btn.addTarget(self, action: #selector(gotoSearch), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    @objc func gotoSearch() {
        self.navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    private lazy var titles: [String] = {
           return ["书架", "本地"]
    }()
    
    private lazy var viewControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        let vc1 = OnLineChildViewController()
        let vc2 = LocalChildViewController()
        addChild(vc1)
        addChild(vc2)

        vcs.append(vc1)
        vcs.append(vc2)
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
        slideMenu.selectedColor = UIColor.hexString("#ffffff")
        slideMenu.unSelectedColor = UIColor.hexString("#999999")
        slideMenu.indicatorView.backgroundColor = UIColor.hexString("#ffffff")
        slideMenu.changeItemTitle(0, old: 1)
        slideMenu.width =  slideMenu.getWidth
        
        return slideMenu
    }()

    
    
    
    
        

}
