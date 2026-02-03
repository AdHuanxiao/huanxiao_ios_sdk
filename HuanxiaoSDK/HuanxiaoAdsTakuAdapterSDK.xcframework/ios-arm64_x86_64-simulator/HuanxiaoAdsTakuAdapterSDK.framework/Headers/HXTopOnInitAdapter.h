//
//  HXTopOnInitAdapter.h
//  HuanxiaoAdsTakuAdapterSDK
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  TopOn 初始化适配器
//  负责初始化 HuanxiaoAds SDK，并返回版本号信息
//

#import <AnyThinkSDK/AnyThinkSDK.h>


NS_ASSUME_NONNULL_BEGIN

/**
 * @class HXTopOnInitAdapter
 * @brief TopOn 初始化适配器
 *
 * @discussion
 * 继承自 ATBaseInitAdapter，负责初始化 HuanxiaoAds SDK。
 * 在 TopOn 加载广告前会先调用此适配器进行 SDK 初始化。
 */
@interface HXTopOnInitAdapter : ATBaseInitAdapter

@end

NS_ASSUME_NONNULL_END
