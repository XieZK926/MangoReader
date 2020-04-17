//
//  BookTableCell.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit

class BookTableCell: UITableViewCell {
    @IBOutlet weak var BookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var statusLabel: UIButton!
    @IBOutlet weak var typeLabel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusLabel.layer.cornerRadius = 2
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.masksToBounds = true

        
        typeLabel.layer.cornerRadius = 2
        typeLabel.layer.borderWidth = 1
        typeLabel.layer.masksToBounds = true
        typeLabel.layer.borderColor = UIColor.hexString("#c9c9c9").cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var bookData: BookModel? {
        didSet {
            if let model = bookData {
                BookImage.kf.setImage(with: URL(string: model.coverImg!), placeholder: UIImage(named: "book_placeholder"))
                bookName.text = model.bookName
                desLabel.text = model.brief
                authorLabel.text = model.author
                statusLabel.setTitle(model.state, for: .normal)
                if (model.state == "连载中") {
                    statusLabel.layer.borderColor = UIColor.hexString("#12E034").cgColor
                    statusLabel.setTitleColor(UIColor.hexString("#12E034"), for: .normal)
                } else {
                    statusLabel.layer.borderColor = UIColor.hexString("#FFBC30").cgColor
                    statusLabel.setTitleColor(UIColor.hexString("#FFBC30"), for: .normal)

                }
                typeLabel.setTitle(model.catename, for: .normal)
            }
        }
    }
    
}
