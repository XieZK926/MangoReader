//
//  ReaderViewController+effect.swift
//  MangoReader
//
//  Created by rober_x on 2020/1/19.
//  Copyright © 2020 xb. All rights reserved.
//

import Foundation

extension ReaderViewController: DZMCoverControllerDelegate {
    
    /// 创建阅读视图
    func creatPageController(displayController: ReaderPageViewController? = nil) {
        
        // 清理
        clearPageController()
            
        if displayController == nil { return }
        
        coverController = DZMCoverController()
        
        coverController.delegate = self
        self.addChild(coverController)
        contentView.insertSubview(coverController.view, at: 0)
        
        coverController.view.frame = contentView.bounds
        
        coverController.view.backgroundColor = UIColor.clear
        coverController.setController(displayController)
        
    }
    /// 清理所有阅读控制器
    func clearPageController() {
        if(coverController != nil) {
            coverController.removeFromParent()
            coverController.view.removeFromSuperview()
           coverController.delegate = nil
            coverController = nil
        }
        currentDisplayController?.removeFromParent()
        currentDisplayController = nil
    }
    
    // MARK: -- DZMCoverControllerDelegate
    /// 切换结果
    func coverController(_ coverController: DZMCoverController, currentController: UIViewController?, finish isFinish: Bool) {
        
        // 记录
        currentDisplayController = currentController as? ReaderPageViewController
        
        // 更新阅读记录
//        updateReadRecord(controller: currentDisplayController)
    }
    
    /// 获取当前阅读记录阅读页
    func GetCurrentReadViewController(isUpdateFont:Bool = false) ->ReaderPageViewController? {
        var index = self.chapterModel!.currentPage
        if isUpdateFont {
            if(index > (self.chapterModel?.pageModels?.count ?? 1) - 1) {
                index = index - 1
                self.chapterModel?.currentPage = index
            }
        }
        let model = self.chapterModel?.pageModels?[index]
        return GetReadViewController(pageModel: model)
    }

    
    /// 将要显示的控制器
    func coverController(_ coverController: DZMCoverController, willTransitionToPendingController pendingController: UIViewController?) {
        
        readMenu?.showMenu(isShow: false)
    }
    
    /// 获取上一个控制器
    func coverController(_ coverController: DZMCoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        
        return GetAboveReadViewController()
    }
    
    /// 获取下一个控制器
    func coverController(_ coverController: DZMCoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        
        return GetBelowReadViewController()
    }
    
    /// 获取上一页控制器
    func GetAboveReadViewController() ->UIViewController? {
        /// 全书第一页
        if(self.chapterModel?.currentPage == 0 && self.chapterModel?.chapterNumber == 1) {
            return nil
        }
        if (self.chapterModel?.currentPage == 0 && self.chapterModel?.chapterNumber != 1) {
            ///*** 判断是不是大于21章，且没看过广告
            //            if() {return nil}
            
            /// 请求上一章的内容
            /// chapterNumber = index + 1
            /// 这里取chapterNumber ，对应的Index 实际上是 chapterNumber - 1 -1
            let model = self.chapterList?[self.chapterModel!.chapterNumber - 2]
            self.requestChapterData(chapterId: model?.chapterId, purpose: .pre)
            return nil
        }
        let lastPage = self.chapterModel!.currentPage - 1
        self.chapterModel?.currentPage = lastPage
        let pageModel = self.chapterModel?.pageModels?[self.chapterModel!.currentPage]
        return GetReadViewController(pageModel: pageModel)
    }
        
    
    /// 获取下一页控制器
    func GetBelowReadViewController() ->UIViewController? {
        /// 判断是不是最后一章和最后一页
        if(self.chapterModel!.currentPage >= (self.chapterModel!.pageNumbers - 1) && self.chapterModel?.chapterNumber == self.chapterList?.count) {
            print("本书完")
            return nil
        }
        /// 判断是最后一页,但不是最后一章,请求下一章的数据
        if (self.chapterModel?.currentPage == (self.chapterModel!.pageNumbers - 1) && self.chapterModel?.chapterNumber != self.chapterList?.count) {
            ///*** 判断是不是大于21章，且没看过广告
//            if()
            
            /// 请求下一章的内容
            /// 这里取chapterNumber ，对应的Index 实际上是 chapterNumber + 1 -1
            let model = self.chapterList?[self.chapterModel!.chapterNumber]
            self.requestChapterData(chapterId: model?.chapterId, purpose: .next)
            return nil
        }
        let nextPage = self.chapterModel!.currentPage + 1
        self.chapterModel?.currentPage = nextPage
        let pageModel = self.chapterModel?.pageModels?[self.chapterModel!.currentPage]
        return GetReadViewController(pageModel: pageModel)

    }
}

extension ReaderViewController {
    /// 获取指定阅读记录阅读页
    func GetReadViewController(pageModel: ReadPageModel!) ->ReaderPageViewController? {
        if pageModel != nil {
            let page = ReaderPageViewController()
            page.pageModel = pageModel
            /// 更新记录
            if let record = self.recordModel {
                // 更新
                record.currentChapter = self.chapterModel
                print(record)
                XKSQLManager.shareManager.updateRecordDataWith(model: record)
                
            } else {
                // 插入
                let record = XKRecordModel()
                record.bookId = self.bookModel?.bookId
                record.bookName = self.bookModel?.bookName
                record.coverImg = self.bookModel?.coverImg
                record.author = self.bookModel?.author
                record.totalNumber = self.chapterList?.count ?? 9999
                record.currentChapter = self.chapterModel
                record.brief = self.bookModel?.brief
                record.buyList = []
                self.recordModel = record
                XKSQLManager.shareManager.insertDataTorRecordTableWith(model: record)
            }
                        /// 更新bottom sliderValue
            readMenu?.bottomView.slider.value = Float(pageModel!.chapterNumber) / Float(self.chapterList!.count)
            
            return page
        }
        
        return nil
    }
    
}
