//
//  HXNativeAdDelegate.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  信息流广告生命周期代理协议
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HXNativeAd;

/**
 * @protocol HXNativeAdDelegate
 * @brief 信息流广告生命周期代理协议
 *
 * @discussion
 * 通过实现此协议的方法，可以监听信息流广告的各个生命周期事件。
 * 所有代理方法均在主线程回调。
 */
@protocol HXNativeAdDelegate <NSObject>

@optional

#pragma mark - 广告加载

/**
 * @brief 广告加载成功
 *
 * @param nativeAd 信息流广告实例
 *
 * @discussion
 * 广告素材加载完成，可以获取 adView 并添加到容器中展示。
 * SDK 已根据 adTemp 模板渲染好广告视图。
 */
- (void)nativeAdDidLoad:(HXNativeAd *)nativeAd;

/**
 * @brief 广告加载失败
 *
 * @param nativeAd 信息流广告实例
 * @param error 错误信息
 */
- (void)nativeAd:(HXNativeAd *)nativeAd didFailWithError:(NSError *)error;

#pragma mark - 广告展示

/**
 * @brief 广告曝光成功
 *
 * @param nativeAd 信息流广告实例
 *
 * @discussion
 * 广告视图可见面积超过 50% 且持续 1 秒后触发。
 * SDK 会自动上报曝光。
 */
- (void)nativeAdDidExpose:(HXNativeAd *)nativeAd;

#pragma mark - 广告交互

/**
 * @brief 广告被点击
 *
 * @param nativeAd 信息流广告实例
 *
 * @discussion 用户点击了广告，SDK 会自动处理跳转和上报
 */
- (void)nativeAdDidClick:(HXNativeAd *)nativeAd;

/**
 * @brief 关闭按钮被点击
 *
 * @param nativeAd 信息流广告实例
 *
 * @discussion 用户点击了关闭按钮，开发者应移除广告视图
 */
- (void)nativeAdDidClose:(HXNativeAd *)nativeAd;

#pragma mark - 尺寸计算

/**
 * @brief 推荐高度
 *
 * @param nativeAd 信息流广告实例
 * @param recommendedHeight 推荐的广告高度
 *
 * @discussion
 * 当初始化时传入的 size.height == 0 时，SDK 会根据模板类型自动计算推荐高度：
 * 开发者收到此回调后，应更新广告容器的高度约束。
 */
- (void)nativeAd:(HXNativeAd *)nativeAd didCalculateRecommendedHeight:(CGFloat)recommendedHeight;

@end

NS_ASSUME_NONNULL_END

