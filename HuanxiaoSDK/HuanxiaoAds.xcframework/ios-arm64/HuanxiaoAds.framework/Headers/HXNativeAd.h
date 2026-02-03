//
//  HXNativeAd.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  信息流广告
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <HuanxiaoAds/HXNativeAdDelegate.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXNativeAd : NSObject

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
@property (nonatomic, weak, nullable) id<HXNativeAdDelegate> delegate;

/**
 * @brief 广告是否有效
 * @discussion 加载成功且未过期时返回 YES
 */
@property (nonatomic, assign, readonly, getter=isAdValid) BOOL adValid;

/**
 * @brief 广告是否正在加载
 */
@property (nonatomic, assign, readonly, getter=isLoading) BOOL loading;

/**
 * @brief 广告视图尺寸
 * @discussion 初始化时传入的尺寸
 */
@property (nonatomic, assign, readonly) CGSize adSize;

#pragma mark - 初始化

/**
 * @brief 初始化信息流广告
 *
 * @param adSpotID 广告位 ID（必填）
 * @param size 广告视图尺寸（必填）
 *
 * @return 信息流广告实例，adSpotID 为空时返回 nil
 *
 * @discussion
 * size 参数决定了广告视图的渲染尺寸，SDK 会根据此尺寸适配广告内容。
 * 建议根据容器的实际尺寸传入。
 */
- (nullable instancetype)initWithAdSpotID:(NSString *)adSpotID
                                     size:(CGSize)size;

/// 禁用默认初始化
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - 广告操作

/**
 * @brief 加载广告
 *
 * @discussion
 * 加载广告素材，加载成功后：
 * - 回调 nativeAdDidLoad:
 * - 可通过 adView 属性获取 SDK 渲染好的广告视图
 */
- (void)loadAd;

/**
 * @brief 获取广告视图（加载成功后有效）
 *
 * @discussion
 * SDK 根据 adTemp 模板自动渲染好的广告视图。
 * 开发者将此视图添加到自己的容器中即可。
 *
 * @note 加载成功前返回 nil
 */
@property (nonatomic, strong, readonly, nullable) UIView *adView;

/**
 * @brief 关闭广告
 *
 * @discussion
 * 主动关闭广告，会触发 nativeAdDidClose: 回调。
 * 调用后应从容器中移除 adView。
 */
- (void)close;

@end

NS_ASSUME_NONNULL_END

