//
//  HXInterstitialAd.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  插屏广告
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HuanxiaoAds/HXInterstitialAdDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXInterstitialAd : NSObject

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
@property (nonatomic, weak, nullable) id<HXInterstitialAdDelegate> delegate;

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
 * @brief 初始化插屏广告
 *
 * @param adSpotID 广告位 ID（必填）
 *
 * @return 插屏广告实例，adSpotID 为空时返回 nil
 */
- (nullable instancetype)initWithAdSpotID:(NSString *)adSpotID;

/// 禁用默认初始化
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - 广告操作

/**
 * @brief 加载广告
 *
 * @discussion
 * 加载广告素材，加载成功后回调 interstitialAdDidLoad:
 * 建议提前加载，在合适的时机展示
 */
- (void)loadAd;

/**
 * @brief 从指定视图控制器展示广告
 *
 * @param viewController 用于展示广告的视图控制器
 *
 * @discussion
 * 在 interstitialAdDidLoad: 回调后调用
 * 广告会以模态方式展示在 viewController 之上
 */
- (void)showFromViewController:(UIViewController *)viewController;

/**
 * @brief 关闭广告
 *
 * @discussion
 * 主动关闭广告，会触发 interstitialAdWillClose: 和 interstitialAdDidClose: 回调
 */
- (void)close;

@end

NS_ASSUME_NONNULL_END

