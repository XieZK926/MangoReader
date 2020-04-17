//
//  CategoryViewController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import MJRefresh
import LYEmptyView
class CategoryViewController: UIViewController {
    var pageIndex: Int = 1
    var genderType: Int = 1
    var selectedModel: DPFilterModel = DPFilterModel()
    var  categoryModel: CategoryModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavItems()
        view.addSubview(mainTable)
        requestCategoryData()
        let emptyView = LYEmptyView.emptyActionView(withImageStr: "empty", titleStr: "没有相关书籍", detailStr: "", btnTitleStr: nil, btnClick: nil)
        emptyView?.contentViewY = 120
        self.mainTable.ly_emptyView = emptyView

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
    
    
    private lazy var scrollMenu: LCSlideMenu = {
        
        /* -- LCSlideMenu -- */
        let slideMenu = LCSlideMenu(frame: CGRect(x: 0, y: 0, width: 150, height: 40), titles: titles,targetVC:self, childControllers: [])
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
        slideMenu.delegate = self
        
        return slideMenu
    }()

     lazy var mainTable: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            // 设置内容视图的相关属性
//        table.backgroundColor = kMainBgColor
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "BookTableCell", bundle: nil), forCellReuseIdentifier: "BookTableCell")
        table.contentInset = UIEdgeInsets(top: 84, left: 0, bottom: 0, right: 0)
        table.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            self?.loadMoreData()
        })
        table.tableFooterView = UIView()
//        table.register(UINib(nibName: "", bundle: nil), forCellReuseIdentifier: "")
        return table
    }()
    
    lazy var dropMenu: XKDropMenuView = {
        let menu = XKDropMenuView(frame: CGRect(x: 0, y: kNavBarHeight, width: kScreenWidth, height: 84), titles: self.categoryModel?.category_list ?? [])
            menu.delegate = self
            return menu
    }()
    
    func requestCategoryData() {
        var params = [
              "type": self.genderType,
              "score": selectedModel.filterType == 2 ? 1 : 0,
              "visitors": selectedModel.filterType != 2 ? 1 : 0,
              "words_type": selectedModel.wordsType,
              "pagecount": 10,
              "p": self.pageIndex
        ] as [String : AnyHashable]
        
        if (selectedModel.cate_Index != nil) {
            params["cat_id"] = selectedModel.cate_Index?.cat_id
        }
        if (selectedModel.state_Index != 0) {
            params["state"] = selectedModel.state_Index
        }
        XKToastUtil.showLoading(status: nil)
        XKMoyaAdapter.request(XBNetWorkAPI.getCategoryData(params: params)) { (data, error) in
            XKToastUtil.hiddenLoading()
            if let data = data {
                let jsonData = JSON(data)
                if let mappedObject = JSONDeserializer<CategoryModel>.deserializeFrom(json: jsonData.description) {
                    self.categoryModel = mappedObject
                    self.mainTable.reloadData()
                    self.mainTable.setContentOffset(CGPoint(x: 0, y: -kNavBarHeight - 84), animated: true)
                    if(self.dropMenu.superview == nil) {
                        self.view.addSubview(self.dropMenu)
                    }
                }
            }
        }
    }
    
    func loadMoreData() {
        self.pageIndex += 1
        var params = [
              "type": self.genderType,
              "score": selectedModel.filterType == 2 ? 1 : 0,
              "visitors": selectedModel.filterType != 2 ? 1 : 0,
              "words_type": selectedModel.wordsType,
              "pagecount": 10,
              "p": self.pageIndex
        ] as [String : AnyHashable]
        
        if (selectedModel.cate_Index != nil) {
            params["cat_id"] = selectedModel.cate_Index?.cat_id
        }
        if (selectedModel.state_Index != 0) {
            params["state"] = selectedModel.state_Index
        }
        XKMoyaAdapter.request(XBNetWorkAPI.getCategoryData(params: params)) { (data, error) in
            self.mainTable.mj_footer?.endRefreshing()
            if let data = data {
                let jsonData = JSON(data)
                if let mappedObject = JSONDeserializer<CategoryModel>.deserializeFrom(json: jsonData.description) {
                    let newList = (self.categoryModel?.list?.data ?? []) + (mappedObject.list?.data ?? [])
                    self.categoryModel?.list?.data = newList
                    self.mainTable.reloadData()
                    if((mappedObject.list?.data?.count ?? 0) == 0) {
                        XKToastUtil.showfaildToast(status: "没有更多了")
                    }
                }
            }
        }
    }
    
    

}

extension CategoryViewController: LCSlideMenuDelegate, XKDropMenuViewDelegate {
    func didSelectedTitleWithIndex(index: Int) {
        print("选中了\(index + 1)")
        self.genderType = index + 1
        self.pageIndex = 1
        requestCategoryData()
    }
    
    func menuDidSelectCategoryBy(selectedModel: DPFilterModel?) {
        guard let model = selectedModel else {
            return
        }
        self.pageIndex = 1
        self.selectedModel = model
        requestCategoryData()
        
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryModel?.list?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableCell", for: indexPath) as! BookTableCell
        cell.bookData = categoryModel?.list?.data?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let bookData = categoryModel?.list?.data?[indexPath.row]
        let detail = BookDetailViewController()
        detail.bookId = bookData?.bookId
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
}
