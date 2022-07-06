#
# Be sure to run `pod lib lint ZHAlamNetWork.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZHAlamNetWork'
  s.version          = '0.9.0'
  s.summary          = 'A short description of ZHAlamNetWork.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/zhanghua19860221/ZHAlamNetWork'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhanghua' => '3051942353@qq.com' }
  s.source           = { :git => 'https://github.com/zhanghua19860221/ZHAlamNetWork.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ZHAlamNetWork/Classes/**/*'
  
  s.dependency 'Alamofire', '5.6.1'
  s.dependency 'Moya', '15.0.0'
  s.dependency 'HandyJSON', '5.0.2'
  s.dependency 'Toast-Swift', '5.0.1'

end
