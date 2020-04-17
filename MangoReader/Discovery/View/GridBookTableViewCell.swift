//
//  GridBookTableViewCell.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/30.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit

protocol GridBookTableViewCellProtocol {
    func bookItemDidClicked(bookModel: BookModel)
}

class GridBookTableViewCell: UITableViewCell {
    
    var delegate: GridBookTableViewCellProtocol?
    
    @IBOutlet weak var booksContainer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .default, reuseIdentifier: restorationIdentifier)
//
//    }
        
    @IBAction func showDetailPage(_ sender: Any) {
        
        
    }
    
    var griadData: Array<BookModel>? {
        didSet {
            initSubViews()
        }
    }
    
    func getHeight(with data: NSArray) -> CGFloat {
        return 10
    }
    
    func initSubViews() {
        self.booksContainer.subviews.map {
            $0.removeFromSuperview()
        }
        guard let griadData = self.griadData else {
            return
        }
        var count = 0
        if griadData.count >= 8 {
            count = 8
        } else if griadData.count > 4 && griadData.count < 8 {
            count = 4
        }
        let startX: CGFloat = 15.0, startY: CGFloat = 15.0, margin: CGFloat = 16.0
        let ratio: CGFloat = 1.3
        let itemWidth: CGFloat = (kScreenWidth - 2 * startY - 3 * margin) / 4
        for index in 0 ..< count {
            let item = griadData[index]
            let subView = UIControl(frame: CGRect(x: startX + CGFloat(index % 4) * (itemWidth + margin) , y: startY +  CGFloat(index / 4) * (itemWidth * ratio + startY + 45) , width: itemWidth  , height: itemWidth * ratio + 45 ))
            booksContainer.addSubview(subView)
            
//            subView.backgroundColor = UIColor.cyan
            
            let bookImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth * ratio))
            bookImageView.kf.setImage(with: URL(string: item.coverImg ?? ""), placeholder: UIImage(named: "book_placeholder"))
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
            subView.tag = 100 + index
            subView.addTarget(self, action: #selector(itemDidSelected(sender:)), for: .touchUpInside)
        }
        
    }
    
    
    @objc func itemDidSelected(sender: UIControl) {
        let tag = sender.tag - 100
        let model = self.griadData![tag]
        self.delegate?.bookItemDidClicked(bookModel: model)
    }
    
}
