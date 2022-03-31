#
# Be sure to run `pod lib lint KEPRequestCapture.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KEPRequestCapture'
  s.version          = '1.0.0'
  s.summary          = 'Network debugging made easy.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Start debugging iOS network calls like a wizard, makes debugging quick and reliable.
                       DESC

  s.homepage         = 'https://github.com/dengDaiHuaJianChengDie/KEPRequestCapture'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'dengDaiHuaJianChengDie' => 'weitianwen@keep.com' }
  s.source           = { :git => 'https://github.com/dengDaiHuaJianChengDie/KEPRequestCapture.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'KEPRequestCapture/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KEPRequestCapture' => ['KEPRequestCapture/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'JSONModel'
  s.dependency 'Masonry'
  s.dependency 'FMDB'
end
