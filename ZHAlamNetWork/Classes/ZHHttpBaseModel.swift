//
//  ZHHttpBaseModel.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/24.
//

import UIKit
import HandyJSON

class ZHHttpBaseModel: HandyJSON {
    required init() {}

    func didFinishMapping() {}
    
    func mapping(mapper: HelpingMapper) {}
    
    /** 字典转模型*/
    public static func changeJsonToModel(parameters: [String: Any]) -> Any? {
        return Self.deserialize(from: parameters)
    }
}
