//
//  XBNetWorkAPI.swift
//  MangoReader
//
//  Created by rober_x on 2020/2/4.
//  Copyright © 2020 xb. All rights reserved.
//

import Foundation
import Moya
protocol CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {get}
}
// 请求分类
public enum XBNetWorkAPI {
    /// 获取小说列表
//    高分榜：
//    booklist.html?visitors=1
//    完结榜：
//    booklist.html?state=2
//    热点榜：
//    booklist.html?is_hot=1
//    推荐榜：
//    booklist.html?recommend=1
    case getBookList(params: [String: String])
    
    /// 获取小说详情
    case getBookDetail(bookId: String)
    
    /// 获取目录
    case getChapterList(bookId: String)
    
    /// 获取章节内容
    case getChapterContent(bookId: String, chapterId: String)
    
    /// pg获取频道信息
    case getChannelData(type: Int)
    
    /// 获取分类
    case getCategoryData(params: [String: AnyHashable])
    
    case getAppId

    
    
    
}

// 请求配置
extension XBNetWorkAPI: TargetType, CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
        case .getChapterContent:
            return .useProtocolCachePolicy
        default:
            return .reloadIgnoringLocalCacheData
        }
    }
    
    // 服务器地址
    public var baseURL: URL {
        var urlStr = kBaseURL
        switch self {
        case .getBookList( let params):
            
            urlStr.append( "booklist.html?" + XKCommonUtils.getQueryStringFrom(params: params))
        
        case .getChannelData(let type):
            urlStr.append("channel.html?type=\(type)")
        
        case .getBookDetail(let bookId):
            urlStr.append("bookinfo.html?bookId=\(bookId)")
        
        case .getChapterContent(let bookId, let chapterId):
            urlStr.append("chapterContent.html?bookId=\(bookId)&chapterId=\(chapterId)")
        case .getCategoryData(let params):
            urlStr.append("category.html?" + XKCommonUtils.getQueryStringFrom(params: params))
        case .getChapterList(let bookId):
            urlStr.append("chapterList.html?bookId=\(bookId)")
        case .getAppId:
            urlStr = "http://118.31.169.165/index/Ad/index.html?packageName=com.xb.MangoReader&versionCode=1"
        }
        
        return URL(string: urlStr)!

    }
    
    // 各个请求的具体路径
    public var path: String {
//        let userId = UserInstance.shared.user?.id ?? ""
        return ""
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
        
    }
    public var task: Task {
        switch self {
        case .getBookList:
            return .requestPlain
        default:
            return .requestPlain
        }
        
    }
    
    public var sampleData: Data { return "".data(using: String.Encoding.utf8)!
        
    }
    
    public var headers: [String : String]? {
//        let token = UserInstance.shared.token
//        print("请求的token：" + (token ?? ""))
        return ["Content-Type": "application/json"]
    }
}

