//
//  XKCommonUtils.swift
//  SaaSForDriver
//
//  Created by rober_x on 2019/5/7.
//  Copyright © 2019 xie. All rights reserved.
//

import UIKit

class XKCommonUtils: NSObject {
    
    class func currentVC() -> UIViewController? {
        var window = UIApplication.shared.windows[0]
        //是否为当前显示的window
        if window.windowLevel != .normal{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == .normal{
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window.rootViewController
        return self.getTopVC(withCurrentVC: vc)

    }
    
    ///根据控制器获取 顶层控制器
    class func getTopVC(withCurrentVC VC :UIViewController?) -> UIViewController? {
        if VC == nil {
            print("🌶： 找不到顶层控制器")
            return nil
        }
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器
            return getTopVC(withCurrentVC: presentVC)
        }else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if let selectVC = tabVC.selectedViewController {
                return getTopVC(withCurrentVC: selectVC)
            }
            return nil
        } else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav
            return getTopVC(withCurrentVC:naiVC.visibleViewController)
        } else {
            // 返回顶控制器
            return VC
        }
    }
    
    
    /// 弹框框
    ///
    /// - Parameters:
    ///   - message: 提醒t内容
    ///   - viewcontroller: 当前控制器，没有传为默认当前
    class func alert(message: String?, from viewcontroller:UIViewController? ){
        self.alert(from: viewcontroller, title: "温馨提示", content: message, canceleTitle: "确定", buttonTitles: nil, callBack: nil)
    }
    
    class func alert(from viewcontroller: UIViewController?, title: String?, content: String?, canceleTitle:String?, buttonTitles: [String]?,callBack:( (Int)->Void)? = nil) {
        
        let alertVC = UIAlertController(title: title ?? "温馨提示", message: content ?? "", preferredStyle: .alert)
        if let cancel = canceleTitle {
            
            let cancelAction = UIAlertAction(title: cancel, style: .cancel) { (alert) in
                    callBack?(0)
            }
            alertVC .addAction(cancelAction)
        }
        
        if let titles = buttonTitles {
            for (index, item) in titles.enumerated() {
                let action = UIAlertAction(title: item, style: .default) { (alert) in
                    callBack?(1 + index)
                }
                alertVC .addAction(action)
            }
        }
        DispatchQueue.main.async {
            guard let vc = viewcontroller else {
                self.currentVC()?.present(alertVC, animated: true, completion: nil)
                return
            }
            vc.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    class func getParamsFrom(url: inout String) -> [String: String]? {
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let components = URLComponents(url: URL(string: url)!, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else {
                return nil
        }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    class func getQueryStringFrom(params: [String: AnyHashable]) -> String {
        var queryString = ""
        var components: Array<String> = []
        params.forEach { (key, value) in
            components.append("\(key)=\(value)")
        }
        queryString = components.joined(separator: "&")
        return queryString
    }
    
    
    
}
