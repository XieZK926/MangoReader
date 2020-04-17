//
//  XKCatalogueCell.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/17.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class XKCatalogueCell: UITableViewCell {
    @IBOutlet weak var chapterName: UILabel!
    @IBOutlet weak var limitButton: UIControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        chapterName.font = selected ? UIFont.boldSystemFont(ofSize: 14) : UIFont.systemFont(ofSize: 14)
        // Configure the view for the selected state
    }
    
    var chapterData: ChapterModel? {
        didSet {
            chapterName.text = chapterData?.title
            limitButton.isHidden = true
            if((chapterData?.chapterNumber ?? 1) >= 21) {
                limitButton.isHidden = false
            }
            
        }
    }
    
}
