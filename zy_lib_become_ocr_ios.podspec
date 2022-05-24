#
# Be sure to run `pod lib lint zy_lib_become_ocr_ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
# ABC IVAN CACERES

Pod::Spec.new do |s|
  s.name             = 'zy_lib_become_ocr_ios'
  s.version          = '5.0.9'
  s.summary          = 'Libreria ZYTRUSTzy_lib_become_ocr_ios.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Libreria de ZYTRUST SA , solo usarla si tiene licencia
captura de OCR
                       DESC

  s.homepage         = 'https://github.com/ZYTRUST/zy_lib_become_ocr_ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ZYTRUST SA' => 'ztmobile@zytrust.com' }
  s.source           = { :git => 'https://github.com/ZYTRUST/zy_lib_become_ocr_ios.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  #s.source_files = 'zy_lib_become_ocr_ios/Classes/**/*'
  
  
  #s.source_files = 'zy_lib_become_ocr_ios/Classes/**/*'
  #s.public_header_files = "zy_lib_become_ocr_ios.framework/Headers/*.h"
  #s.vendored_frameworks = 'zy_lib_become_ocr_ios.framework'
  # s.resource_bundles = {
  #   'zy_lib_become_ocr_ios' => ['zy_lib_become_ocr_ios/Assets/*.png']
  # }
  
  
  s.swift_version = '5.0'


  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'PPBlinkID', '~> 5.16.1'
  s.dependency 'Alamofire', '~> 4.8.2'
  #s.dependency 'BecomeSDK', '~> 1.1.0'
  
end
