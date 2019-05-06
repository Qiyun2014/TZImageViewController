#
# Be sure to run `pod lib lint TZImageViewController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TZImageViewController'
  s.version          = '1.0.0'
  s.summary          = 'A short description of TZImageViewController.'

  s.homepage     = "https://github.com/Qiyun2014/TZImageViewController"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  s.license      = "MIT"
  s.author       = { "qiyun" => "qiyun@yryz.com" }
  s.source       = { :git => "https://github.com/Qiyun2014/TZImageViewController.git", :tag => s.version.to_s}

  s.platform     = :ios, '9.0'

  s.source_files  = 'TZImageViewController/*.{h,m}'
  s.resources     = "TZImageViewController/*.bundle"

  s.frameworks   = 'AVFoundation','CoreGraphics', 'CoreAudio', 'CoreVideo','CoreTelephony', 'CoreMedia', 'AudioToolbox', 'Accelerate','VideoToolbox'
  s.ios.library  = 'c++','z','resolv.9','iconv.2.4.0'

  s.requires_arc = true
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
