//
//  ReaderViewController.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/26.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit
import SwiftyJSON
import HandyJSON
enum RequestType {
    case pre
    case next
    case none
}
class ReaderViewController: UIViewController {
    /// 需要要加载广告的 章节
    var pendingChapterId: String?
    var pendingPreState: RequestType = .none
    /// 数据层
    var bookModel: BookModel?
    // 初始chapterId
    var chapterId: String?
    /// 记录model
    var recordModel: XKRecordModel?
    
    /// 当前正在阅读的章节
    var chapterModel: ChapterModel?
    /// 菜单管理器
    var readMenu: XKReaderMenu?
    var chapterList: Array<ChapterModel>?
    var coverController: DZMCoverController!
    var currentDisplayController: ReaderPageViewController?
    
    var rewardAd: BURewardedVideoAd?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        view.addSubview(leftView)
        view.addSubview(adView)
        view.bringSubviewToFront(adView)
        readMenu = XKReaderMenu(vc: self, delegate: self)
        readMenu?.topView.titleView.text = bookModel?.bookName
        self.navigationController?.navigationBar.isHidden = true
        
        
        requestChapterList()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /// 阅读页面父视图
    lazy var contentView: XKReaderContentView = {
        let view = XKReaderContentView(frame: self.view.bounds)
        view.backgroundColor = .white
        view.delegate = self
        return view
    }()
    
    /// 目录
    lazy var adView: XKAdCoverView = {
        let view = XKAdCoverView()
        view.delegate = self
        view.isHidden = true
        view.alpha = 0
        view.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        return view
    }()
 
    /// 目录
    lazy var leftView: XKReaderLeftView = {
        let view = XKReaderLeftView()
        view.delegate = self
        view.isHidden = true
        view.backgroundColor = .white
        view.frame = CGRect(x: -READER_LEFT_VIEW_WIDTH, y: 0, width: READER_LEFT_VIEW_WIDTH, height: kScreenHeight)
        view.bookName = self.bookModel?.bookName
        return view
    }()
    
    /// 辅视图展示
    func showLeftView(isShow:Bool) {
     
        if isShow { // leftView 将要显示
            // 刷新UI 日夜间
//            leftView.updateUI()
            // 滚动到阅读记录
//            leftView.currentIndex = self.chapterModel?.chapterNumber - 1
            leftView.scrollRecord(index: (self.chapterModel?.chapterNumber ?? 1) - 1)
            // 允许显示
            leftView.isHidden = false
        }
        
        UIView.animate(withDuration: ANIMATION_DURATION, delay: 0, options: .curveEaseOut, animations: { [weak self] () in
            self?.leftView.x = isShow ? 0 : -READER_LEFT_VIEW_WIDTH
            
        }) { [weak self] (isOK) in
            if !isShow { self?.leftView.isHidden = true }
        }
    }
    
    func requestChapterList() {
        guard let bookId = self.bookModel?.bookId else { return }
        
        XKMoyaAdapter.request(XBNetWorkAPI.getChapterList(bookId: bookId)) { (data, error) in
            XKToastUtil.hiddenLoading()
            if let data = data {
                let jsonData = JSON(data)
                if let mappedObject = [ChapterModel].deserialize(from: jsonData.description) {
                    self.chapterList = mappedObject as? Array<ChapterModel>
                    self.leftView.chapterList = mappedObject as! Array<ChapterModel>
                    self.checkRecorder()
                }
            }
        }
    }
    
    func checkRecorder() {
        guard let bookId = bookModel?.bookId else {
            return
        }
        let record = XKSQLManager.shareManager.getDataInRecordTable(bookId: bookId)
        if let chapterId = chapterId {
            /// 创建阅读记录
            if record == nil  {
                let record = XKRecordModel()
                record.bookId = self.bookModel?.bookId
                record.bookName = self.bookModel?.bookName
                record.coverImg = self.bookModel?.coverImg
                record.author = self.bookModel?.author
                record.brief = self.bookModel?.brief
                record.totalNumber = self.chapterList?.count ?? 9999
                record.currentChapter = self.chapterModel
                record.buyList = []
                self.recordModel = record
                XKSQLManager.shareManager.insertDataTorRecordTableWith(model: record)
            } else {
                self.recordModel = record
            }
            
            self.requestChapterData(chapterId: chapterId)
            
        } else {
            if record != nil {
                self.recordModel = record
                /// 加载本地
                self.chapterModel = record?.currentChapter
                let page = ReaderPageViewController()
                let index = record?.currentChapter?.currentPage
                page.pageModel = self.chapterModel?.pageModels?[index ?? 0]
                self.creatPageController(displayController: page)
            } else {
                /// 加载第一条 将数据库写入
                let cId = chapterList?[0].chapterId
                self.requestChapterData(chapterId: cId)
                
                let record = XKRecordModel()
                record.bookId = self.bookModel?.bookId
                record.bookName = self.bookModel?.bookName
                record.coverImg = self.bookModel?.coverImg
                record.author = self.bookModel?.author
                record.brief = self.bookModel?.brief
                record.totalNumber = self.chapterList?.count ?? 9999
                record.currentChapter = chapterList?[0]
                record.buyList = []
                self.recordModel = record
                XKSQLManager.shareManager.insertDataTorRecordTableWith(model: record)
            }
        }
    }
    
