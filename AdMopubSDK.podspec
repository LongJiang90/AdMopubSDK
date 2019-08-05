#
# Be sure to run `pod lib lint AdMopubSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AdMopubSDK'
  s.version          = '1.1.1'
  s.summary          = '快速集成广告.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
快速集成广告 刚刚好方法
                       DESC

  s.homepage         = 'https://github.com/LongJiangSB/AdMopubSDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LongJiang' => '983220205@qq.com' }
  s.source           = { :git => 'https://github.com/LongJiangSB/AdMopubSDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  # s.source_files = 'AdMopubSDK/Classes/**/*'
  
  s.vendored_frameworks = 'AdMopubSDK/AdMopubSDK.framework'
  
  #是否支持ARC
  s.requires_arc = true
  
  # s.resource_bundles = {
  #   'AdMopubSDK' => ['AdMopubSDK/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
