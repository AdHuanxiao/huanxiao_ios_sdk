//
//  HXTopOnBaseAdapter.h
//  HuanxiaoAdsTakuAdapterSDK
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  TopOn 基础适配器
//  指定初始化适配器类名，TopOn 会根据此类名找到初始化适配器
//

#import <AnyThinkSDK/AnyThinkSDK.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class HXTopOnBaseAdapter
 * @brief TopOn 基础适配器
 *
 * @discussion
 * 继承自 ATBaseMediationAdapter，主要作用是指定初始化适配器类名。
 * TopOn 会通过 initializeClassName 方法获取初始化适配器类，
 * 然后调用初始化适配器来初始化 HuanxiaoAds SDK。
 *
 * @note 类名需要在 TopOn 后台配置
 */
@interface HXTopOnBaseAdapter : ATBaseMediationAdapter

@end

NS_ASSUME_NONNULL_END
