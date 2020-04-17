//
//  BookDetailViewController.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/5.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
class BookDetailViewController: UIViewController {
    var bookId: String?
    var bookData: BookDetailModel?
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var BookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
//    @IBOutlet weak var statusLabel: UILabel!
//    @IBOutlet weak var wordsLabel: UILabel!
    @IBOutlet weak var brifeLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var visitorLabel: UILabel!

    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var recomandView: UIView!
    
    @IBOutlet weak var addShelfBtn: UIControl!
    @IBOutlet weak var downloadBtn: UIControl!
    @IBOutlet weak var readBtn: UIButton!

    @IBOutlet weak var hotViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var addShelfImage: UIImageView!
    @IBOutlet weak var addShelfLabel: UILabel!
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var downloadLabel: UILabel!
    
    @IBOutlet weak var bookInfoView: UIView!
    
    var isAddShelf: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBarShadowImageHidden = true
        bookInfoView.layer.cornerRadius = 5
//        bookInfoView.layer.masksToBounds = true
        bookInfoView.layer.shadowOpacity = 0.2
        bookInfoView.layer.shadowColor = UIColor.hexString("#213021").cgColor
        bookInfoView.layer.shadowRadius = 6
        bookInfoView.layer.shadowOffset = CGSize(width: 2, height: 2)
       
        isAddShelf = XKSQLManager.shareManager.isHasDataInShelfTable(bookId: self.bookId ?? "")
        if(isAddShelf) {
            addShelfImage.image = UIImage(named: "jiarushujia_dianji")
            addShelfLabel.textColor = UIColor.hexString("#999999")
            addShelfLabel.text = "已在书架"
        }
        requestBookInfo()
        // Do any additional setup after loading the view.
    }
    
    func requestBookInfo() {
        XKToastUtil.showLoading(status: nil)
        guard let bookId = self.bookId else {
            return
        }
        XKMoyaAdapter.request(XBNetWorkAPI.getBookDetail(bookId: bookId)) { (data, error) in
            XKToastUtil.hiddenLoading()
            if let data = data {
                let jsonData = JSON(data)
            
                if let bookObject = JSONDeserializer<BookDetailModel>.deserializeFrom(json: jsonData.description) {
                    self.bookData = bookObject
                }
                
                self.reloadData()


            }

        }
    }
    
    func reloadData() {
        guard let bookInfo = self.bookData else { return  }
        BookImage.kf.setImage(with: URL(string: bookInfo.coverImg ?? ""), placeholder: UIImage(named: "book_placeholder"))
        bookName.text = bookInfo.bookName
        authorLabel.text = "作者 | " + bookInfo.author!
//        statusLabel.text = bookInfo.state
//        wordsLabel.text = String(format: "%.2f万字", bookInfo.words / 10000)
        brifeLabel.text = bookInfo.brief
        let breifStr = bookInfo.brief?.components(separatedBy: "......").first
        desLabel.attributedText = NSAttributedString(string: (breifStr ?? "") + "......")
        scoreLabel.text = bookInfo.score
        let score = Int(Float(bookInfo.score ?? "1")! * Float(10))
        percentLabel.text = "超过\(score)%的同类书籍"
        visitorLabel.text = bookInfo.visitors
        
        guard let chapterData = self.bookData?.chapterlist else { return  }
        characterLabel.text = "最新：\(chapterData.title!)"
        timeLabel.text = chapterData.updateTime?.components(separatedBy: " ").first
        self.initRecomandView()
        
    }
    
    func initRecomandView() {
        guard let griadData = self.bookData?.hotlist else {
            return
        }
        let sliceArray = griadData[0..<4]
        let startX: CGFloat = 15.0, startY: CGFloat = 15.0, margin: CGFloat = 20.0
        let ratio: CGFloat = 1.2
        let itemWidth: CGFloat = (kScreenWidth - 2 * startY - 3 * margin) / 4
        for (index, item) in sliceArray.enumerated() {
            let subView = UIControl(frame: CGRect(x: startX + CGFloat(index % 4) * (itemWidth + margin) , y: startY +  CGFloat(index / 4) * (itemWidth * ratio + margin) , width: itemWidth  , height: itemWidth * ratio + 45 ))
            recomandView.addSubview(subView)
            subView.tag = 100 + index
            
//            subView.backgroundColor = UIColor.cyan
            
            let bookImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth * ratio))
            bookImageView.kf.setImage(with: URL(string: item.coverImg!), placeholder: UIImage(named: "book_placeholder"
            ))
            bookImageView.backgroundColor = UIColor.lightGray
            subView.addSubview(bookImageView)
            
            let titleLable = UILabel(frame: CGRect(x: 0, y: bookImageView.bottom + 5, width: itemWidth, height: 20))
            titleLable.font = UIFont.systemFont(ofSize: 14)
            titleLable.textAlignment  = .center
            titleLable.textColor = UIColor.hexString("#333333")
            titleLable.text = item.bookName
            subView.addSubview(titleLable)
            
            let desLabel = UILabel(frame: CGRect(x: 0, y: titleLable.bottom, width: itemWidth, height: 20))
            desLabel.font = UIFont.systemFont(ofSize: 12)
            desLabel.textAlignment  = .center
            desLabel.textColor = UIColor.hexString("#999999")
            desLabel.text = item.author
            subView.addSubview(desLabel)
            subView.addTarget(self, action: #selector(gotoDetail), for: .touchUpInside)
        }
        hotViewHeight.constant = 60 + startY * 2 + itemWidth * 1.2 + 45
    }
}

