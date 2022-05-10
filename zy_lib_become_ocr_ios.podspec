#
# Be sure to run `pod lib lint zy-lib-become-ocr-ios.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'zy_lib_become_ocr_ios'
  s.version          = '1.1.7'
  s.summary          = 'A short description of zy-lib-become-ocr-ios.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Edwin Sanchez/zy-lib-become-ocr-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Edwin Sanchez' => 'esanchez@zytrust.com' }
  s.source           = { :git => 'https://github.com/ZYTRUST/zy_lib_become_ocr_ios.git', :tag => "1.1.7" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'zy_lib_become_ocr_ios/Classes/**/*'
  
  s.resource_bundles = {
     'zy_lib_become_ocr_ios' => ['zy_lib_become_ocr_ios/Assets/*.{png,storyboard,plist}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  #Libreria en el directorio local
  #s.vendored_framework = 'BecomeDigitalV.framework'
  
  s.dependency 'PPBlinkID', '~> 5.16.1'
  s.dependency 'Alamofire', '~> 4.8.2'
  s.dependency 'BecomeSDK', '~> 1.1.0'
  
end
