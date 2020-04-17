//
//  ReaderViewController+AD.swift
//  MangoReader
//
//  Created by rober_x on 2020/3/3.
//  Copyright © 2020 xb. All rights reserved.
//

import UIKit
extension ReaderViewController: XKAdCoverViewDelegate {
        
    func showAdCover(isShow: Bool) {
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {[weak self] in
            self?.adView.alpha = isShow ? 1 : 0
        }) {[weak self] (co) in
            self?.adView.isHidden = isShow ? false : true
        }
        if (isShow) {
            let adModel = BURewardedVideoModel()
            adModel.userId = "123"
            
            rewardAd = BURewardedVideoAd(slotID: "900546826", rewardedVideoModel: adModel)
            rewardAd?.delegate = self
            rewardAd?.loadData()
        }

    }
    
    func loadAndShowAdView() {
        self.rewardAd?.show(fromRootViewController: self, ritScene: .home_get_bonus, ritSceneDescribe: nil)
    }

    
}

//MARK: - 广告代理

extension ReaderViewController: BURewardedVideoAdDelegate {
    func rewardedVideoAdDidLoad(_ rewardedVideoAd: BURewardedVideoAd) {
        print("加载成功")
    }
    
    func rewardedVideoAd(_ rewardedVideoAd: BURewardedVideoAd, didFailWithError error: Error?) {
        print("加载失败")

    }
    
    func rewardedVideoAdServerRewardDidFail(_ rewardedVideoAd: BURewardedVideoAd) {
        print("")
    }
    func rewardedVideoAdDidPlayFinish(_ rewardedVideoAd: BURewardedVideoAd, didFailWithError error: Error?) {
        if((error) != nil) {
            
        }
        self.showAdCover(isShow: false)
        /// 添加已购买章节记录
        var array = self.recordModel?.buyList ?? []
        array.append(self.pendingChapterId!)
        let arrStr = array.joined(separator: ",")
        XKSQLManager.shareManager.updateADRecordDataWith(adStr: arrStr, bookId: self.bookModel!.bookId!)
        /// 更新record
        self.recordModel = XKSQLManager.shareManager.getDataInRecordTable(bookId: self.bookModel!.bookId!)
        self.requestChapterData(chapterId: pendingChapterId, purpose: pendingPreState)
    }

}

