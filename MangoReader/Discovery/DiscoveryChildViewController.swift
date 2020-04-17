//
//  DiscoveryChildViewController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/29.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import MJRefresh
enum ChannelType: Int {
    case male = 1
    case female = 2
}

class DiscoveryChildViewController: UIViewController {
    //  分类： 0 = 男  1 = 女
    var type: ChannelType = .male
    var channelData: ChannelModel?
    
    var scoreSwitchIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mainTableView)
        mainTableView.tableHeaderView = myHeaderView
        if #available(iOS 11.0, *) {
            mainTableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        requestData()
        mainTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
            self?.requestData()
        })
        // Do any additional setup after loading the view.
    }
    
    lazy var myHeaderView: UIView = {
        var cycleScrollView:WRCycleScrollView?
        let itemWidth: CGFloat = 60 / 375 * kScreenWidth
        
        let startX: CGFloat = 30, margin = (kScreenWidth - 30 * 2 - itemWidth * 4) / 3

        let height = 150 * kScreenWidth / 350
        
        var headerView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: height + itemWidth + 70))
        headerView.backgroundColor = .white
        let frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
        // 可加载网络图片或者本地图片
        let serverImages = ["banner_01.jpg", "banner_02.jpg", "banner_03.jpg", "banner_04.jpg", "banner_05.jpg"]
        // 构造方法
        cycleScrollView = WRCycleScrollView(frame: frame, type: .LOCAL, imgs: serverImages)
        cycleScrollView?.currentDotColor = UIColor.white
        cycleScrollView?.otherDotColor = UIColor.hexString("#dddddd")
        // 添加代理
        cycleScrollView?.delegate = self
        
        headerView.addSubview(cycleScrollView!)
        
        let menuView = UIView(frame: CGRect(x: 0, y: cycleScrollView!.bottom, width: kScreenWidth, height: itemWidth + 28))
        let images = ["menu_category", "menu_highScore", "menu_recomand", "menu_completed"]
        
        let titles = ["分类", "高分榜", "推荐榜", "完结" ]
        
        for i in 0 ..< 4 {
            let menuItem = UIView(frame: CGRect(x: startX + CGFloat(i) * (itemWidth + margin), y: 20, width: itemWidth, height: itemWidth + 20))
            
            let menuImage = UIImageView(frame: CGRect(x: 10, y: 10, width: itemWidth - 20, height: itemWidth - 20))
            menuImage.image = UIImage(named: images[i])
            menuItem.addSubview(menuImage)
            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: itemWidth + 8, width: itemWidth, height: 20))
            titleLabel.font = UIFont.systemFont(ofSize: 12)
            titleLabel.textColor = kColor333
            titleLabel.textAlignment = .center
            titleLabel.text = titles[i]
            menuItem.addSubview(titleLabel)
            menuItem.tag = 100 + i
        menuItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(menuItemDidClicked(sender:))))
            menuView .addSubview(menuItem)
             
        }
        
        headerView.addSubview(menuView)
        
        let gapView = UIView()
        gapView.backgroundColor = UIColor.groupTableViewBackground
        headerView.addSubview(gapView)
        gapView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
        return headerView
    }()
    
    lazy var mainTableView: UITableView = {
        let table = UITableView(frame:CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavBarHeight - kTabBarHeight), style: .plain)
        table.register(UINib(nibName: "BookTableCell", bundle: nil), forCellReuseIdentifier: "BookTableCell")
        table.register(UINib(nibName: "GridBookTableViewCell", bundle: nil), forCellReuseIdentifier: "GridBookTableViewCell")
        table.register(UINib(nibName: "RankTableViewCell", bundle: nil), forCellReuseIdentifier: "RankTableViewCell")
        table.sectionFooterHeight = 10
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    func requestData() {
        XKToastUtil.showLoading(status: nil)
        XKMoyaAdapter.request(XBNetWorkAPI.getChannelData(type: type.rawValue)) { (data, error) in
            XKToastUtil.hiddenLoading()
            self.mainTableView.mj_header?.endRefreshing()
            if let data = data {
                let jsonData = JSON(data)
                if let mappedObject = JSONDeserializer<ChannelModel>.deserializeFrom(json: jsonData.description) {
                    self.channelData = mappedObject
                    self.mainTableView.reloadData()
                }
            }
        }
    }
}



extension DiscoveryChildViewController {
    @objc func menuItemDidClicked(sender: UITapGestureRecognizer) {
        let view = sender.view
        switch view?.tag {
        case 100:
            if let tab = UIApplication.shared.windows[0].rootViewController as? MainViewController {
                tab.selectedIndex = 2
            }
        case 101:
           let bookList = BookListViewController()
           bookList.listType = .highScore
           self.navigationController?.pushViewController(bookList, animated: true)
        case 102:
            let bookList = BookListViewController()
            bookList.listType = .hot
            self.navigationController?.pushViewController(bookList, animated: true)
            break
        default:
            let bookList = BookListViewController()
            bookList.listType = .end
            self.navigationController?.pushViewController(bookList, animated: true)
        }
    }
}


