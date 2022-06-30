//
//  ZHHttpBaseManager.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/24.
//

import Moya
import Foundation


/** 超时时长*/
private var requestTimeOut: Double = 30
/** 数据请求成功StatusCode*/
private var requestSuccessCode: Int = 10000


/** 成功数据的回调*/
typealias successCallBack = (Any?, Int) ->()

/** 失败的回调*/
typealias failedCallBack = (Any?, Int) ->()

/// 网络错误的回调
typealias errorCallBack = (Any?) -> ()

/** 请求失败统一处理*/
typealias responseErrorCallback = (Any?) ->()

/** 请求错误统一处理*/
typealias responseFailedCallBack = (Any?) ->()

/** 请求成功统一处理*/
typealias responseSuccessCallBack = ([String: Any]) ->(Any?)

/** 请求返回结果Key*/
fileprivate var RESULT_DATA = "data"    // 数据
fileprivate var RESULT_CODE = "code"    // 状态码
fileprivate var RESULT_MESSAGE = "msg"  // 错误消息提示

fileprivate var CONNECT_ERROR = "网络连接错误，请稍后重试"  // 错误消息提示


fileprivate var responseBlock:responseSuccessCallBack?

fileprivate var responseErrorBlock:responseErrorCallback?

fileprivate var responseFailedBlock:responseFailedCallBack?



/**
 设置网络请求超时时间
 */
func setRequestTimeOut(time:Double){
    
    requestTimeOut = time
}

/**
 设置网络成功StatusCode
 */
func setRequestSuccessStatusCode(code:Int){
    
    requestSuccessCode = code
}

/**
 设置后台返回数据 Key
 result：    返回的数据
 message：   返回的信息
 statusCode：错误码

 */
func setResponseFormat(result:String ,statusCode:String,message:String){
    RESULT_DATA = result
    RESULT_CODE = statusCode
    RESULT_MESSAGE = message
}

/**
 设置网络连接错误提示语
 */
func setConnectErrorString(tip:String){
    
    CONNECT_ERROR = tip
}
/**
 请求失败统一处理
 */
func setResponseErrorCallBack(callBack:@escaping responseErrorCallback){
    
    responseErrorBlock = callBack
}

/**
 请求错误统一处理
 */
func setResponseFailedCallBack(callBack:@escaping responseFailedCallBack){
    
    responseFailedBlock = callBack
}


/**
 请求成功统一处理
 */
func setResponseSuccessCallBack(callBack:@escaping responseSuccessCallBack){
    
    responseBlock = callBack
}

/**
 网络请求的基本设置,这里可以拿到是具体的哪个网络请求，可以在这里做一些设置
 */
private let myEndpointClosure = { (target: TargetType) -> Endpoint in
    // 这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有（ ? 空格 ）时无法解析的问题
    // https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    
    var task = target.task
    
    //如果需要在每个请求中都添加类似token参数的参数请取消注释下面代码
    // 👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
    //    let additionalParameters = ["token":"888888"]
    //    let defaultEncoding = URLEncoding.default
    //    switch target.task {
    //        ///在你需要添加的请求方式中做修改就行，不用的case 可以删掉。。
    //    case .requestPlain:
    //        task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
    //    case .requestParameters(var parameters, let encoding):
    //        additionalParameters.forEach { parameters[$0.key] = $0.value }
    //        task = .requestParameters(parameters: parameters, encoding: encoding)
    //    default:
    //        break
    //    }
    // 👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
    // 如果需要在每个请求中都添加类似token参数的参数请取消注释上面代码
     

    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    
    // 每次请求都会调用endpointClosure 到这里设置超时时长 也可单独每个接口设置
    requestTimeOut = target.requestTime()
    
     
    
    
    return endpoint
}

