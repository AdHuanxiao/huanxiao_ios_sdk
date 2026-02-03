//
//  HXNativeAd+Internal.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  ⚠️ 内部使用 - 请勿在媒体接入代码中使用
//  仅供 SDK 内部和 Adapter 使用
//

#import <HuanxiaoAds/HXNativeAd.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @brief 信息流广告内部接口
 * @discussion 提供竞价信息等内部属性，仅供 SDK 内部和 Adapter 使用
 */
@interface HXNativeAd (Internal)

#pragma mark - 竞价信息（Bidding）

/**
 * @brief 广告 eCPM（单位：分/CPM）
 * @discussion 加载成功后有效，用于聚合平台竞价排序
 * @note 返回 0 表示未获取到价格信息
 */
@property (nonatomic, assign, readonly) NSUInteger ecpm;

/**
 * @brief 广告过期时间
 * @discussion 超过此时间广告无效，需重新加载
 * @note 加载成功后有效，加载前返回 nil
 */
@property (nonatomic, strong, readonly, nullable) NSDate *expireTime;

#pragma mark - 配置

/**
 * @brief 加载超时时间（秒）
 * @discussion 超过此时间未加载成功则回调失败
 * @default 5.0
 */
@property (nonatomic, assign) NSTimeInterval tolerateTimeout;

@end

NS_ASSUME_NONNULL_END
