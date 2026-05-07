//
//  HXRewardVideoAdDelegate.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  激励视频广告生命周期代理协议
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HXRewardVideoAd;

/**
 * @protocol HXRewardVideoAdDelegate
 * @brief 激励视频广告生命周期代理协议
 *
 * @discussion
 * 通过实现此协议的方法，可以监听激励视频广告的各个生命周期事件。
 * 所有代理方法均在主线程回调。
 *
 * @note
 * - 必须实现 rewardVideoAdDidReward: 方法来处理奖励发放
 * - 建议实现 rewardVideoAdDidClose: 方法，在广告关闭后恢复应用音频等
 */
@protocol HXRewardVideoAdDelegate <NSObject>

@optional

#pragma mark - 广告加载

/**
 * @brief 广告加载成功
 *
 * @param rewardVideoAd 激励视频广告实例
 *
 * @discussion
 * 广告素材加载完成，可以调用 showFromViewController: 展示广告。
 * 建议提前预加载，在用户需要时展示。
 */
- (void)rewardVideoAdDidLoad:(HXRewardVideoAd *)rewardVideoAd;

/**
 * @brief 广告加载失败
 *
 * @param rewardVideoAd 激励视频广告实例
 * @param error 错误信息
 */
- (void)rewardVideoAd:(HXRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error;

#pragma mark - 广告展示

/**
 * @brief 广告即将曝光
 *
 * @param rewardVideoAd 激励视频广告实例
 *
 * @discussion 广告视图即将展示，建议在此暂停应用音频
 */
- (void)rewardVideoAdWillExpose:(HXRewardVideoAd *)rewardVideoAd;

/**
 * @brief 广告曝光成功
 *
 * @param rewardVideoAd 激励视频广告实例
 *
 * @discussion 广告已成功展示，SDK 会自动上报曝光
 */
- (void)rewardVideoAdDidExpose:(HXRewardVideoAd *)rewardVideoAd;

/**
 * @brief 广告展示失败
 *
 * @param rewardVideoAd 激励视频广告实例
 * @param error 错误信息
 */
- (void)rewardVideoAd:(HXRewardVideoAd *)rewardVideoAd didFailToShowWithError:(NSError *)error;

#pragma mark - 视频播放

/**
 * @brief 视频开始播放
 *
 * @param rewardVideoAd 激励视频广告实例
 */
- (void)rewardVideoAdDidStartPlay:(HXRewardVideoAd *)rewardVideoAd;

/**
 * @brief 视频播放进度更新
 *
 * @param rewardVideoAd 激励视频广告实例
 * @param progress 播放进度（0.0 - 1.0）
 * @param currentTime 当前播放时间（秒）
 * @param totalTime 视频总时长（秒）
 */
- (void)rewardVideoAd:(HXRewardVideoAd *)rewardVideoAd
       playProgress:(CGFloat)progress
        currentTime:(NSTimeInterval)currentTime
          totalTime:(NSTimeInterval)totalTime;

/**
 * @brief 视频播放完成
 *
 * @param rewardVideoAd 激励视频广告实例
 *
 * @discussion 视频播放结束，即将展示结束页面
 */
- (void)rewardVideoAdDidPlayFinish:(HXRewardVideoAd *)rewardVideoAd;

/**
 * @brief 视频播放失败
 *
 * @param rewardVideoAd 激励视频广告实例
 * @param error 错误信息
 */
- (void)rewardVideoAd:(HXRewardVideoAd *)rewardVideoAd didPlayFailWithError:(NSError *)error;

#pragma mark - 奖励发放

/**
 * @brief 用户获得奖励
 *
 * @param rewardVideoAd 激励视频广告实例
 *
 * @discussion
 * 当用户完整观看视频（达到最小观看时长）后触发此回调。
 * 开发者需要在此回调中给用户发放奖励。
 *
 * @note
 * - 此回调可能在视频播放完成前触发（当达到最小观看时长时）
 * - 建议使用服务端回调进行二次验证
 */
- (void)rewardVideoAdDidReward:(HXRewardVideoAd *)rewardVideoAd;

#pragma mark - 广告交互

/**
 * @brief 广告被点击
 *
 * @param rewardVideoAd 激励视频广告实例
 *
 * @discussion 用户点击了广告，SDK 会自动处理跳转和上报
 */
- (void)rewardVideoAdDidClick:(HXRewardVideoAd *)rewardVideoAd;

/**
 * @brief 跳过按钮被点击
 *
 * @param rewardVideoAd 激励视频广告实例
 *
 * @discussion 用户点击了跳过按钮（仅在达到可跳过时间后可用）
 */
- (void)rewardVideoAdDidClickSkip:(HXRewardVideoAd *)rewardVideoAd;

#pragma mark - 广告关闭

/**
 * @brief 广告即将关闭
 *
 * @param rewardVideoAd 激励视频广告实例
 *
 * @discussion 广告视图即将从窗口移除
 */
- (void)rewardVideoAdWillClose:(HXRewardVideoAd *)rewardVideoAd;

/**
 * @brief 广告已关闭
 *
 * @param rewardVideoAd 激励视频广告实例
 *
 * @discussion
 * 广告视图已从窗口移除，可以恢复应用音频等。
 * 注意：此时奖励回调可能已经触发，也可能未触发（用户提前跳过）。
 */
- (void)rewardVideoAdDidClose:(HXRewardVideoAd *)rewardVideoAd;

@end

NS_ASSUME_NONNULL_END
