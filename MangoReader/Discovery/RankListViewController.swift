//
//  RankListViewController.swift
//  MangoReader
//
//  Created by rober_x on 2020/3/23.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit

class RankListViewController: UIViewController {
    var bookList: [BookModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "高分榜"
        self.view.addSubview(collectionView)
        // Do any additional setup after loading the view.
    }
    
    lazy var collectionView: UICollectionView = {
        let spaceH: CGFloat = 10
        let itemW: CGFloat = kScreenWidth  / 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemW, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = spaceH
        
        
        let collction = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), collectionViewLayout: layout)
        collction.register(UINib(nibName: "RankCollectionCell", bundle: nil), forCellWithReuseIdentifier: "RankCollectionCell")
        collction.delegate = self
        collction.dataSource = self
        collction.backgroundColor = .white
        return collction
    }()
}

extension RankListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
        let detail = BookDetailViewController()
        detail.bookId = bookData?.bookId
        self.navigationController?.pushViewController(detail, animated: true)

    }
    
    
    
}

