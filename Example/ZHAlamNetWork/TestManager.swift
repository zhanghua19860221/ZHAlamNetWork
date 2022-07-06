//
//  TestManager.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/28.
//

import UIKit

enum TestManagerEnum {
    //左侧 列表数据
    case get_leftData

}

extension TestManagerEnum: TargetType{
    // 请求域名
    //var baseURL: URL {
    //    return "服务器地址"
    //}
    // 请求头
    //var headers: [String: String]? {
    //    return [:]
    //}

    // 请求路径
    var path: String {
        switch self {
        case .get_leftData:
            return "/public/api/category/first"
        }
    }
    // 请求类型
    var method: Moya.Method {
        switch self {
        case .get_leftData:
            return .get
        }
    }
    // 请求任务事件（这里附带上参数）
    var task: Task {
        switch self {
        case .get_leftData:
            return .requestPlain
        }
    }
    
    // 此协议方法在Moya的本版本(15.0.0)中已经 给到了默认实现 ，可以不需要手动实现 ，如果确需修改可在此重写该方法，返回所需Data() 。
    //var sampleData: Data{ return Data()}
}