    /// 获取第n章的数据
    func requestChapterData(chapterId: String?,  purpose: RequestType = .none) {
        guard let bookId = self.bookModel?.bookId , let chapterId = chapterId else {
            return
        }
        let currentNumber = self.chapterModel?.chapterNumber
        if (currentNumber == 20 && purpose == .next) || (currentNumber == 21 && purpose != .pre) || ((currentNumber ?? 1) > 21) {
            if recordModel != nil {
                /// 遍历所有的buyList
                var isBought = false
                for cId in (recordModel?.buyList ?? []) {
                    /// 已经看过广告了
                    if chapterId == cId {
                        isBought = true
                    }
                }
                // 未看过广告
                if !isBought {
                    pendingChapterId = chapterId
                    pendingPreState = purpose
                    self.showAdCover(isShow: true)
                    return
                }
            } else {
                // 没有记录且超过21章的也需要看广告
                pendingChapterId = chapterId
                pendingPreState = purpose
                self.showAdCover(isShow: true)
                return
            }
        }
        XKToastUtil.showLoading(status: nil)
        XKMoyaAdapter.request(XBNetWorkAPI.getChapterContent(bookId: bookId, chapterId: chapterId)) { (data, error) in
            XKToastUtil.hiddenLoading()
            if let data = data {
                let jsonData = JSON(data)
                if let mapedObject = JSONDeserializer<ChapterModel>.deserializeFrom(json: jsonData.description) {
                    self.chapterModel = mapedObject
                    
                    let page = ReaderPageViewController()
                    var index = 0
                    if purpose == .pre {
                        index = (self.chapterModel?.pageModels?.count ?? 1) - 1
                    }
                    self.chapterModel?.currentPage = index
                    page.pageModel = self.chapterModel?.pageModels?[index]
                    self.creatPageController(displayController: page)
                    /// 更新滚动条进度
                    self.readMenu?.bottomView.slider.value = Float(self.chapterModel!.chapterNumber) / Float(self.chapterList!.count)
                    
                    if let record = self.recordModel {
                        // 更新
                        record.currentChapter = self.chapterModel
                        print(record)
                        XKSQLManager.shareManager.updateRecordDataWith(model: record)
                        self.recordModel = record
                        if(self.pendingChapterId != nil) {
                            /// 清除上次的数据
                            self.pendingChapterId = nil
                            self.pendingPreState = .none
                        }
                    }
                    
                    

                }
            }

        }
    }
    
    
    /// 获取章节内容
    /// - Parameters:
    ///   - currentChapter: 当前的章节
    ///   - purpose: 请求目的
    ///         - pre  取出上一个章节内容
    ///         - next 取出下一个章节内容
    ///         - none 取出当前章节的内容
//    func requestChapterData(currentChapter: ChapterModel, purpose: RequestType) {
//        var bookId = self.bookModel?.bookId, chapterId = ""
//        let currentIndex = currentChapter.chapterNumber - 1
//        switch purpose {
//        case .pre:
//            chapterId = self.chapterList![currentIndex - 1].chapterId!
//        case .next:
//            chapterId = self.chapterList![currentIndex + 1].chapterId!
//        case .none:
//            chapterId = currentChapter.chapterId!
//        }
//
//        if  currentIndex == 21 && pendingChapterId != nil  {
//
//        }
//    }


}
//MARK: - 目录相关

extension ReaderViewController: XKReaderContentViewDelegate, XKReaderLeftViewDelegate {
    
    func contentViewClickCover(contentView: XKReaderContentView) {
        showLeftView(isShow: false)
    }
    
    func CatalogueDidSelected(model: ChapterModel?) {
        self.showLeftView(isShow: false)
        self.contentView.showCover(isShow: false)
        if (model?.chapterNumber == self.chapterModel?.chapterNumber) {
            return
        }
        requestChapterData(chapterId: model?.chapterId, purpose: .none)
    }

}

//MARK: - 菜单相关代理

extension ReaderViewController: XKReaderMenuDelegate {
    func readMenuClickChangeFont(readMenu: XKReaderMenu?, fontSize: CGFloat) {
        
        self.creatPageController(displayController: GetCurrentReadViewController(isUpdateFont: true))
    }
    
    func readMenuClickChangeBgColor(readMenu: XKReaderMenu?) {
        self.creatPageController(displayController: GetCurrentReadViewController(isUpdateFont: false))
    }
    
    
    /// 点击目录
    func readMenuClickCatalogue(readMenu: XKReaderMenu?) {
        showLeftView(isShow: true)
        contentView.showCover(isShow: true)
        readMenu?.showMenu(isShow: false)
    }
    
    /// 点击日夜
    func readMenuClickDayAndNight(readMenu: XKReaderMenu?) {
        
    }
    /// 点击上一章
    func readMenuClickLastChapter(readMenu: XKReaderMenu?) {
        if self.chapterModel?.chapterNumber == 1 {
            XKToastUtil.showInfoToast(status: "已经是第一章了")
            return
        }
        guard let index = chapterModel?.chapterNumber, let model = self.chapterList?[index - 2] else {
            return
        }
        requestChapterData(chapterId: model.chapterId , purpose: .none)
    }
    
    /// 点击下一章
    func readMenuClickNextChapter(readMenu: XKReaderMenu?) {
        if self.chapterModel?.chapterNumber == self.chapterList?.count {
            XKToastUtil.showInfoToast(status: "已经是最后一章了")
            return
        }
        guard let index = chapterModel?.chapterNumber, let model = self.chapterList?[index] else {
            return
        }
        requestChapterData(chapterId: model.chapterId, purpose: .none)
    }
    
    /// 返回
    func backButtonDidClicked() {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
}
