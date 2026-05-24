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

#pragma mark - 交互检测控制（聚合 Adapter 使用）

/**
 * @brief 永久停止当前广告的摇/扭运动检测
 *
 * @discussion
 * 自渲染模式下，HXNativeAd 自带的 HXNativeAdVisibilityManager 会按"屏中心"自动调度
 * 运动检测；该方法用于聚合渠道（如 ToBid）的 destoryShakeView 等生命周期钩子，主动
 * 停止运动检测并阻止 visibility manager 后续再次激活，避免 ToBid 已要求销毁摇一摇
 * 后用户摇手机仍向 mediator 上报 click。调用后该实例不再触发摇/扭交互。
 */
- (void)stopMotionDetection;

@end

NS_ASSUME_NONNULL_END
