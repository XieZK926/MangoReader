//
//  XKReaderLeftView.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/17.
//  Copyright © 2020 xb. All rights reserved.
//  目录

import UIKit

let READER_LEFT_VIEW_WIDTH: CGFloat = kScreenWidth * 0.8

protocol XKReaderLeftViewDelegate {
    func CatalogueDidSelected(model: ChapterModel?)
}

class XKReaderLeftView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var currentIndex: Int = 0
    
    var bookName: String? {
        didSet {
            self.bookNameLabel.text = bookName
        }
    }
    
    var chapterList: Array<ChapterModel> = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var delegate: XKReaderLeftViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bookNameLabel)
        addSubview(titleLabel)
        addSubview(tableView)
        setupFrames()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bookNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = kColor333
        label.text = ""
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = kColor333
        label.text = "目录"
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "XKCatalogueCell", bundle: nil), forCellReuseIdentifier: "XKCatalogueCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        return tableView
    }()
    
    func setupFrames() {
        bookNameLabel.snp.makeConstraints { (make) in
            make.topMargin.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bookNameLabel.snp_bottom).offset(20)
            make.left.equalToSuperview().offset(15)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom).offset(10)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func updateUI() {
//        self.backgroundColor =
    }
    
    func scrollRecord(index: Int) {
        self.currentIndex = index
        self.tableView.reloadData()
        let indexpath = IndexPath(row: index , section: 0)
        self.tableView.scrollToRow(at: indexpath, at: .middle, animated: true)
    }

}

extension XKReaderLeftView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "XKCatalogueCell", for: indexPath) as! XKCatalogueCell
        cell.chapterData = chapterList[indexPath.row]
        cell.selectionStyle = .none
        if (indexPath.row == currentIndex) {
            cell.chapterName.font = UIFont.boldSystemFont(ofSize: 15)
        } else {
            cell.chapterName.font = UIFont.systemFont(ofSize: 14)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        let model = self.chapterList[indexPath.row]
        self.delegate?.CatalogueDidSelected(model: model)
    }
    
}
