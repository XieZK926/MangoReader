//
//  SearchViewController.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/5.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
import LYEmptyView
class SearchViewController: UIViewController {
    var bookList: [BookModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainTable)
        setupNavItems()
        let emptyView = LYEmptyView.emptyActionView(withImageStr: "empty", titleStr: "暂无相关书籍", detailStr: "换个关键字试试", btnTitleStr: nil, btnClick: nil)
             emptyView?.contentViewY = 120
        self.mainTable.ly_emptyView = emptyView
        // Do any additional setup after loading the view.
    }
    
    func setupNavItems() {
        self.navigationItem.titleView = titleView
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = searchButton
    }
    
    private lazy var titleView: UITextField = {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 34))
        view.borderStyle = .none
        view.backgroundColor = UIColor.hexString("#f4f4f4")
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.tintColor = kColor333
        view.font = UIFont.systemFont(ofSize: 16)
        let left = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 34))
        left.backgroundColor = kColorLine
        left.image = UIImage(named: "icon_search")
        view.leftView = left
        view.leftViewMode = .always
       return view
    }()
    
    private lazy var backButton: UIBarButtonItem = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn.setImage(UIImage(named: "arrow_back_dark"), for: .normal)
        btn.addTarget(self, action: #selector(popAction), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    @objc func popAction() {
        self.navigationController?.popViewController(animated: true)
    }

    
    private lazy var searchButton: UIBarButtonItem = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 42, height: 30))
        btn.setTitle("搜索", for: .normal)
        btn.setTitleColor(kColor333, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(gotoSearch), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
    }()
    
    @objc func gotoSearch() {
        if titleView.text?.length ?? 0 <= 0 {
            XKToastUtil.showfaildToast(status: "请输入关键字")
            return
        }
        guard let keywords =  titleView.text else {
            return
        }
        XKToastUtil.showLoading(status: nil)
        let params = ["keywords": keywords]
        XKMoyaAdapter.request(XBNetWorkAPI.getBookList(params: params)) { (data, error) in
            XKToastUtil.hiddenLoading()
            if let data = data {
                let jsonData = JSON(data)
                if let mappedObject = [BookModel].deserialize(from: jsonData.description) {
                    self.bookList = mappedObject as! [BookModel]
                    self.mainTable.reloadData()
                }
            }

        }
    }

    
    

     lazy var mainTable: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
            // 设置内容视图的相关属性
//        table.backgroundColor = kMainBgColor
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: "BookTableCell", bundle: nil), forCellReuseIdentifier: "BookTableCell")
        table.tableFooterView = UIView()
        return table
    }()


}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return bookList.count
       }
       
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableCell", for: indexPath) as! BookTableCell
       cell.bookData = bookList[indexPath.row]
       return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       tableView.deselectRow(at: indexPath, animated: true)
       let detail = BookDetailViewController()
       detail.bookId = bookList[indexPath.row].bookId
       self.navigationController?.pushViewController(detail, animated: true)
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 156
   }
    
}
