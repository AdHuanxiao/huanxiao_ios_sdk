//
//  HXSplashAd.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  开屏广告
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HuanxiaoAds/HXSplashAdDelegate.h>

NS_ASSUME_NONNULL_BEGIN


@interface HXSplashAd : NSObject

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
@property (nonatomic, weak, nullable) id<HXSplashAdDelegate> delegate;

/**
 * @brief 广告是否有效
 * @discussion 加载成功且未过期时返回 YES
 */
@property (nonatomic, assign, readonly, getter=isAdValid) BOOL adValid;

/**
 * @brief 广告是否正在加载
 */
@property (nonatomic, assign, readonly, getter=isLoading) BOOL loading;

#pragma mark - 配置

/**
 * @brief 底部自定义视图
 * @discussion 可设置 App Logo 等，在广告底部显示
 */
@property (nonatomic, strong, nullable) UIView *bottomView;

/**
 * @brief 底部视图高度
 * @discussion 当设置 bottomView 时需要指定高度
 * @default 100
 */
@property (nonatomic, assign) CGFloat bottomViewHeight;

#pragma mark - 初始化

/**
 * @brief 初始化开屏广告
 *
 * @param adSpotID 广告位 ID（必填）
 *
 * @return 开屏广告实例，adSpotID 为空时返回 nil
 */
- (nullable instancetype)initWithAdSpotID:(NSString *)adSpotID;

/// 禁用默认初始化
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - 广告操作

/**
 * @brief 加载并自动展示广告 - Window 模式（推荐）
 *
 * @param window 展示广告的窗口（通常为 keyWindow）
 *
 * @discussion
 * 自动完成「加载 → 展示」流程：
 * - 加载成功后自动在指定窗口展示广告
 * - 加载失败回调 splashAd:didFailWithError:
 * - 展示成功回调 splashAdDidExpose:
 * - 广告关闭回调 splashAdDidClose:
 *
 * @note 这是最简单的使用方式，无需在代理中手动调用展示
 */
- (void)loadAndShowInWindow:(UIWindow *)window;

/**
 * @brief 加载并自动展示广告 - ViewController 模式
 *
 * @param viewController 展示广告的视图控制器
 *
 * @discussion
 * 自动完成「加载 → 展示」流程：
 * - 加载成功后自动以全屏模式展示在指定 ViewController 上
 * - 加载失败回调 splashAd:didFailWithError:
 * - 展示成功回调 splashAdDidExpose:
 * - 广告关闭回调 splashAdDidClose:
 *
 * @note 适用于需要在特定 ViewController 上展示开屏广告的场景
 */
- (void)loadAndShowFromViewController:(UIViewController *)viewController;

/**
 * @brief 加载广告（手动模式）
 *
 * @discussion
 * 仅加载广告素材，不自动展示。
 * 需要在 splashAdDidLoad: 回调中手动调用 showInWindow: 或 showFromViewController: 展示。
 *
 * @note 如需自动展示，请使用 loadAndShowInWindow: 或 loadAndShowFromViewController: 方法
 */
- (void)loadAd;

/**
 * @brief 在指定窗口展示广告（手动模式）
 *
 * @param window 展示广告的窗口
 *
 * @discussion
 * 配合 loadAd 使用，在 splashAdDidLoad: 回调中调用。
 *
 * @note 如需自动展示，请使用 loadAndShowInWindow: 方法
 */
- (void)showInWindow:(UIWindow *)window;

/**
 * @brief 在指定视图控制器上展示广告（手动模式）
 *
 * @param viewController 展示广告的视图控制器
 *
 * @discussion
 * 配合 loadAd 使用，在 splashAdDidLoad: 回调中调用。
 * 广告会以全屏模式展示在 viewController 之上。
 *
 * @note 如需自动展示，请使用 loadAndShowFromViewController: 方法
 */
- (void)showFromViewController:(UIViewController *)viewController;

/**
 * @brief 关闭广告
 *
 * @discussion
 * 主动关闭广告，会触发 splashAdWillClose: 和 splashAdDidClose: 回调
 */
- (void)close;

@end

NS_ASSUME_NONNULL_END
