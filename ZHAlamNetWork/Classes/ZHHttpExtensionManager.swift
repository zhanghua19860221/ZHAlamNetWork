//
//  ZHHttpExtensionManager.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/24.
//
import Foundation
import Alamofire


extension UIDevice {
    /**
     返回当前网络状态
     */
    @discardableResult
    static func currentNetReachability(callBack:@escaping (NetworkStatus)->()) ->(Bool){
        let statusManager  = NetworkReachabilityManager()
        var connectStatus = true
//        statusManager?.startListening(onUpdatePerforming: { status in
//            switch status {
//            case .notReachable:
//                callBack(NetworkStatus.notReachable)
//                connectStatus = false
//                break
//            case .unknown:
//                callBack(NetworkStatus.unknown)
//                break
//            case .reachable(_):
//                if (statusManager?.isReachableOnEthernetOrWiFi)! {
//                    callBack(NetworkStatus.WIFI)
//
//                } else if(statusManager?.isReachableOnCellular)!  {
//                    callBack(NetworkStatus.WWAN)
//
//                }
//                break
//            }
//        })
        return connectStatus
    }
}

extension Dictionary{
    /**
     字典转字符串
     Parameter dict: 字典
     Returns: 返回字符串
     */
    @discardableResult
    func toJSONString()->String{

        let data = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let strJson = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
        
        return strJson! as String

    }

}


public extension Date {
    // 获取 秒级 时间戳
    var timeStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    // 获取 豪秒级 时间戳
    var milliStamp : CLongLong {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let milliStamp = CLongLong(round(timeInterval*1000))
        return milliStamp
    }
    
    // 计算传入的时间戳距离现在还有多少天，毫秒级
    func compareCurrentDays(timeStamp: String) -> String {
        var differenceValue = Date().timeIntervalSinceNow - (Double(timeStamp) ?? 0)/1000
        if differenceValue < 0 {
            differenceValue = -differenceValue
        }
        if differenceValue <= 60 {
            return "1分钟"
        }else if Int(differenceValue/60) < 60 {
            return "\(Int(differenceValue/60))分钟"
        }else if Int((differenceValue/60)/60) < 24 {
            return "\(Int((differenceValue/60)/60))小时"
        }else {
            return "\(Int(((differenceValue/60)/60)/24))天"
        }
    }
    
    func compareCurrntTime(timeStamp:String) -> String {
        //计算出时间戳距离现在时间的一个秒数(..s)
        let interval:TimeInterval=TimeInterval(timeStamp)!
        let date = Date (timeIntervalSince1970: interval)
        var timeInterval = date.timeIntervalSinceNow
        //得到的是一个负值 (加' - ' 得正以便后面计算)
        timeInterval = -timeInterval
        //根据时间差 做所对应的文字描述 (作为返回文字描述)
        var result:String
            //一分钟以内
        if interval < 60{
            result = "刚刚"
            return result
        } else if Int(timeInterval/60) < 60{
            //一小时以内
            result = String.init(format:"%@分钟前",String(Int(timeInterval/60)))
            return result
        } else if Int((timeInterval/60)/60) < 24{
            //一天以内
            result = String.init(format:"%@小时前",String(Int((timeInterval/60)/60)))
            return result
        }else{
            //超过一天的
            let dateformatter = DateFormatter()
            //自定义日期格式
            dateformatter.dateFormat="yyyy年MM月dd日 HH:mm"
            result = dateformatter.string(from: date as Date)
            return result
        }
    }
    
    // 通过时间戳 获取时间戳时间 （自定义 时间格式）
    func compareCustomCurrntTime(timeStamp:String ,formatter:String = "yyyy年MM月dd日 HH:mm") -> String {
        if timeStamp.count <= 0 {
            return ""
        }
        let  interval:TimeInterval=TimeInterval.init(timeStamp)!

        let date = Date(timeIntervalSince1970: interval)

        let dateformatter = DateFormatter()

        //自定义日期格式

        dateformatter.dateFormat = formatter

        return dateformatter.string(from: date)
    }
    
    // 获取当前时间 （可自定义 时间格式）
    func getCurrntTime(formatter:String = "yyyy年MM月dd日 HH:mm") -> String {
        let  now =  NSDate ()
        let  timeInterval: TimeInterval  = now.timeIntervalSince1970
        let  timeStamp =  Int (timeInterval)
        let  interval:TimeInterval=TimeInterval.init(String(timeStamp))!
        let date = Date(timeIntervalSince1970: interval)

        let dateformatter = DateFormatter()
        
        //自定义日期格式
        dateformatter.dateFormat = formatter
        
        return dateformatter.string(from: date)
    }

}