/**
 网络请求的设置
 */
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 设置请求时长
        request.timeoutInterval = requestTimeOut
        
        // 打印请求信息
        if let requestData = request.httpBody {
            print("请求路径：\n\(request.url!)\n" + "请求方式：\n\(request.httpMethod ?? "")\n" + "请求参数：\n\(String(data: request.httpBody!, encoding: String.Encoding.utf8) ?? "")\n")
        } else {
            print("请求路径：\n\(request.url!)\n" + "请求方式：\n\(String(describing: request.httpMethod))\n")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/**
 NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
 但这里我没怎么用这个。。。 loading的逻辑直接放在网络处理里面了
 */
private let networkPlugin = NetworkActivityPlugin.init { changeType, _ in
    print("networkPlugin \(changeType)")
    // targetType 是当前请求的基本信息
    switch changeType {
    case .began:
        print("开始请求网络")

    case .ended:
        print("结束")
    }
}



/**
 参数使用说明
 https://github.com/Moya/Moya/blob/master/docs/Providers.md
 stubClosure   用来延时发送网络请求
 网络请求发送的核心初始化方法，创建网络请求对象
 👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
 还可以直接初始化 Provider
 let Provider = MoyaProvider<MultiTarget>()
 这种初始化方法 将不会调用 myEndpointClosure  requestClosure networkPlugin 这三个属性初始化方法 对网络请求不做任何处理
 👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
 
 */
let Provider = MoyaProvider<MultiTarget>(endpointClosure: myEndpointClosure, requestClosure: requestClosure, plugins: [networkPlugin], trackInflights: false)



/**
 最常用的网络请求，只需知道 成功 后返回的结果，只要有错误就会走统一处理
 Parameters:
 target: 网络请求配置
 modelType:返回指定类型的数据 Model
 isShowToast:是否展示Toast
 completion: 请求成功的回调
 cachePolicy: 缓存策略
 cacheID: 设置缓存ID（缓存默认是通过URL做为key来缓存的，如果两个URL相同仅是单参数不同时，就需要传入cacheID来区分缓存）
 */
func NetWorkRequest<T:ZHHttpBaseModel>(_ target: TargetType,
                                       modelType: T.Type? = nil.self,
                                       completion: @escaping successCallBack,
                                       isShowToast: Bool = false,
                                       cachePolicy:ZHCachePolicy = ZHCachePolicy(rawValue: 0)! ,
                                       cacheID:String = "")
{
    NetWorkRequest(target, modelType: modelType, completion: completion, failed: nil, errorResult: nil, isShowToast: isShowToast,cachePolicy:cachePolicy,cacheID:cacheID)
}

/**
 需要知道 成功 或 失败 网络请求的结果
 Parameters:
 target: 网络请求配置
 modelType:返回指定类型的数据 Model
 completion: 请求成功的回调
 failed: 请求失败的回调
 isShowToast:是否展示Toast
 cachePolicy: 缓存策略
 cacheID: 设置缓存ID（缓存默认是通过URL做为key来缓存的，如果两个URL相同仅是单参数不同时，就需要传入cacheID来区分缓存）
*/
func NetWorkRequest<T: ZHHttpBaseModel>(_ target: TargetType,
                                        modelType: T.Type? = nil.self,
                                        completion: @escaping successCallBack,
                                        failed: failedCallBack?,
                                        isShowToast: Bool = false,
                                        cachePolicy:ZHCachePolicy = ZHCachePolicy(rawValue: 0)! ,
                                        cacheID:String = "")
{
    NetWorkRequest(target, modelType: modelType, completion: completion, failed: failed, errorResult: nil, isShowToast: isShowToast,cachePolicy:cachePolicy,cacheID:cacheID)
}


/**
 需要知道成功、失败、错误情况回调的网络请求   像结束下拉刷新各种情况都要判断
 Parameters:
 target: 网络请求配置
 completion: 请求成功的回调
 failed: 请求失败的回调
 error: 请求错误的回调
 isShowToast: 是否显示toast
 cachePolicy: 缓存策略
 cacheID: 设置缓存ID（缓存默认是通过URL做为key来缓存的，如果两个URL相同仅是单参数不同时，就需要传入cacheID来区分缓存）
 👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇👇
 @discardableResult
 当有返回值的方法,返回值未得到接收和使用时通常会出现提示
 在正式编译中不会影响编译结果，但是也妨碍代码的美观整洁，在方法上加上discardableResult就可以取消这个警告
 👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆👆
 */
@discardableResult
func NetWorkRequest<T: ZHHttpBaseModel>(_ target: TargetType,
                                        modelType: T.Type? = nil.self,
                                        completion: @escaping successCallBack,
                                        failed: failedCallBack?,
                                        errorResult: errorCallBack?,
                                        isShowToast: Bool = false,
                                        cachePolicy:ZHCachePolicy = ZHCachePolicy(rawValue: 0)! ,
                                        cacheID:String = "") -> Cancellable?
{
    
    // 先判断网络是否有链接,没有网络连接的话。给出错误提示
    if !UIDevice.currentNetReachability(callBack: {_ in }) {
        ZHToastKeyWindowShowText(CONNECT_ERROR, position: .center)
        return nil
    }
    var cancellable:Cancellable? = nil
    
    switch cachePolicy {
    case .ZHCachePolicyIgnoreCache:
        // 只从网络获取数据，且数据不会缓存在本地
        cancellable = HttpDataWithCacheForURL(target, modelType: modelType, completion: completion, failed: failed, errorResult: errorResult, isShowToast: isShowToast, isCache: false,cacheID: cacheID)
        break
    case .ZHCachePolicyCacheOnly:
        // 只从缓存读数据，如果缓存没有数据，返回一个空
        cancellable = HttpDataForCache(target, modelType: modelType, completion: completion, failed: failed, errorResult: errorResult, isShowToast: isShowToast, isNetwork: false,cacheID: cacheID)
        
        break
    case .ZHCachePolicyNetworkOnly:
        // 先从网络获取数据，同时会在本地缓存数据
        cancellable = HttpDataWithCacheForURL(target, modelType: modelType, completion: completion, failed: failed, errorResult: errorResult, isShowToast: isShowToast, isCache: true,cacheID: cacheID)
        
        break
    case .ZHCachePolicyCacheElseNetwork:
        // 先从缓存读取数据，如果没有再从网络获取
        cancellable = HttpDataForCache(target, modelType: modelType, completion: completion, failed: failed, errorResult: errorResult, isShowToast: isShowToast, isNetwork: true,cacheID: cacheID)
        
        break
    case .ZHCachePolicyNetworkElseCache:
        // 网络请求失败时，从缓存中获取数据
        cancellable = HttpDataWithCacheForRequestFaile(target, modelType: modelType, completion: completion, failed: failed, errorResult: errorResult, isShowToast: isShowToast, isCache: true, cacheID: cacheID)
        
        break
    
    case .ZHCachePolicyCacheThenNetwork:
        // 先从缓存读取数据，然后再从网络获取并且缓存，在这种情况下，Block将产生两次调用
        cancellable = HttpDataForCacheWithURL(target, modelType: modelType, completion: completion, failed: failed, errorResult: errorResult, isShowToast: isShowToast, cacheID: cacheID)
        break
    }

    return cancellable
}
/**
 获取网络数据
 Parameters:
 target: 网络请求配置
 completion: 请求成功的回调
 failed: 请求失败的回调
 error: 请求错误的回调
 isShowToast: 是否显示toast
 isCache: 是否缓存数据
 cacheID: 设置缓存ID（缓存默认是通过URL做为key来缓存的，如果两个URL相同仅是单参数不同时，就需要传入cacheID来区分缓存）
 */
fileprivate func HttpDataWithCacheForURL<T: ZHHttpBaseModel>(_ target: TargetType,
                                        modelType: T.Type? = nil.self,
                                        completion: @escaping successCallBack,
                                        failed: failedCallBack?,
                                        errorResult: errorCallBack?,
                                        isShowToast: Bool,
                                        isCache: Bool,
                                        cacheID:String)-> Cancellable?
{
    
    let startTime = Date().milliStamp
    return Provider.request(MultiTarget(target)) { result in
        let endTime = Date().milliStamp
        // 隐藏 hud
        ZHToastKeyWindowHide()
        switch result {
        case let .success(response):
            do {
                                
                if let jsonData = try JSONSerialization.jsonObject(with: response.data, options: .mutableLeaves) as? [String: Any] {
                    
                    // 字典转 JSON 字符串
                    let jsonStr = jsonData.toJSONString()
                    // 打印请求信息
                    print("👇🌏👇🌏👇🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏👇（（\(target.path)））👇🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏👇🌏👇🌏👇\n 请求路径:\n \(target.path)\n 请求方式:\n \(target.method)\n 请求耗时:\n \(endTime - startTime)毫秒\n 请求头:\n \(String(describing: response.request?.allHTTPHeaderFields))\n 请求结果:\n \(jsonStr)\n 👆🌏👆🌏👆🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏👆（（\(target.path)））👆🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏👆🌏👆🌏👆\n")
                    
                    if let code = jsonData[RESULT_CODE] as? Int {
                        // 请求成功
                        if code == requestSuccessCode {
                            // 数据处理
                            processingData(jsonData: jsonData, code: code, modelType: modelType, completion: completion)
                           
                            // 缓存数据
                            guard isCache == true else{ return}
                            let path = getCachePath(target, cacheID: cacheID)
                            saveCacheData(path, data: response.data)
                            
                        }else{
                            // 返回未处理的错误结果
                            guard failed == nil else{
                                failed!(jsonData,code)
                                return
                            }
                            
                            // 统一处理错误，无需返回错误
                            guard let failedBlock = responseFailedBlock else { return }
                            failedBlock(jsonData)
                        }
                    }
                }else{
                  print("数据格式返回不正确")
                }
            } catch {

            }
            break
        case let .failure(error):
            // 网络连接失败，提示用户
            print("网络连接失败\(error)")
            
            // 返回未处理的失败结果
            guard errorResult == nil else{
                errorResult!(error)
                return
            }
            
            // 统一处理失败，无需返回失败信息
            guard let errorBlock = responseErrorBlock else { return }
            errorBlock(error)
            
            break
        }
    }
}

/**
 网络请求失败时 从缓存中获取数据
 Parameters:
 target: 网络请求配置
 completion: 请求成功的回调
 failed: 请求失败的回调
 error: 请求错误的回调
 isShowToast: 是否显示toast
 isCache: 是否缓存数据
 cacheID: 设置缓存ID（缓存默认是通过URL做为key来缓存的，如果两个URL相同仅是单参数不同时，就需要传入cacheID来区分缓存）
 */
fileprivate func HttpDataWithCacheForRequestFaile<T: ZHHttpBaseModel>(_ target: TargetType,
                                        modelType: T.Type? = nil.self,
                                        completion: @escaping successCallBack,
                                        failed: failedCallBack?,
                                        errorResult: errorCallBack?,
                                        isShowToast: Bool,
                                        isCache: Bool,
                                        cacheID:String)-> Cancellable?
{
    
    let startTime = Date().milliStamp
    return Provider.request(MultiTarget(target)) { result in
        let endTime = Date().milliStamp
        // 隐藏 hud
        ZHToastKeyWindowHide()
        switch result {
        case let .success(response):
            do {
                                
                if let jsonData = try JSONSerialization.jsonObject(with: response.data, options: .mutableLeaves) as? [String: Any] {
                    
                    // 字典转 JSON 字符串
                    let jsonStr = jsonData.toJSONString()
                    // 打印请求信息
                    print("👇🌏👇🌏👇🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏👇（（\(target.path)））👇🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏👇🌏👇🌏👇\n 请求路径:\n \(target.path)\n 请求方式:\n \(target.method)\n 请求耗时:\n \(endTime - startTime)毫秒\n 请求头:\n \(String(describing: response.request?.allHTTPHeaderFields))\n 请求结果:\n \(jsonStr)\n 👆🌏👆🌏👆🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏👆（（\(target.path)））👆🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏🌏👆🌏👆🌏👆\n")
                    
                    if let code = jsonData[RESULT_CODE] as? Int {
                        // 请求成功
                        if code == requestSuccessCode {
                            // 数据处理
                            processingData(jsonData: jsonData, code: code, modelType: modelType, completion: completion)
                           
                            // 缓存数据
                            guard isCache == true else{ return}
                            let path = getCachePath(target, cacheID: cacheID)
                            saveCacheData(path, data: response.data)
                            
                        }else{
                            
                            //返回缓存数据
                            HttpDataForCache(target, modelType: modelType, completion: completion, failed: nil, errorResult: nil, isShowToast: isShowToast, isNetwork: false, cacheID: cacheID)
                            
                            // 返回未处理的错误结果
                            guard failed == nil else{
                                failed!(jsonData,code)
                                return
                            }
                            
                            // 统一处理错误，无需返回错误
                            guard let failedBlock = responseFailedBlock else { return }
                            failedBlock(jsonData)
                        }
                    }
                }else{
                  print("数据格式返回不正确")
                }
            } catch {

            }
            break
        case let .failure(error):
            //返回缓存数据
            HttpDataForCache(target, modelType: modelType, completion: completion, failed: nil, errorResult: nil, isShowToast: isShowToast, isNetwork: false, cacheID: cacheID)
            
            // 网络连接失败，提示用户
            print("网络连接失败\(error)")
            
            // 返回未处理的失败结果
            guard errorResult == nil else{
                errorResult!(error)
                return
            }
            
            // 统一处理失败，无需返回失败信息
            guard let errorBlock = responseErrorBlock else { return }
            errorBlock(error)
            
            break
        }
    }
}

/**
 仅从缓存获取数据
 Parameters:
 target: 网络请求配置
 completion: 请求成功的回调
 failed: 请求失败的回调
 error: 请求错误的回调
 isShowToast: 是否显示toast
 isNetwork: 没有缓存数据的情况下 是否从网络获取数据
 cacheID: 设置缓存ID（缓存默认是通过URL做为key来缓存的，如果两个URL相同仅是单参数不同时，就需要传入cacheID来区分缓存）
 */
@discardableResult
func HttpDataForCache<T: ZHHttpBaseModel>(_ target: TargetType,
                                        modelType: T.Type? = nil.self,
                                        completion: @escaping successCallBack,
                                        failed: failedCallBack?,
                                        errorResult: errorCallBack?,
                                        isShowToast: Bool,
                                        isNetwork: Bool,
                                        cacheID:String)-> Cancellable?
{
    
    if isNetwork == false { ZHToastKeyWindowHide()}
    
    var cancellable:Cancellable? = nil

    // 获取缓存路径
    let cachePath = getCachePath(target, cacheID: cacheID)
    
    // 获取缓存数据
    getCacheData(cachePath) { data in
        guard let cacheData = data  else {
            // 获取网络数据,并缓存数据
            if isNetwork == true {
                cancellable = HttpDataWithCacheForURL(target, modelType: modelType, completion: completion, failed: failed, errorResult: errorResult, isShowToast: isShowToast, isCache: true,cacheID: cacheID)
            }else{
                // 返回空数据
                completion(nil,requestSuccessCode)
            }
            return
        }
        do {
            if let jsonData = try JSONSerialization.jsonObject(with: cacheData, options: .mutableLeaves) as? [String: Any] {
                processingData(jsonData: jsonData, code: requestSuccessCode, modelType: modelType, completion: completion)
            }else{
              print("数据格式返回不正确")
            }
        } catch {
            print("获取缓存数据失败\(error)")
        }

    }

    return cancellable
}


/**
 先从缓存获取数据，然后网络请求并缓存
 Parameters:
 target: 网络请求配置
 completion: 请求成功的回调
 failed: 请求失败的回调
 error: 请求错误的回调
 isShowToast: 是否显示toast
 isNetwork: 没有缓存数据的情况下 是否从网络获取数据
 cacheID: 设置缓存ID（缓存默认是通过URL做为key来缓存的，如果两个URL相同仅是单参数不同时，就需要传入cacheID来区分缓存）
 */
@discardableResult
func HttpDataForCacheWithURL<T: ZHHttpBaseModel>(_ target: TargetType,
                                        modelType: T.Type? = nil.self,
                                        completion: @escaping successCallBack,
                                        failed: failedCallBack?,
                                        errorResult: errorCallBack?,
                                        isShowToast: Bool,
                                        cacheID:String)-> Cancellable?
{
    var cancellable:Cancellable? = nil

    // 获取缓存路径
    let cachePath = getCachePath(target, cacheID: cacheID)
    
    // 获取缓存数据
    getCacheData(cachePath) { data in
        guard let cacheData = data  else { return}
        do {
            if let jsonData = try JSONSerialization.jsonObject(with: cacheData, options: .mutableLeaves) as? [String: Any] {
                processingData(jsonData: jsonData, code: requestSuccessCode, modelType: modelType, completion: completion)
                
                cancellable = HttpDataWithCacheForURL(target, modelType: modelType, completion: completion, failed: failed, errorResult: errorResult, isShowToast: isShowToast, isCache: true,cacheID: cacheID)
                
            }else{
              print("数据格式返回不正确")
            }
        } catch {
            print("获取缓存数据失败\(error)")
        }

    }

    return cancellable
}


/**
 处理网络数据
 jsonData 需要处理的数据
 code 错误码
 modelType model类型
 completion 成功回调
 */

func processingData<T: ZHHttpBaseModel>(jsonData:[String: Any],
                                        code:Int,
                                        modelType: T.Type? = nil.self,
                                        completion: @escaping successCallBack){
    // 返回未处理的成功结果
    guard let responseSuccessBlock = responseBlock else {
        completion(jsonData,code)
        return
    }
    
    // 判断是否需要字典转模型
    guard modelType != nil else {
        completion(responseSuccessBlock(jsonData),code)
        return
    }
    
    // 返回处理的结果
    let result = responseSuccessBlock(jsonData)
    
    if let resultWithArray = result as? [Any] {
        // 数组转模型
        var modelArray = [Any]()
        for orgItem in resultWithArray{
            if let item = orgItem as? [String: Any] {
                modelArray.append(T.changeJsonToModel(parameters: item) ?? T())
            }
        }
        completion(modelArray,code)
        return
    }else if let resultWithDic = result as? [String: Any] {
        // 字典转模型
        completion(T.changeJsonToModel(parameters:resultWithDic) ,code)
        return
    }
    
}

/**
 设置 缓存 路径
 target 网络设置
 cacheID 缓存ID
 */
func getCachePath(_ target: TargetType,cacheID:String) ->String{
    /// 缓存代码 设置缓存路径
    let pathcaches = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
    let cachesDir = pathcaches[0]
    let mutableSting = target.baseURL.absoluteString + target.path
    let lastStr = mutableSting.replacingOccurrences(of: "/", with: "-")
    let disPath = cacheID + cachesDir + "/" + lastStr + "-.text"
    
    return disPath
}

/**
 保存 缓存 数据
 cachePath 缓存路径
 data 被保存缓存数据
 */
func saveCacheData(_ cachePath: String, data:Data){
    // 缓存
    let jsonString = String(data: data, encoding: String.Encoding.utf8) ?? ""
    DispatchQueue.global().async {
        do {
            try jsonString.write(toFile: cachePath, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("数据缓存存储失败-\(error)")
        }
    }
    
}

/**
 获取 缓存 数据
 cachePath 缓存路径
 callBack  返回获取到的缓存数据
 */
func getCacheData(_ cachePath: String,callBack:@escaping (Data?) ->()){
    DispatchQueue.global().async {
        do {
            let str = try String .init(contentsOfFile: cachePath, encoding: String.Encoding.utf8)
            DispatchQueue.main.async {
                /// 字符串转化为data
                let data = str.data(using: String.Encoding.utf8, allowLossyConversion: true)
                callBack(data)
            }
        } catch {
            callBack(nil)
            print("数据缓存获取失败-\(error)")
        }
    }
    
}
