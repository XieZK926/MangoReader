//
//  RecordTableViewCell.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/15.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var lastReadTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addBtn.layer.borderWidth = 1
        self.addBtn.layer.borderColor = kColor333.cgColor
        self.addBtn.layer.cornerRadius = 15;
        self.addBtn.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var recordModel: XKRecordModel? {
        didSet {
            guard let model = recordModel else {
                return
            }
            self.bookImage.kf.setImage(with: URL(string: model.coverImg ?? ""), placeholder: UIImage(named: "book_placeholder"))
            self.bookName.text = model.bookName
            self.authorLabel.text = model.author
            let text = XKSQLManager.shareManager.isHasDataInShelfTable(bookId: model.bookId!) ? "已加入书架" : "加入书架"
            self.addBtn.setTitle(text, for: .normal)
        }
    }
    
    @IBAction func addShelf(_ sender: UIButton) {
        if XKSQLManager.shareManager.isHasDataInShelfTable(bookId: recordModel!.bookId!) {
            return
        }
        let model = BookModel()
        model.bookId = recordModel?.bookId
        model.bookName = recordModel?.bookName
        model.author = recordModel?.author
        model.coverImg = recordModel?.coverImg
        XKSQLManager.shareManager.insertDataToShelfTableWith(model: model)
        sender.setTitle("已加入书架", for: .normal)
    }
    
    
//    var bookData:
}
