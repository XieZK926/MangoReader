//
//  BookItemCell.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/25.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class BookItemCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var bookData: BookModel? {
        didSet {
            guard let model = bookData else { return }
            imageView.kf.setImage(with: URL(string: model.coverImg!), placeholder: UIImage(named: "book_placeholder"))
            titleLabel.text = model.bookName
        }
    }

}
