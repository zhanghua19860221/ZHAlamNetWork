//
//  ZHHttpGeneralTools.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/24.
//

import UIKit
/**
 网络状态
 */
public enum NetworkStatus: String {
    
    case unknown = "未知网络"
    
    case notReachable = "未连接网络"
    
    case WIFI = "wift网络"
    
    case WWAN = "手机网络"
}
/**
 缓存策略
 */
 public enum ZHCachePolicy: Int {
    // 只从网络获取数据，且数据不会缓存在本地
    case ZHCachePolicyIgnoreCache = 0
    // 只从缓存读数据，如果缓存没有数据，返回一个空
    case ZHCachePolicyCacheOnly = 1
    // 先从网络获取数据，同时会在本地缓存数据
    case ZHCachePolicyNetworkOnly = 2
    // 先从缓存读取数据，如果没有再从网络获取
    case ZHCachePolicyCacheElseNetwork = 3
    // 网络请求失败时，从缓存中获取数据
    case ZHCachePolicyNetworkElseCache = 4
    // 先从缓存读取数据，然后再从网络获取并且缓存，在这种情况下，Block将产生两次调用
    case ZHCachePolicyCacheThenNetwork = 5
    
}

public class ZHHttpGeneralTools: NSObject {
    // 获取当前窗口 keyWindow
    public static let keyWindow:UIWindow = (UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow)!
    
}
