//
//  ZHHttpBaseTargetType.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/24.
//

import UIKit
import Moya

/** 请求头*/
fileprivate var zhBaseHeaders:[String: String]? = [String: String]()

/** 服务器域名*/
fileprivate var zhBaseURL:String = ""

/** 数据模型基类名称 (可以)*/
var zhBaseModelName:String = ""

/**
 设置请求头
 */
func setBaseHeaders(header:[String: String]?){

    zhBaseHeaders = header
}
/**
 设置服务器域名
 */
func setBaseURL(url:String){

    zhBaseURL = url
}

/**
 设置基本数据模型名称
 */
func setBaseModelName(name:String){

    zhBaseModelName = name
}


extension TargetType{
//    请求header
    var headers: [String: String]? {
        return zhBaseHeaders
    }
    
//    base请求路径
    var baseURL: URL {
        return URL.init(string:(zhBaseURL))!
    }
    
    var sampleData: Data {
        return Data()
    }
    
//    获取请求时间
    func requestTime() -> Double {
        return 10
    }
}
