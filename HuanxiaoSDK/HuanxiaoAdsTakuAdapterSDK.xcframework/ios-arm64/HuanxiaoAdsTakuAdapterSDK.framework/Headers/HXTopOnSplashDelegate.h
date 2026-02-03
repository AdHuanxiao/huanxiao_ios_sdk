//
//  HXTopOnSplashDelegate.h
//  HuanxiaoAdsTakuAdapterSDK
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  TopOn 开屏广告代理
//  负责将 HuanxiaoAds 的回调转换为 TopOn 的回调
//

#import <AnyThinkSDK/AnyThinkSDK.h>
#import <HuanxiaoAds/HuanxiaoAds.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class HXTopOnSplashDelegate
 * @brief TopOn 开屏广告代理
 *
 * @discussion
 * 实现 HXSplashAdDelegate 协议，将 HuanxiaoAds 的回调转换为 TopOn 的回调格式。
 */
@interface HXTopOnSplashDelegate : NSObject <HXSplashAdDelegate>

/// TopOn 开屏广告状态桥接器
@property (nonatomic, strong) ATSplashAdStatusBridge *adStatusBridge;

@end

NS_ASSUME_NONNULL_END
