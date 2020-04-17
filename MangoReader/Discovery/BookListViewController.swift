//
//  BookListViewController.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/25.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
enum ListType {
    case highScore
    case hot
    case end
    case recomand
}
class BookListViewController: UIViewController {
    var listType: ListType!
    var bookList: [BookModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(mainTableView)
        self.requestData()

        // Do any additional setup after loading the view.
    }
    
    func requestData() {
        var params: [String: String] = [:]
        switch listType {
        case .highScore:
            self.title = "高分榜"
            params["visitors"] = "1"
        case .end:
            self.title = "完结榜"
            params["state"] = "2"
        case .hot:
            self.title = "热门榜"
            params["is_hot"] = "1"
        case .recomand:
            self.title = "人气榜"
            params["visitors"] = "1"

        case .none:
            self.title = "推荐"
            self.mainTableView.reloadData()
            return
        }
        XKToastUtil.showLoading(status: nil)
        XKMoyaAdapter.request(XBNetWorkAPI.getBookList(params: params)) { (data, error) in
            XKToastUtil.hiddenLoading()
            if let data = data {
                let jsonData = JSON(data)
                if let mappedObject = [BookModel].deserialize(from: jsonData.description) {
                    self.bookList = mappedObject as! [BookModel]
                    self.mainTableView.reloadData()
                }
            }

        }
    }
    
    lazy var mainTableView: UITableView = {
        let table = UITableView(frame:CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        table.register(UINib(nibName: "BookTableCell", bundle: nil), forCellReuseIdentifier: "BookTableCell")
        table.tableFooterView = UIView()
        table.delegate = self
        table.dataSource = self
        return table
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BookListViewController: UITableViewDelegate, UITableViewDataSource {
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
