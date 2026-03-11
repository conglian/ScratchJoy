#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint anythink_sdk.podspec` to validate before publishing.
#

Pod::Spec.new do |s|
  s.name             = 'thinkup_sdk'
  s.version          = '1.0.8'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.static_framework = true
  s.platform = :ios, '12.0'

   s.dependency 'TPNiOS','6.4.93'
   s.dependency 'TPNVungleSDKAdapter','6.4.93'
   s.dependency 'TPNUnityAdsSDKAdapter','6.4.93.5'
   s.dependency 'TPNIronSourceSDKAdapter','6.4.93.1'
   s.dependency 'TPNBigoSDKAdapter','6.4.93.1'
   s.dependency 'TPNPangleSDKAdapter','6.4.93.6'
   s.dependency 'TPNKwaiSDKAdapter','6.4.93.1'
   s.dependency 'TPNFacebookSDKAdapter','6.4.93.8'
   s.dependency 'TPNAdmobSDKAdapter','6.4.93.1'
   s.dependency 'TPNInmobiSDKAdapter','6.4.93'
   s.dependency 'TPNMintegralSDKAdapter','6.4.93'
   s.dependency 'TPNChartboostSDKAdapter','6.4.93'
   s.dependency 'TPNFyberSDKAdapter','6.4.93.1'
   s.dependency 'TPNApplovinSDKAdapter','6.4.93.7'



  
  #************************* Manual import ******************************#
# s.frameworks = 'SystemConfiguration', 'CoreGraphics','Foundation','UIKit','AVFoundation','AdSupport','AudioToolbox','CoreMedia','StoreKit','SystemConfiguration','WebKit','AppTrackingTransparency','CoreMotion','CoreTelephony','MessageUI','SafariServices','WebKit','CoreMotion','JavaScriptCore','CoreLocation','MediaPlayer'

#  s.pod_target_xcconfig =   {'OTHER_LDFLAGS' => ['-lObjC']}

#  s.libraries = 'c++', 'z', 'sqlite3', 'xml2', 'resolv', 'bz2.1.0','bz2','xml2','resolv.9','iconv','c++abi'

# s.vendored_frameworks = 'ThirdPartySDK/*.{framework,xcframework}'

#  s.resource = 'ThirdPartySDK/**/*.bundle'

#  s.vendored_library = 'ThirdPartySDK/**/*.a'
 
#*************************************************************#

#************************ CocoaPod **********************************#

#podfile建议使用github源，文件顶部增加 source 'https://github.com/CocoaPods/Specs.git'
 

#*************************************************************#

# Flutter.framework does not contain a i386 slice.
s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }   

# s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => '$(inherited)' }
  
end
