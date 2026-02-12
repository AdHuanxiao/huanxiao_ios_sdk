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
#import <HuanxiaoAds/HXNativeAdRenderData.h>
#import <HuanxiaoAds/HXNativeAdCustomViews.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 渲染模式枚举

/**
 * @brief 信息流广告渲染模式
 */
typedef NS_ENUM(NSInteger, HXNativeAdRenderMode) {
    /// 模板渲染（SDK 渲染 UI，默认）
    /// 使用 adView 获取 SDK 渲染好的广告视图
    HXNativeAdRenderModeTemplate = 0,
    
    /// 自渲染（媒体渲染 UI）
    /// 使用 renderData 获取数据，自行创建视图后调用 bindCustomViews:container:rootViewController:
    HXNativeAdRenderModeCustom = 1,
};

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

/**
 * @brief 渲染模式
 *
 * @discussion
 * 必须在调用 loadAd 之前设置。
 * - HXNativeAdRenderModeTemplate（默认）：SDK 渲染 UI，通过 adView 获取
 * - HXNativeAdRenderModeCustom：媒体自渲染，通过 renderData 获取数据
 *
 * @default HXNativeAdRenderModeTemplate
 */
@property (nonatomic, assign) HXNativeAdRenderMode renderMode;

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
 * 调用后应从容器中移除 adView（模板渲染）或自定义视图（自渲染）。
 */
- (void)close;

#pragma mark - 自渲染模式

/**
 * @brief 自渲染数据（仅自渲染模式有效）
 *
 * @discussion
 * 加载成功后可获取此数据用于自渲染 UI。
 * 仅当 renderMode == HXNativeAdRenderModeCustom 时有值。
 * 模板渲染模式下返回 nil。
 *
 * 数据包含：
 * - 文本信息（标题、描述、按钮文案）
 * - 已加载的图片（mainImage、iconImage）
 * - 交互类型和提示
 * - 视频信息（如果是视频广告）
 *
 */
@property (nonatomic, strong, readonly, nullable) HXNativeAdRenderData *renderData;

/**
 * @brief 绑定自定义视图并注册（仅自渲染模式）
 *
 * @param customViews 媒体创建的视图绑定配置
 * @param container 广告容器视图
 * @param viewController 当前视图控制器
 *
 * @discussion
 * 自渲染模式下，媒体使用 renderData 数据自行创建视图后，
 * 调用此方法将视图绑定给 SDK。
 *
 * SDK 会执行以下操作：
 * 1. 在 videoContainerView 内添加视频播放层（视频广告）
 * 2. 注册曝光检测（监听 container 可见性）
 * 3. 注册交互检测（摇一摇/扭一扭）
 * 4. 添加点击手势到 clickableView 或 container
 * 5. 检测广告标识是否正确展示（合规）
 *
 * @note 必须在 loadAd 成功后、展示广告前调用
 * @note 仅自渲染模式有效，模板渲染模式调用无效果
 */
- (void)bindCustomViews:(HXNativeAdCustomViews *)customViews
              container:(UIView *)container
     rootViewController:(UIViewController *)viewController;

/**
 * @brief 手动触发曝光上报（仅自渲染模式）
 *
 * @discussion
 * 通常不需要调用，SDK 会自动检测曝光。
 * 仅在特殊布局（如复杂 ScrollView 嵌套）导致自动检测失效时使用。
 *
 * 调用条件：
 * - 广告视图可见面积 >= 50%
 * - 持续可见时间 >= 1 秒
 *
 * @note 重复调用会被忽略（只上报一次）
 */
- (void)reportExposureManually;

#pragma mark - 视频控制（仅视频广告有效）

/**
 * @brief 视频是否静音播放
 *
 * @discussion
 * 设置视频广告的静音状态。
 * 可在 loadAd 之前设置，广告加载后也可动态修改。
 *
 * @default YES（默认静音播放）
 */
@property (nonatomic, assign) BOOL videoMuted;

/**
 * @brief 暂停视频播放
 *
 * @discussion 仅对视频广告有效，图片广告调用无效果
 */
- (void)pauseVideo;

/**
 * @brief 恢复视频播放
 *
 * @discussion 仅对视频广告有效，图片广告调用无效果
 */
- (void)resumeVideo;

@end

NS_ASSUME_NONNULL_END