//MARK: 点击事件
extension BookDetailViewController {
    @IBAction func addShelf(_ sender: Any) {
        if(isAddShelf) {
            return
        }
        isAddShelf = true
        XKSQLManager.shareManager.insertDataToShelfTableWith(model: bookData!)
        XKToastUtil.showSuccessToast(status: "已加入书架")
        addShelfImage.image = UIImage(named: "jiarushujia_dianji")
        addShelfLabel.textColor = UIColor.hexString("#999999")
        addShelfLabel.text = "已在书架"

    }
    
    @IBAction func downloadBook(_ sender: Any) {
        XKToastUtil.showInfoToast(status: "暂不支持")
    }
    
    @IBAction func readNow(_ sender: Any) {
        let bookReader = ReaderViewController()
        /// id 和 name 必传
        bookReader.bookModel = self.bookData
        self.navigationController?.pushViewController(bookReader, animated: true)
    }
    /// 点击展开
    @IBAction func unfold(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let image = sender.imageView!.image!
        let flipImage =  UIImage(cgImage: image.cgImage!,
                                 scale: image.scale,
                                 orientation: .down)
        sender.setImage(flipImage, for: .selected)
        if(sender.isSelected) {
            desLabel.attributedText = NSAttributedString(string: bookData!.brief!)
        } else {
            let breifStr = bookData!.brief?.components(separatedBy: "......").first
            desLabel.attributedText = NSAttributedString(string: (breifStr ?? ""))

        }
    }
    
    @IBAction func readNewCharecter(_ sender: Any) {
        let bookReader = ReaderViewController()
        /// id 和 name 必传
        bookReader.bookModel = self.bookData
        bookReader.chapterId = self.bookData?.chapterlist?.chapterId
        bookReader.chapterModel = self.bookData?.chapterlist
        self.navigationController?.pushViewController(bookReader, animated: true)
        
    }
    
    @IBAction func showMoreRecomand(_ sender: Any) {
        let recomand = BookListViewController()
        recomand.bookList = self.bookData?.hotlist ?? []
        self.navigationController?.pushViewController(recomand, animated: true)
    }
    
    @objc func gotoDetail(_ sender: UIControl) {
        let tag = sender.tag - 100
        let book = bookData?.hotlist?[tag]
        let detail = BookDetailViewController()
        detail.bookId = book?.bookId
        self.navigationController?.pushViewController(detail, animated: true)
    }

    
    
    
}

extension BookDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let num =  bookData?.hotlist?.count else {
            return 0
        }
        return  num > 4 ? 4 : num
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        return cell
    }
    
    
}
