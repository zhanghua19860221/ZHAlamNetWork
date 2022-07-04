//
//  ZHHttpBaseTargetType.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/24.
//

import UIKit
import Moya

/** 请求头*/
public var zhBaseHeaders:[String: String]? = [String: String]()

/** 服务器域名*/
public var zhBaseURL:String = ""

/** 数据模型基类名称 (可以)*/
public var zhBaseModelName:String = ""

/**
 设置请求头
 */
public func setBaseHeaders(header:[String: String]?){

    zhBaseHeaders = header
}
/**
 设置服务器域名
 */
public func setBaseURL(url:String){

    zhBaseURL = url
}

/**
 设置基本数据模型名称
 */
public func setBaseModelName(name:String){

    zhBaseModelName = name
}

public extension TargetType{
    // 请求头
    var headers: [String: String]? {
        return zhBaseHeaders
    }
    
    // 请求域名
    var baseURL: URL {
        return URL.init(string:(zhBaseURL)) ?? URL(fileURLWithPath: "")
    }
    
    // 请求超时时间
    func requestTime() -> Double {
        return 10
    }
}
