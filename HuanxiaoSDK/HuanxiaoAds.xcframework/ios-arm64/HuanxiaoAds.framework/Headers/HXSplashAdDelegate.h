//
//  HXSplashAdDelegate.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  开屏广告生命周期代理协议
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HXSplashAd;

/**
 * @protocol HXSplashAdDelegate
 * @brief 开屏广告生命周期代理协议
 *
 * @discussion
 * 通过实现此协议的方法，可以监听开屏广告的各个生命周期事件。
 * 所有代理方法均在主线程回调。
 */
@protocol HXSplashAdDelegate <NSObject>

@optional

#pragma mark - 广告加载

/**
 * @brief 广告加载成功
 *
 * @param splashAd 开屏广告实例
 *
 * @discussion 广告素材加载完成，可以调用 showInWindow: 展示广告
 */
- (void)splashAdDidLoad:(HXSplashAd *)splashAd;

/**
 * @brief 广告加载失败
 *
 * @param splashAd 开屏广告实例
 * @param error 错误信息
 */
- (void)splashAd:(HXSplashAd *)splashAd didFailWithError:(NSError *)error;

#pragma mark - 广告展示

/**
 * @brief 广告即将曝光
 *
 * @param splashAd 开屏广告实例
 *
 * @discussion 广告视图即将添加到窗口
 */
- (void)splashAdWillExpose:(HXSplashAd *)splashAd;

/**
 * @brief 广告曝光成功
 *
 * @param splashAd 开屏广告实例
 *
 * @discussion 广告已成功展示，SDK 会自动上报曝光
 */
- (void)splashAdDidExpose:(HXSplashAd *)splashAd;

/**
 * @brief 广告展示失败
 *
 * @param splashAd 开屏广告实例
 * @param error 错误信息
 */
- (void)splashAd:(HXSplashAd *)splashAd didFailToShowWithError:(NSError *)error;

#pragma mark - 广告交互

/**
 * @brief 广告被点击
 *
 * @param splashAd 开屏广告实例
 *
 * @discussion 用户点击了广告，SDK 会自动处理跳转和上报
 */
- (void)splashAdDidClick:(HXSplashAd *)splashAd;

/**
 * @brief 广告跳过按钮被点击
 *
 * @param splashAd 开屏广告实例
 */
- (void)splashAdDidClickSkip:(HXSplashAd *)splashAd;

#pragma mark - 广告关闭

/**
 * @brief 广告即将关闭
 *
 * @param splashAd 开屏广告实例
 *
 * @discussion 广告视图即将从窗口移除
 */
- (void)splashAdWillClose:(HXSplashAd *)splashAd;

/**
 * @brief 广告已关闭
 *
 * @param splashAd 开屏广告实例
 *
 * @discussion 广告视图已从窗口移除，可以进入主界面
 */
- (void)splashAdDidClose:(HXSplashAd *)splashAd;

@end

NS_ASSUME_NONNULL_END
