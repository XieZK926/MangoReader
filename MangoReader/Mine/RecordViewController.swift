//
//  RecordViewController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit
import LYEmptyView
class RecordViewController: UIViewController {
    var recordList: [XKRecordModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "浏览记录"
        self.view.addSubview(myTableView)
        let emptyView = LYEmptyView.emptyActionView(withImageStr: "empty", titleStr: "您还没有浏览记录", detailStr: "", btnTitleStr: nil, btnClick: nil)
        emptyView?.contentViewY = 120
        self.myTableView.ly_emptyView = emptyView
        self.initNaviItem()
        // Do any additional setup after loading the view.
    }
    
    func initNaviItem() {
        let barItem = UIBarButtonItem(title: "清空", style: .plain, target: self, action: #selector(clearAllRecord))
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    @objc func clearAllRecord() {
        XKSQLManager.shareManager.deleteAllRecordData()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordList = XKSQLManager.shareManager.getAllRecordFromTable()
        self.myTableView.reloadData()
    }
    
    lazy var myTableView: UITableView = {
        let table = UITableView(frame:CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        table.register(UINib(nibName: "RecordTableViewCell", bundle: nil), forCellReuseIdentifier: "RecordTableViewCell")
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

extension RecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTableViewCell", for: indexPath) as! RecordTableViewCell
        cell.recordModel = recordList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = BookDetailViewController()
        detail.bookId = recordList[indexPath.row].bookId
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
