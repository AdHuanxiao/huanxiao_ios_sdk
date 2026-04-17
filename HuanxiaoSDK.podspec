Pod::Spec.new do |spec|
  spec.name             = 'HuanxiaoSDK'
  spec.version          = '1.5.2'
  spec.summary          = 'HuanxiaoSDK for iOS'
  spec.description      = <<-DESC
                          HuanxiaoSDK
                          DESC
  spec.homepage         = 'https://github.com/AdHuanxiao/huanxiao_ios_sdk'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'HuanxiaoSDK' => 'eddie@adhuanxiao.com' }
  spec.source           = { :git => 'https://github.com/AdHuanxiao/huanxiao_ios_sdk.git', :tag => spec.version.to_s }
  
  spec.ios.deployment_target = '13.0'
  spec.static_framework = true
  
  spec.resources = [
    'HuanxiaoSDK/Resources/HXAdsImages.bundle'
  ]
  # 默认只安装基础SDK
  spec.default_subspecs = 'Core'
  

  spec.subspec 'Core' do |ss|
    ss.ios.deployment_target = '13.0'
    ss.vendored_frameworks = 'HuanxiaoSDK/HuanxiaoAds.xcframework'
  end
  

  spec.subspec 'TakuAdapterSDK' do |ss|
    ss.ios.deployment_target = '13.0'
    ss.vendored_frameworks = 'HuanxiaoSDK/HuanxiaoAdsTakuAdapterSDK.xcframework'
    ss.dependency 'HuanxiaoSDK/Core'
    ss.dependency 'AnyThinkiOS'
    ss.dependency 'AnyThinkMediationAdxSmartdigimktCNAdapter'
  end
  
  spec.subspec 'GromoreAdapterSDK' do |ss|
    ss.ios.deployment_target = '13.0'
    ss.vendored_frameworks = 'HuanxiaoSDK/HuanxiaoAdsCSJAdapterSDK.xcframework'
    ss.dependency 'HuanxiaoSDK/Core'
    ss.dependency 'Ads-CN-Beta/BUAdSDK'
    ss.dependency 'Ads-CN-Beta/CSJMediation'
    
  end
  
  spec.subspec 'AwmAdapterSDK' do |ss|
    ss.ios.deployment_target = '13.0'
    ss.vendored_frameworks = 'HuanxiaoSDK/HuanxiaoAdsAwmAdapterSDK.xcframework'
    ss.dependency 'HuanxiaoSDK/Core'
    ss.dependency 'ToBid-iOS'
  end
  
  spec.subspec 'HemuAdapterSDK' do |ss|
    ss.ios.deployment_target = '13.0'
    ss.vendored_frameworks = 'HuanxiaoSDK/HuanxiaoAdsAwmAdapterSDK.xcframework'
    ss.dependency 'HuanxiaoSDK/Core'
    ss.dependency 'MediatomiOS'
  end
end
