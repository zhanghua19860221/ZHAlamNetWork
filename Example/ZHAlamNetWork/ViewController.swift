//
//  ViewController.swift
//  ZHAlamNetWork
//
//  Created by zhanghua on 06/30/2022.
//  Copyright (c) 2022 zhanghua. All rights reserved.
//

import UIKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置请求头
        ZHNetwork.initNetworkHeader()
        // 设置网络基础配置
        ZHNetwork.initNetworkConfig()
        // 网络请求
        httpRequest(TestManagerEnum.get_leftData, modelType: nil, completion: { data, code in
            print("datadatadatadata -- \(data ?? "888") ----\(code)")

        }, failed: nil, errorResult: nil, isShowToast: true,cachePolicy: .ZHCachePolicyIgnoreCache)
    }

}

