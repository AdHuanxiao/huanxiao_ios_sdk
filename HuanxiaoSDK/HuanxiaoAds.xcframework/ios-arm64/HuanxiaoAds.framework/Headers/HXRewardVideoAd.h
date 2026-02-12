//
//  HXRewardVideoAd.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  激励视频广告
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HuanxiaoAds/HXRewardVideoAdDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXRewardVideoAd : NSObject

#pragma mark - 属性

/**
 * @brief 广告位 ID
 * @discussion 在 HuanxiaoAds 开发者后台创建广告位后获取
 */
@property (nonatomic, copy, readonly) NSString *adSpotID;

/**
 * @brief 代理对象
 * @discussion 用于接收广告生命周期回调
 */
@property (nonatomic, weak, nullable) id<HXRewardVideoAdDelegate> delegate;

/**
 * @brief 广告是否有效
 * @discussion 加载成功且未过期时返回 YES
 */
@property (nonatomic, assign, readonly, getter=isAdValid) BOOL adValid;

/**
 * @brief 广告是否正在加载
 */
@property (nonatomic, assign, readonly, getter=isLoading) BOOL loading;

#pragma mark - 初始化

/**
 * @brief 初始化激励视频广告
 *
 * @param adSpotID 广告位 ID（必填）
 *
 * @return 激励视频广告实例，adSpotID 为空时返回 nil
 */
- (nullable instancetype)initWithAdSpotID:(NSString *)adSpotID;

/// 禁用默认初始化
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - 视频控制

/**
 * @brief 视频是否静音播放
 *
 * @discussion
 * 设置视频广告的静音状态。
 * 可在 loadAd 之前设置，广告加载后也可动态修改。
 *
 * @default NO（默认有声播放）
 */
@property (nonatomic, assign) BOOL videoMuted;

#pragma mark - 广告操作

/**
 * @brief 加载广告
 *
 * @discussion
 * 加载广告素材（包括视频下载）。
 * 加载成功后回调 rewardVideoAdDidLoad:，可以展示广告。
 *
 * @note 建议在用户可能需要观看广告前提前加载
 */
- (void)loadAd;

/**
 * @brief 从指定视图控制器展示广告
 *
 * @param viewController 用于展示广告的视图控制器
 *
 * @discussion
 * 在 rewardVideoAdDidLoad: 回调后调用。
 * 广告会以全屏方式展示在 viewController 之上。
 *
 * @note
 * - 展示前请检查 isAdValid 确保广告有效
 * - 展示广告时建议暂停应用音频
 */
- (void)showFromViewController:(UIViewController *)viewController;

/**
 * @brief 关闭广告
 *
 * @discussion
 * 主动关闭广告，会触发相关回调。
 * 通常不需要调用此方法，用户会通过关闭按钮关闭广告。
 *
 * @warning 主动关闭可能导致用户无法获得奖励
 */
- (void)close;

@end

NS_ASSUME_NONNULL_END
