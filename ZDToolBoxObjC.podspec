#
# Be sure to run `pod lib lint ZDToolBoxObjC.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZDToolBoxObjC'
  s.version          = '0.0.7'
  s.summary          = 'iOS开发工具箱'
  s.description      = <<-DESC
    iOS开发工具箱，包含子类、分类、工具类
                       DESC
  s.homepage         = 'https://github.com/faimin/ZDToolBoxObjC'
  s.license          = { 
    :type => 'MIT', 
    :file => 'LICENSE' 
}
  s.author           = { 'Zero.D.Saber' => 'fuxianchao@gmail.com' }
  s.source           = { 
    :git => 'https://github.com/faimin/ZDToolBoxObjC.git', 
    :tag => s.version.to_s 
  }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.prefix_header_file = false
  
  s.module_name  = 'ZDToolBoxObjC'
  s.pod_target_xcconfig = {
     'DEFINES_MODULE' => 'YES'
  }

  s.ios.deployment_target = '10.0'

  s.subspec 'ZDCommonTool' do |ss|
    ss.source_files = 'ZDToolBoxObjC/Classes/ZDCommonTool/*.{h,m}'
  end

  s.subspec 'ZDMacros' do |ss|
    ss.source_files = 'ZDToolBoxObjC/Classes/ZDMacros/*.{h,m}'
    ss.dependency 'ZDToolBoxObjC/ZDCommonTool'
  end

  s.subspec 'ZDProxy' do |ss|
    ss.source_files = 'ZDToolBoxObjC/Classes/ZDProxy/*.{h,m}'
  end

  s.subspec 'ZDCategory' do |ss|
    ss.subspec 'Foundation' do |sss|
      sss.source_files = 'ZDToolBoxObjC/Classes/ZDCategory/Foundation/*.{h,m}'
      #sss.private_header_files = 'ZDToolBoxObjC/Classes/ZDCategory/Foundation/ZDDictionaryProtocol.h'
      sss.frameworks = 'UIKit', 'Foundation', 'CoreText'
    end

    ss.subspec 'UIKit' do |sss|
      sss.source_files = 'ZDToolBoxObjC/Classes/ZDCategory/UIKit/*.{h,m}'
      sss.frameworks = 'UIKit', 'QuartzCore', 'CoreImage', 'CoreGraphics', 'ImageIO', 'CoreText', 'WebKit'
      sss.dependency 'ZDToolBoxObjC/ZDProxy'
    end
  end

  s.subspec 'ZDSubclass' do |ss|
    ss.source_files = 'ZDToolBoxObjC/Classes/ZDSubclass/*.{h,m}'
    ss.dependency 'ZDToolBoxObjC/ZDProxy'
  end

  s.subspec 'ZDTools' do |ss|
    ss.source_files = 'ZDToolBoxObjC/Classes/ZDTools/*.{h,m}'
    ss.frameworks = 'UIKit'
  end
  
  s.subspec 'ZDHook' do |ss|
    ss.source_files = 'ZDToolBoxObjC/Classes/ZDHook/*.{h,m}'
  end
  
  s.subspec 'All' do |ss|
    ss.source_files = 'ZDToolBoxObjC/Classes/ZDAll/*'
    
    ss.dependency 'ZDToolBoxObjC/ZDHeader'
    ss.dependency 'ZDToolBoxObjC/ZDHook'
  end

  s.subspec 'ZDHeader' do |ss|
    ss.source_files = 'ZDToolBoxObjC/Classes/ZDHeader/*.{h}'
    
    ss.dependency 'ZDToolBoxObjC/ZDCommonTool'
    ss.dependency 'ZDToolBoxObjC/ZDMacros'
    ss.dependency 'ZDToolBoxObjC/ZDProxy'
    ss.dependency 'ZDToolBoxObjC/ZDCategory'
    ss.dependency 'ZDToolBoxObjC/ZDSubclass'
    ss.dependency 'ZDToolBoxObjC/ZDTools'
  end
  
  s.default_subspecs = [
    'ZDCommonTool',
    'ZDMacros',
    'ZDProxy',
    'ZDCategory',
    'ZDSubclass',
    'ZDTools',
    'ZDHeader'
  ]
end
