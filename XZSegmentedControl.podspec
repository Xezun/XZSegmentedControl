#
# Be sure to run `pod lib lint XZSegmentedControl.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#



Pod::Spec.new do |s|
  s.name             = 'XZSegmentedControl'
  s.version          = '1.0.0'
  s.summary          = '对原生框架的拓展，提高开发效率'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       XZSegmentedControl 包含了对原生框架的拓展，丰富了原生框架的功能，提高了开发效率。
                       DESC

  s.homepage         = 'https://github.com/Xezun/XZSegmentedControl'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Xezun' => 'developer@xezun.com' }
  s.source           = { :git => 'https://github.com/Xezun/XZSegmentedControl.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'XZ_FRAMEWORK=1' }
  
  s.default_subspec = 'Code'
  
  s.subspec 'Code' do |ss|
    ss.source_files = 'XZSegmentedControl/Code/**/*.{h,m}'
    ss.dependency 'XZDefines'
  end
  
 
  # s.resource_bundles = {
  #   'XZSegmentedControl' => ['XZSegmentedControl/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  
  # def s.defineSubspec(name, dependencies)
  #   self.subspec name do |ss|
  #     ss.public_header_files = "XZSegmentedControl/Code/#{name}/**/*.h";
  #     ss.source_files        = "XZSegmentedControl/Code/#{name}/**/*.{h,m}";
  #     for dependency in dependencies
  #       ss.dependency dependency;
  #     end
  #   end
  # end
  
  # s.defineSubspec 'CAAnimation',        [];

end

