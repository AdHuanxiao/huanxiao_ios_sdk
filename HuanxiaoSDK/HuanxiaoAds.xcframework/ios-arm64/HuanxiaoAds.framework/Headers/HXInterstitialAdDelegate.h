//
//  HXInterstitialAdDelegate.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  插屏广告生命周期代理协议
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HXInterstitialAd;

/**
 * @protocol HXInterstitialAdDelegate
 * @brief 插屏广告生命周期代理协议
 *
 * @discussion
 * 通过实现此协议的方法，可以监听插屏广告的各个生命周期事件。
 * 所有代理方法均在主线程回调。
 */
@protocol HXInterstitialAdDelegate <NSObject>

@optional

#pragma mark - 广告加载

/**
 * @brief 广告加载成功
 *
 * @param interstitialAd 插屏广告实例
 *
 * @discussion 广告素材加载完成，可以调用 showFromViewController: 展示广告
 */
- (void)interstitialAdDidLoad:(HXInterstitialAd *)interstitialAd;

/**
 * @brief 广告加载失败
 *
 * @param interstitialAd 插屏广告实例
 * @param error 错误信息
 */
- (void)interstitialAd:(HXInterstitialAd *)interstitialAd didFailWithError:(NSError *)error;

#pragma mark - 广告展示

/**
 * @brief 广告即将曝光
 *
 * @param interstitialAd 插屏广告实例
 *
 * @discussion 广告视图即将展示
 */
- (void)interstitialAdWillExpose:(HXInterstitialAd *)interstitialAd;

/**
 * @brief 广告曝光成功
 *
 * @param interstitialAd 插屏广告实例
 *
 * @discussion 广告已成功展示，SDK 会自动上报曝光
 */
- (void)interstitialAdDidExpose:(HXInterstitialAd *)interstitialAd;

/**
 * @brief 广告展示失败
 *
 * @param interstitialAd 插屏广告实例
 * @param error 错误信息
 */
- (void)interstitialAd:(HXInterstitialAd *)interstitialAd didFailToShowWithError:(NSError *)error;

#pragma mark - 广告交互

/**
 * @brief 广告被点击
 *
 * @param interstitialAd 插屏广告实例
 *
 * @discussion 用户点击了广告，SDK 会自动处理跳转和上报
 */
- (void)interstitialAdDidClick:(HXInterstitialAd *)interstitialAd;

/**
 * @brief 关闭按钮被点击
 *
 * @param interstitialAd 插屏广告实例
 */
- (void)interstitialAdDidClickClose:(HXInterstitialAd *)interstitialAd;

#pragma mark - 广告关闭

/**
 * @brief 广告即将关闭
 *
 * @param interstitialAd 插屏广告实例
 *
 * @discussion 广告视图即将从窗口移除
 */
- (void)interstitialAdWillClose:(HXInterstitialAd *)interstitialAd;

/**
 * @brief 广告已关闭
 *
 * @param interstitialAd 插屏广告实例
 *
 * @discussion 广告视图已从窗口移除
 */
- (void)interstitialAdDidClose:(HXInterstitialAd *)interstitialAd;

@end

NS_ASSUME_NONNULL_END

