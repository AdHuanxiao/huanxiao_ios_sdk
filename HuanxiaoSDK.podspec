Pod::Spec.new do |spec|
  spec.name             = 'HuanxiaoSDK'
  spec.version          = '1.0.0'
  spec.summary          = 'HuanxiaoSDK for iOS'
  spec.description      = <<-DESC
                          HuanxiaoSDK 是一个广告 SDK，支持开屏广告、插屏广告、激励视频广告和原生广告。
                          DESC
  spec.homepage         = 'https://github.com/AdHuanxiao/huanxiao_ios_sdk'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'HuanxiaoSDK' => 'eddie@adhuanxiao.com' }
  spec.source           = { :git => 'https://github.com/AdHuanxiao/huanxiao_ios_sdk.git', :tag => spec.version.to_s }
  
  spec.ios.deployment_target = '13.0'
  spec.static_framework = true
  
  # 默认只安装基础SDK
  spec.default_subspecs = 'Core'
  

  spec.subspec 'Core' do |ss|
    ss.ios.deployment_target = '13.0'
    ss.vendored_frameworks = 'HuanxiaoSDK/HuanxiaoAds.xcframework'
  end
  

  spec.subspec 'TakuAdapter' do |ss|
    ss.ios.deployment_target = '13.0'
    ss.vendored_frameworks = 'HuanxiaoSDK/HuanxiaoAdsTakuAdapterSDK.xcframework'
    ss.dependency 'HuanxiaoSDK/Core'
    ss.dependency 'AnyThinkiOS'
    ss.dependency 'AnyThinkMediationAdxSmartdigimktCNAdapter'
  end
  
end
