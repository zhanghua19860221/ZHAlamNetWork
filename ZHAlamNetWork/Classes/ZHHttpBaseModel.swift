//
//  ZHHttpBaseModel.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/24.
//

import UIKit
import HandyJSON

public class ZHHttpBaseModel: HandyJSON {
    required public init() {}

    public func didFinishMapping() {}
    
    public func mapping(mapper: HelpingMapper) {}
    
    /** 字典转模型*/
    public static func changeJsonToModel(parameters: [String: Any]) -> Any? {
        return Self.deserialize(from: parameters)
    }
}
