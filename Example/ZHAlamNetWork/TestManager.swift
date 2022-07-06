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
    // Moya此版本(13.0.1)中 sampleData 方法拓展（extension）中默认没有实现 ，所以需要手动实现此方法 ，在高版本中此方法有默认的实现 不需要手动实现 
    var sampleData: Data {
        return Data()
    }
}

