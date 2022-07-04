//
//  ZHToastManager.swift
//  ZHAlamNetWork
//
//  Created by Breeze on 2022/6/24.
//

import UIKit
import Toast_Swift

//默认展示时长
public var toastShowTime:TimeInterval = 3

/**
 设置展示时长
 */
public func setToastShowTime(time:TimeInterval){
    toastShowTime = time
}

/**
 展示Toast
 - view：Toast所在视图
 */
public func ZHToastKeyWindowShow(view:UIView? = ZHHttpGeneralTools.keyWindow){
    guard let showView = view else {return}
    showView.makeToastActivity(.center)
}

/**
 隐藏Toast
 - view：Toast所在视图
 */
public func ZHToastKeyWindowHide(view:UIView? = ZHHttpGeneralTools.keyWindow) {
    guard let hideView = view else { return }
    if Thread.isMainThread {
        hideView.hideToastActivity()
        return
    }
    DispatchQueue.main.async {
        hideView.hideToastActivity()
    }
}

/**
 隐藏所有Toast
 - view：Toast所在视图(默认移除所有keyWindow 上的toast ，如想移除指定视图上的toast，需将view 作为参数传入)
 */
public func ZHHideAllToasts(view:UIView? = ZHHttpGeneralTools.keyWindow) {
    guard let hideView = view else { return }
    hideView.hideAllToasts()
}



/**
 展示文本Toast
 - text：    展示内容
 - duration：展示时长
 - position：展示位置
 - view：    Toast所在视图
 */
public func ZHToastKeyWindowShowText(_ text:String = "",duration:TimeInterval = toastShowTime ,position:ToastPosition = .center,view:UIView? = ZHHttpGeneralTools.keyWindow) {
    guard let showView = view else { return }
    showView.makeToast(text,duration: duration,position: position)

}

/**
 隐藏文本Toast
 - view：Toast所在视图
 */
public func ZHToastKeyWindowHideText(view:UIView? = ZHHttpGeneralTools.keyWindow) {
    guard let hideView = view else { return }
    hideView.hideToast(view!)
}
