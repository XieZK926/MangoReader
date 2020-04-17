//
//  XKMoyaAdapter.swift
//  SaaSForDriver
//
//  Created by rober_x on 2019/5/5.
//  Copyright © 2019 xie. All rights reserved.
//

import Foundation
import Moya
import SVProgressHUD
import HandyJSON
import SwiftyJSON

private func endpointMapping<Target: TargetType>(target: Target) -> Endpoint {
    print("请求连接：\(target.baseURL)\(target.path) \n方法：\(target.method)\n参数：\(String(describing: target.task)) ")
    return MoyaProvider.defaultEndpointMapping(for: target)
}

class XKMoyaAdapter: NSObject {
    
    /// 发起请求
    ///
    /// - Parameters:
    ///   - target: 实现TargetType协议的 API
    ///   - responseCallback: 返回
    class func  request<T:TargetType>(
        _ target:T, responseCallback: @escaping (Any?, XKError?) -> Void
        ) {
        let provider = MoyaProvider<T>(endpointClosure: endpointMapping,plugins:[])
        provider.request(target) { (result) in
            
            XKToastUtil.hiddenLoading()
            
            switch result {
            case let .success(response):
                /// 0 data 1 error
                print("返回结果:\(JSON(response.data))")
                let handledTupple = responseHandler(with: response)
                
                responseCallback(handledTupple.data, handledTupple.error)
                break

            case let .failure(error):
                
                /// -*h处理网络错误
        
                print(error.errorDescription as Any)
                
                
//                let errorinfo = error.errorUserInfo["NSUnderlyingError"] as! NSError
                let xkerror = XKError(code: error.errorCode.description, msg: error.errorDescription)
                XKToastUtil.showfaildToast(status: xkerror.errmsg ?? "请求异常")
                
                responseCallback(nil,xkerror)
                break
            }
        }
    }
    
    
    /// 错误处理
    ///
    /// - Parameter data: 网络返回结果
    /// - Returns:  数据元祖（data , error）
    class func responseHandler(with data:Response?) -> (data: Any?, error: XKError?) {
        
        
    
        if let response = data {
            let mapedData = JSON(response.data)
            if let mappedObject = JSONDeserializer<BaseResponseModel>.deserializeFrom(json: (mapedData as AnyObject).description) {
                
                switch response.statusCode {
                case 200:
                    // 成功，继续判断data 数据
                    if response.request?.url?.absoluteString.contains("Ad/index") ?? false  {
                        return (nil, nil)
                    }
                    
                    
                    if (mappedObject.errorCode == "0") {
                        return (mappedObject.data, nil)
                    } else {
                        let errMsg = mappedObject.message ?? "错误代码：\(mappedObject.errorCode ?? " 无 ")"
                        XKToastUtil.showfaildToast(status: errMsg)
                        return (nil, XKError())
                        
                    }
                    
                case 403:
                    if (data?.request?.url?.absoluteString.contains("appversion/ios/rcs/latest"))! {
                        return (nil, nil)
                    }
                    
                    
                    // 账号被顶掉, 或者未登录
                    if (data?.request?.url?.absoluteString.contains("/portal/w/driver/getDriver"))! {
                        return (nil, XKError(code: 403.description, msg: "无效token"))
                    }
                    UserInstance.shared.clearLoginData()
//                    if(GPSUploadManager.shared.isAvailable) {
//                        GPSUploadManager.shared.disabledService()
//                    }

                    XKCommonUtils.alert(from: nil, title: nil, content: "您的账号已过期，请重新登录", canceleTitle: "确定", buttonTitles: nil) { (index) in
                        
                        UIApplication.shared.windows[0].rootViewController = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "homeNavi")
                    }
                    
                    
                    return (nil, XKError(code: 403.description, msg: "无效token"))
                case 500...599:
                    
                    XKToastUtil.showfaildToast(status: "服务器异常，请稍后再试")
                    
                    return (nil, XKError())

                default:
                    let errMsg = mappedObject.message ?? "错误代码：\(mappedObject.errorCode ?? " 无 ")"
                    print(errMsg)
                    XKToastUtil.showfaildToast(status: errMsg)
                    
                    return (nil, XKError())
                }
                
            } else {
                //可不做处理
                XKToastUtil.showfaildToast(status: "数据解析异常")
                return (nil, XKError())
            }
            
        }
        
        XKToastUtil.showfaildToast(status: "数据异常")
        return (nil, XKError())

    }
    
    class func errorHandler(error: MoyaError) {
        switch error.errorCode {
        case 500:
            XKToastUtil.showfaildToast(status:"服务器内部错误")
            break;
        case 3840:
            XKToastUtil.showfaildToast(status:"数据解析异常")
            break;
        case 1016:
            XKToastUtil.showfaildToast(status:"网络出现问题，请稍后再试")
            break;
        default:
            XKToastUtil.showfaildToast(status: error.errorDescription ?? "错误信息无法识别")
            return
        }
    }
}



