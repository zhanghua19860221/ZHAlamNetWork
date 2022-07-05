//
//  ZHHttpBaseModel.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/24.
//

import UIKit
import HandyJSON
// open 是 Swift 3 新增的访问控制符，相较于 public 更加开放。open 和 public 都是可以跨 Module 访问的，但 open 修饰的类可以继承，修饰的方法可以重写（此时，open 需同时修饰该方法以及所在类），而 public 不可以。

open class ZHHttpBaseModel: HandyJSON {
    required public init() {}

    public func didFinishMapping() {}
    
    public func mapping(mapper: HelpingMapper) {}
    
    /** 字典转模型*/
    public static func changeJsonToModel(parameters: [String: Any]) -> Any? {
        return Self.deserialize(from: parameters)
    }
}
