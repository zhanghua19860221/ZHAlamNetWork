# ZHAlamNetWork

[![CI Status](https://img.shields.io/travis/zhanghua/ZHAlamNetWork.svg?style=flat)](https://travis-ci.org/zhanghua/ZHAlamNetWork)
[![Version](https://img.shields.io/cocoapods/v/ZHAlamNetWork.svg?style=flat)](https://cocoapods.org/pods/ZHAlamNetWork)
[![License](https://img.shields.io/cocoapods/l/ZHAlamNetWork.svg?style=flat)](https://cocoapods.org/pods/ZHAlamNetWork)
[![Platform](https://img.shields.io/cocoapods/p/ZHAlamNetWork.svg?style=flat)](https://cocoapods.org/pods/ZHAlamNetWork)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ZHAlamNetWork is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ZHAlamNetWork'
```

## Author

zhanghua, 3051942353@qq.com

## License

ZHAlamNetWork is available under the MIT license. See the LICENSE file for more info.

##  open & public 不同

open 是 Swift 3 新增的访问控制符，相较于 public 更加开放。open 和 public 都是可以跨 Module 访问的，但 open 修饰的类可以继承，修饰的方法可以重写（此时，open 需同时修饰该方法以及所在类），而 public 不可以。

至于 public final 与 public，前者在任何地方均不可重写，而后者可在本 Module 内重写。

ZHHttpBaseModel需要被跨Module继承所以需要使用 open 修饰

跨Module共用的类或者属性及方法可以使用 public 修饰 。




