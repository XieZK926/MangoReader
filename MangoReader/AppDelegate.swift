//
//  AppDelegate.swift
//  MangoReader
//
//  Created by rober_x on 2019/12/25.
//  Copyright © 2019 xb. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var splashAd: GDTSplashAd!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13.0, *) {
            
        } else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let main = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! MainViewController
            self.window?.rootViewController = main
            self.window?.makeKeyAndVisible()
        }

        XKToastUtil.defaultConfig()
        XKMoyaAdapter.request(XBNetWorkAPI.getAppId) { (data, error) in
            
        }
        loadSplashAd()
//        XKSQLManager.shareManager
        UserInstance.shared.userId = Int(Date().timeIntervalSince1970 / 3).description
        self.setupBUAdSDK()
        
        return true
    }
    
    func setupBUAdSDK() {
        BUAdSDKManager.setAppID("5000546")
        #if DEBUG
            // Whether to open log. default is none.
        BUAdSDKManager.setLoglevel(.debug)
        #endif
        BUAdSDKManager.setIsPaidApp(false)

    }
    
    func loadSplashAd() {

        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            splashAd = GDTSplashAd.init(appId: kGDTAppID, placementId: kGDTPlacementID)
            splashAd.delegate = self
            splashAd.fetchDelay = 4
            var splashImage = UIImage.init(named: "SplashNormal")
            if isIphoneX {
                splashImage = UIImage.init(named: "SplashX")
            } else {
                splashImage = UIImage.init(named: "SplashSmall")
            }
            splashAd.backgroundImage = splashImage
            splashAd.loadAndShow(in: window, withBottomView: nil, skip: nil)
        }
    }

    // MARK: UISceneSession Lifecycle



}
extension AppDelegate: GDTSplashAdDelegate {
    func splashAdFail(toPresent splashAd: GDTSplashAd!, withError error: Error!) {
        print(#function,error)
    }
}

//extension AppDelegate: TencentSessionDelegate {
//    func tencentDidLogin() {
//        
//    }
//    
//    func tencentDidNotLogin(_ cancelled: Bool) {
//        
//    }
//    
//    func tencentDidNotNetWork() {
//        
//    }
//}
