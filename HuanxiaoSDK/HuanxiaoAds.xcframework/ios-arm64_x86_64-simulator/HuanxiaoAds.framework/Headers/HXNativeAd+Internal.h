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

/**
 * @brief 软解绑：暂时停用摇/扭/滑交互，等待宿主端再次 bindWithContainer 复活
 *
 * @discussion
 * 用于聚合渠道（如 ToBid）的 viewCreator unregisterDataObject 钩子。
 * 该钩子的真实语义是"宿主端解绑当前 view"，不是"销毁广告"，而瀑布流/列表里
 * cell 复用、下拉刷新都会触发它。如果直接 close，会导致同一个 mediatedAd 之后
 * 再次 bindWithContainer 时已经"死"了，摇一摇 / 动画无法恢复。
 *
 * 本方法做"软解绑"：
 *  1. 从 HXNativeAdVisibilityManager 注销，立刻退出屏中心选举（防幽灵广告误响应）
 *  2. 停止 customMotionDetector / 交互动画 / 视频（释放 CPU 与传感器）
 *  3. 设置内部 isHostDetached 标记，hasHigherPriorityPause 兜底返回 YES
 *  4. 不 close、不释放 renderData / customContainer，保留可复活能力
 *
 * 之后业务方（或 ToBid）再次调用 bindWithContainer:clickableViews: 时，会
 * 自动清掉 isHostDetached 并重新接入 visibility manager；如果一直不再 bind，
 * 等到 adapter dealloc / destory 时由调用方主动 close，本实例随之销毁。
 *
 * 仅自渲染模式生效；模板渲染模式由 HXNativeAdView 自身的 willMoveToWindow
 * 链路维护，不需要调用此方法。重复调用安全（idempotent）。
 */
- (void)suspendFromHost;

@end

NS_ASSUME_NONNULL_END
