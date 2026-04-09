//
//  HXTopOnSplashAdapter.h
//  HuanxiaoAdsTakuAdapterSDK
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  TopOn 开屏广告适配器
//  负责加载和展示 HuanxiaoAds 开屏广告
//

#import "HXTopOnBaseAdapter.h"
#import <AnyThinkSDK/AnyThinkSDK.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class HXTopOnSplashAdapter
 * @brief TopOn 开屏广告适配器
 *
 * @discussion
 * 继承 HXTopOnBaseAdapter，遵循 ATBaseSplashAdapterProtocol 协议。
 * 实现 TopOn 的开屏广告加载和展示接口，内部使用 HuanxiaoAds SDK 的 HXSplashAd。
 *
 * ## TopOn 后台配置
 * 需要在 TopOn 后台配置以下参数：
 * - `slot_id`: HuanxiaoAds 广告位 ID
 *
 * ## 类名配置
 * - 基础适配器类名: `HXTopOnBaseAdapter`
 * - 开屏适配器类名: `HXTopOnSplashAdapter`
 */
@interface HXTopOnSplashAdapter : HXTopOnBaseAdapter <ATBaseSplashAdapterProtocol>

@end


NS_ASSUME_NONNULL_END
