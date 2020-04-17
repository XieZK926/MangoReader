//
//  RankTableViewCell.swift
//  MangoReader
//
//  Created by rober_x on 2020/3/21.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
protocol RankTableViewCellDelegate: NSObjectProtocol {
    func showMoreRank()
    func rankcCellDidclickItem(with model: BookModel)
}
class RankTableViewCell: UITableViewCell {
    weak var delegate: RankTableViewCellDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    override func awakeFromNib() {
        super.awakeFromNib()
        let spaceH: CGFloat = 10
        let itemW: CGFloat = kScreenWidth  / 2
        
        layout.itemSize = CGSize(width: itemW, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = spaceH
        
        collectionView.register(UINib(nibName: "RankCollectionCell", bundle: nil), forCellWithReuseIdentifier: "RankCollectionCell")
        collectionView.isScrollEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource  = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var bookList: [BookModel]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func showMoreRank(_ sender: Any) {
        self.delegate?.showMoreRank()
    }
}

extension RankTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bookList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RankCollectionCell", for: indexPath) as! RankCollectionCell
        cell.bookData = self.bookList?[indexPath.row]
        cell.rankIndex = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookData = self.bookList?[indexPath.row]
        self.delegate?.rankcCellDidclickItem(with: bookData!)

    }
    
}