extension DiscoveryChildViewController: WRCycleScrollViewDelegate
   {
       /// 点击图片事件
       func cycleScrollViewDidSelect(at index:Int, cycleScrollView:WRCycleScrollView)
       {
        var bookId = ""
        switch index {
        case 0:
            bookId = "2399"
        case 1:
            bookId = "2363"
        case 2:
            bookId = "2401"
        case 3:
            bookId = "2408"
        default:
            bookId = "2429"
        }
        let detail = BookDetailViewController()
        detail.bookId = bookId
        self.navigationController?.pushViewController(detail, animated: true)
       }
    
       
       /// 图片滚动事件
       func cycleScrollViewDidScroll(to index:Int, cycleScrollView:WRCycleScrollView)
       {
//           print("滚动到了第\(index+1)个图片")
       }
   }

extension DiscoveryChildViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return (channelData?.scorelist?.count ?? 0) > 4 ? 4 : (channelData?.scorelist?.count ?? 0)
        case 2:
            return 1
        default:
            // 本版本不使用
            return (channelData?.recommendlist?.count ?? 0) > 5 ? 5 : (channelData?.recommendlist?.count ?? 0)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            /// 热门榜
            let cell = tableView.dequeueReusableCell(withIdentifier: "RankTableViewCell", for: indexPath) as! RankTableViewCell
            cell.bookList = channelData?.hotlist
            cell.delegate = self
            return cell
           
        case 1:
          /// 超好评
         let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableCell", for: indexPath) as! BookTableCell
         let index = 4 * scoreSwitchIndex + indexPath.row
         cell.bookData = channelData?.scorelist?[index]
         return cell
        case 2:
            /// 人气榜
            let cell = tableView.dequeueReusableCell(withIdentifier: "GridBookTableViewCell", for: indexPath) as! GridBookTableViewCell
            cell.griadData = channelData?.visitorslist
            cell.delegate = self
            return cell


        default:
            /// 大家都在看 //本版本不生效
            // 实际只是第四个section
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableCell", for: indexPath) as! BookTableCell
            cell.bookData = channelData?.recommendlist?[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = XKTableHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50), type: section)
        view.backgroundColor = .white
        switch section {
        case 0:
            /// 热门榜 无操作
            break
        case 1:
            /// 高分榜 换一换
            view.didTaped = {[weak self] in
                let groupCount = Int(self?.channelData?.scorelist!.count ?? 0) / 4
                self?.scoreSwitchIndex = ((self?.scoreSwitchIndex ?? 0) + 1) % groupCount
                self?.mainTableView.reloadSections([1], with: .fade)
            }
            break
        case 2:
            /// 人气榜 查看更多
            view.didTaped = {[weak self] in
                let bookList = BookListViewController()
                bookList.listType = .recomand
                self?.navigationController?.pushViewController(bookList, animated: true)
            }
            break
        case 3:
            /// 大家都在看
            view.didTaped = {[weak self] in
                let bookList = BookListViewController()
                bookList.listType = .recomand
                self?.navigationController?.pushViewController(bookList, animated: true)

            }
        break


        default: break
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if self.channelData?.scorelist?.count ?? 0 >= 10 {
                
                return 5 * 100 + 52
            } else {
                let index = ((self.channelData?.scorelist?.count ?? 0) + 1) / 2
                return CGFloat(index * 100 + 52)
            }

        case 2:
            
            if self.channelData?.scorelist?.count ?? 0 >= 8 {
                let ratio: CGFloat = 1.3
                let itemWidth: CGFloat = (kScreenWidth - 2 * 15 - 3 * 16) / 4
                
                return (itemWidth * ratio + 45) * 2 + 3 * 15
            } else {
                let ratio: CGFloat = 1.3
                let itemWidth: CGFloat = (kScreenWidth - 2 * 15 - 3 * 16) / 4
                
                return itemWidth * ratio + 45 + 3 * 15
            }
        default:
            return 156
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == 2) {
            return 0.01
        }
        return 10

    }
    
    /// 跳转到书籍详情
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            let index = 4 * scoreSwitchIndex + indexPath.row
            let bookId = channelData?.scorelist?[index].bookId ?? ""
            let detail = BookDetailViewController()
            detail.bookId = bookId
            self.navigationController?.pushViewController(detail, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 46
        if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight){
            scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0);
        }
    }

}

extension DiscoveryChildViewController: GridBookTableViewCellProtocol, RankTableViewCellDelegate {
    func showMoreRank() {
        let rank = RankListViewController()
        rank.bookList = self.channelData?.hotlist
        self.navigationController?.pushViewController(rank, animated: true)
    }
    
    func rankcCellDidclickItem(with model: BookModel) {
        let detail = BookDetailViewController()
        detail.bookId = model.bookId
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    func bookItemDidClicked(bookModel: BookModel) {
        let detail = BookDetailViewController()
        detail.bookId = bookModel.bookId
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    
    
    
}
