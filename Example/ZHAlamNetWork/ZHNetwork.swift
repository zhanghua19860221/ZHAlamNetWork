//
//  ZHNetwork.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/28.
//

import UIKit
import ZHAlamNetWork

class ZHNetwork: NSObject {
    /**
     初始化网络配置
     isCollateData： 网络请求结果是否统一处理 （默认需要）
     */
    static func initNetworkConfig(_ isCollateData:Bool = true){
        // 初始化超时时间(默认为 30秒)
        //setRequestTimeOut(time: 10)
        
        // 初始化后台返回数据格式Key(默认为 "data" 、"code"、"msg")
        //setResponseFormat(result: "data", statusCode: "code", message: "msg")
        
        // 初始化服务器域名
        setBaseURL(url: "https://dev-mshop3.tiens.com.cn/mobile")
        
        // 网络请求结果是否统一处理
        guard isCollateData == true else{ return}
        
        
        // 成功请求统一处理(默认状态码是 10000 时)
        setResponseSuccessCallBack { successData in
            // 此处对传入 successData 数据进行统一处理
            // 返回需要 data 数据
            let result = successData["data"]
            
            print("successData  ---\(successData)")

            return result
        }
        
        
        // 错误请求统一处理
        setResponseFailedCallBack {  failedata in
            // 此处对传入 failedata 数据进行统一处理
            // 处理后的数据为 result 作为闭包返回结果 返回
            print("failedata  ---\(failedata ?? "1")")

        }
        
        // 失败请求统一处理
        setResponseErrorCallBack { errorData in
            // 此处对传入 errorData 数据进行统一错误处理
            // 处理后的数据为 result 作为闭包返回结果 返回
            print("errorData  ---\(errorData ?? "2")")

        }
    }
    /**
     初始化请求头
     */
    static func initNetworkHeader(){
        let header = ["Content-Type":"application/json",
                      "uid":"",
                      "token":"",
                      "platform":"9",
                      "api_version": "2.0.0",
                      "loc_id":"",
                      "device_name":"iOS",
                      "os_version":"15.0",
                      "app_version":"2.0.0",
                      "app_build":"74"
              ]
        setBaseHeaders(header: header)
    }
}
