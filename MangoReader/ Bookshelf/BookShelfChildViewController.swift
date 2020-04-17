//
//  BookShelfChildViewController.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/25.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
import LYEmptyView

class BookShelfChildViewController: UIViewController {
    var bookList: [BookModel] = []
    var recordModel: XKRecordModel?
    private var bookImageView: UIImageView!
    private var bookNameLabel: UILabel!
    private var authorLabel: UILabel!
    private var briefLabel: UILabel!
    private var continueBtn: UIControl!
    private var placeLabel: UILabel!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bookList = XKSQLManager.shareManager.fetchAllDataFromShelf()
        recordModel = XKSQLManager.shareManager.getFirstRecordFromTable()
        self.updateRecord()
        self.collectionView.reloadData()
        self.navBarShadowImageHidden = true
    }
    
    func updateRecord() {
        if let record = self.recordModel {
            self.bookImageView.kf.setImage(with: URL(string: record.coverImg ?? ""), placeholder: UIImage(named: "book_placeholder"))
            bookNameLabel.text = record.bookName
            authorLabel.text = String(format: "作者 | %@", record.author!)
            briefLabel.text = record.brief

            self.bookImageView.isHidden = false
            self.bookNameLabel.isHidden = false
            self.authorLabel.isHidden = false
            self.briefLabel.isHidden = false
            self.continueBtn.isHidden = false
            
            self.placeLabel.isHidden = true

        } else {
            self.bookImageView.isHidden = true
            self.bookNameLabel.isHidden = true
            self.authorLabel.isHidden = true
            self.briefLabel.isHidden = true
            self.continueBtn.isHidden = true
            
            self.placeLabel.isHidden = false

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collectionView)
        collectionView.addSubview(headerView)
        let emptyView = LYEmptyView.emptyActionView(withImageStr: "empty", titleStr: "您的书架还是空的", detailStr: "快去添加吧", btnTitleStr: "去发现", btnClick: {
            if let tab = UIApplication.shared.windows[0].rootViewController as? MainViewController {
                tab.selectedIndex = 1
            }
        })
        emptyView?.contentViewY = 50
        emptyView?.actionBtnBackGroundColor = kColor333
        emptyView?.actionBtnCornerRadius = 20
        emptyView?.actionBtnTitleColor = .white
        emptyView?.actionBtnWidth = 140
        self.collectionView.ly_emptyView = emptyView
        
        self.navigationItem.rightBarButtonItem = searchButton
        
        if !XKUserDefaults.bool(IS_FIRST_ENTER) {
            XKModal.shared.tapOutsideToDismiss = false
            let view = StartAlertView.sharedView()
            view.delegate = self
            XKModal.shared.show(contentView: view)
        }

        // Do any additional setup after loading the view.
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
    
    lazy var collectionView: UICollectionView = {
        let spaceW: CGFloat = 20, startX: CGFloat = 20
        let spaceH: CGFloat = 10
        let itemW: CGFloat = (kScreenWidth - startX * 2 - spaceW * 2) / 3
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: itemW, height: itemW * 1.34 + 30)
        layout.sectionInset = UIEdgeInsets(top: 30, left: spaceW, bottom: 10, right: spaceW)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = spaceH

        let collction = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), collectionViewLayout: layout)
        collction.register(UINib(nibName: "BookItemCell", bundle: nil), forCellWithReuseIdentifier: "BookItemCell")
        collction.delegate = self
        collction.dataSource = self
        collction.contentInset = UIEdgeInsets(top: 184, left: 0, bottom: 0, right: 0)
        collction.backgroundColor = .white
        return collction
    }()
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: -184, width: kScreenWidth, height: 174))
        view.backgroundColor = .white
        
        let bookInfoView = UIView()
        bookInfoView.backgroundColor = .white
        view.addSubview(bookInfoView)
        
        bookInfoView.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        bookInfoView.layer.cornerRadius = 5
        bookInfoView.layer.shadowOpacity = 0.2
        bookInfoView.layer.shadowColor = UIColor.hexString("#213021").cgColor
        bookInfoView.layer.shadowRadius = 6
        bookInfoView.layer.shadowOffset = CGSize(width: 2, height: 2)
                
        let bookImage = UIImageView()
        bookInfoView.addSubview(bookImage)
        self.bookImageView = bookImage
        
        bookImage.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-12)
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(bookImage.snp_height).multipliedBy(0.75)
        }
            
        let bookName = UILabel()
        bookName.font = UIFont.boldSystemFont(ofSize: 18)
        bookName.textColor = kColor333
        bookInfoView.addSubview(bookName)
        bookName.snp.makeConstraints { (make) in
            make.left.equalTo(bookImage.snp_right).offset(25)
            make.top.equalTo(bookImage.snp_top).offset(5)
        }
        self.bookNameLabel = bookName
        
        let authorLabel = UILabel()
        authorLabel.font = UIFont.systemFont(ofSize: 14)
        authorLabel.textColor = kColor999
        view.addSubview(authorLabel)
        self.authorLabel = authorLabel
        
        authorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bookImage.snp_right).offset(25)
            make.top.equalTo(bookName.snp_bottom).offset(15)
        }
        
        let briefLabel = UILabel()
        briefLabel.font = UIFont.systemFont(ofSize: 14)
        briefLabel.textColor = kColor999
        briefLabel.numberOfLines = 2
        bookInfoView.addSubview(briefLabel)
        self.briefLabel = briefLabel
        

            
        let btn = UIButton()
        bookInfoView.addSubview(btn)
        
        btn.addTarget(self, action: #selector(continueRead), for: .touchUpInside)
        btn.backgroundColor = UIColor.hexString("#E6E6E6")
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.setImage(UIImage(named: "arrow_right_white"), for: .normal)
        btn.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        self.continueBtn = btn
        
        briefLabel.snp.makeConstraints { (make) in
            make.left.equalTo(bookImage.snp_right).offset(25)
            make.top.equalTo(authorLabel.snp_bottom).offset(15)
            make.right.equalTo(btn.snp_left).offset(-15)
        }

        
        let placeholderLabel = UILabel()
        placeholderLabel.font = UIFont.systemFont(ofSize: 15)
        placeholderLabel.textColor = kColor999
        placeholderLabel.text = "当前没有正在阅读的图书"
        bookInfoView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        self.placeLabel = placeholderLabel
        return view
    }()
    
    @objc func continueRead() {
        let read = ReaderViewController()
        let bookModel = BookModel()
        bookModel.bookId = recordModel?.bookId
        bookModel.bookName = recordModel?.bookName
        bookModel.author = recordModel?.author
        bookModel.coverImg = recordModel?.author
        read.bookModel = bookModel
        read.chapterId = recordModel?.currentChapter?.chapterId
        read.chapterModel = recordModel?.currentChapter
        self.navigationController?.pushViewController(read, animated: true)
    }
    
}

extension BookShelfChildViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookList.count == 0 ? 0 : (bookList.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookItemCell", for: indexPath) as! BookItemCell
        if (indexPath.row < bookList.count) {
            cell.bookData = bookList[indexPath.row]
        } else {
            cell.imageView.image = UIImage(named: "gengduo")
            cell.titleLabel.text = "发现更多好书"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row < bookList.count) {
            let bookData = bookList[indexPath.row]
            let detail = BookDetailViewController()
            detail.bookId = bookData.bookId
            self.navigationController?.pushViewController(detail, animated: false)
        } else {
            if let tab = UIApplication.shared.windows[0].rootViewController as? MainViewController {
                tab.selectedIndex = 1
            }
        }
        
    }
}

extension BookShelfChildViewController: StartAlertViewDelegate {
    func gotoStaicViewWith(type: StaticTextType) {
        let vc = StaticTextViewController()
        vc.type = type
        vc.title = type == .user ? "用户协议" : "隐私政策"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
