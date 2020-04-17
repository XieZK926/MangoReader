//
//  RankCollectionCell.swift
//  MangoReader
//
//  Created by rober_x on 2020/3/21.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class RankCollectionCell: UICollectionViewCell {
    @IBOutlet weak var BookImage: UIImageView!
    @IBOutlet weak var rankBtn: UIButton!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var hotLabel: UILabel!
    public var ChineseNumbers = ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var bookData: BookModel? {
        didSet {
            BookImage.kf.setImage(with: URL(string: bookData?.coverImg ?? ""), placeholder: UIImage(named: "book_placeholder"))
            bookName.text = bookData?.bookName
            hotLabel.text = "人气：" + "\(bookData?.visitors ?? "0")"
        }
    }
    var rankIndex: Int = 0 {
        didSet {
            switch rankIndex {
            case 0:
                rankBtn.setBackgroundImage(UIImage(named: "rank1"), for: .normal)
            case 1:
                rankBtn.setBackgroundImage(UIImage(named: "rank2"), for: .normal)

            case 2:
                rankBtn.setBackgroundImage(UIImage(named: "rank3"), for: .normal)
            default:
                rankBtn.setBackgroundImage(UIImage(named: "rankn"), for: .normal)
            }
            rankBtn.setTitle("第\(rankIndex + 1)名", for: .normal)
        }
    }

}
