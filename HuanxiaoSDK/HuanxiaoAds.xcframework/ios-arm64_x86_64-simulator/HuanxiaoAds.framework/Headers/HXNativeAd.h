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
#import <HuanxiaoAds/HXMediaView.h>
#import <HuanxiaoAds/HXBidNotifiable.h>

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
    /// 使用 renderData 获取数据，自行创建视图后调用 renderData 的绑定方法
    HXNativeAdRenderModeCustom = 1,
};

/**
 * @brief 自渲染信息流的视频渲染方式
 *
 * @discussion 仅 renderMode = HXNativeAdRenderModeCustom 时有效
 */
typedef NS_ENUM(NSInteger, HXNativeVideoRenderMode) {
    /// SDK 提供播放视图（默认），取 renderData.mediaView 使用
    HXNativeVideoRenderModeSDK = 0,
    
    /// 开发者自行提供播放器，renderData.mediaView 为 nil，
    /// 视频素材见 renderData 的 videoUrl / videoCoverUrl / videoDuration / videoSize
    HXNativeVideoRenderModeCustom = 1,
};

@class HXNativeAd;

#pragma mark - 自定义视频

/**
 * @brief 自定义视频播放器的控制回调
 *
 * @discussion
 * 仅 videoRenderMode = HXNativeVideoRenderModeCustom 时使用。
 * 广告滑出屏幕、App 切后台、用户点击跳转等场景下 SDK 会回调暂停/恢复，
 * 请在回调里操作自己的播放器。回调均在主线程。
 */
@protocol HXNativeAdCustomVideoDelegate <NSObject>

@required

/// 恢复播放（广告重新可见、App 回前台、跳转页关闭等）
- (void)nativeAdRequestResumeVideo:(HXNativeAd *)nativeAd;

/// 暂停播放（广告不可见、App 进后台、用户跳转等）
- (void)nativeAdRequestPauseVideo:(HXNativeAd *)nativeAd;

@optional

/// 设置静音，nativeAd.videoMuted 变化时回调。
/// enableDefaultAudioSessionSetting 为 YES 时，取消静音前 SDK 会先配置 AVAudioSession，媒体只需同步 player.muted。
- (void)nativeAd:(HXNativeAd *)nativeAd requestMuteVideo:(BOOL)muted;

/// 停止播放并释放资源，广告 close 时回调，之后不会再有恢复回调
- (void)nativeAdRequestStopVideo:(HXNativeAd *)nativeAd;

@end

@interface HXNativeAd : NSObject <HXBidNotifiable>

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
 * @brief 广告 eCPM（单位：分/CPM）
 * @discussion 加载成功后有效，返回 0 表示未获取到价格信息
 */
@property (nonatomic, assign, readonly) NSUInteger ecpm;

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

/**
 * @brief 视频渲染方式（仅自渲染模式有效）
 *
 * @discussion
 * loadAd 前设置。默认 HXNativeVideoRenderModeSDK，取 renderData.mediaView 即可。
 * 设为 Custom 时自行播放视频，绑定时使用
 * bindWithContainer:clickableViews:customVideoView:videoDelegate:
 */
@property (nonatomic, assign) HXNativeVideoRenderMode videoRenderMode;

/// 落地页弹出控制器，一般传当前 VC。落地页/App Store/合规页面从该控制器弹出；不设置或失效时自动探测顶层。
/// 不设置时优先使用广告容器所在控制器。弱引用。
@property (nonatomic, weak, nullable) UIViewController *landingPageRootViewController;

/**
 * @brief 是否开启行为激励
 *
 * @discussion
 * 开启后，广告请求会携带 actReward=1 参数。
 * 服务端返回的广告仅支持自渲染（SDK 会强制切换 renderMode 为 Custom），
 * 且不支持摇/扭/滑交互，仅支持点击跳转。
 *
 * 用户点击广告跳转后返回时，SDK 会判断累计浏览时长是否达标，
 * 并通过 delegate 回调 nativeAd:didRewardWithRewardInfo: 或
 * nativeAd:didFailRewardWithRemainingTime:。
 *
 * 必须在调用 loadAd 之前设置。
 *
 * @default NO
 */
@property (nonatomic, assign) BOOL actReward;

/**
 * @brief 曝光判定持续时间阈值（秒）
 *
 * @discussion
 * 广告视图可见面积 >= 50% 并持续超过该时间后，判定为有效曝光并触发上报。
 * 必须在调用 loadAd 之前设置，加载后修改不生效。
 *
 * @default 0.3
 */
@property (nonatomic, assign) NSTimeInterval exposureDurationThreshold;

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
 * @brief 手动触发曝光上报（仅自渲染模式）
 *
 * @discussion
 * 通常不需要调用，SDK 会自动检测曝光。
 * 仅在特殊布局（如复杂 ScrollView 嵌套）导致自动检测失效时使用。
 *
 * 调用条件：
 * - 广告视图可见面积 >= 50%
 * - 持续可见时间 >= exposureDurationThreshold（默认 0.3 秒）
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

#pragma mark - 自定义视频播放事件回传

// 自定义视频模式下播放发生在开发者自己的播放器里，SDK 无法自动感知，
// 请在对应时机调用以下方法完成视频统计。未接入会导致视频数据缺失。

/// 视频开始播放，重复调用无效
- (void)notifyCustomVideoDidStart;

/// 播放进度 0.0~1.0，建议 0.5~1 秒回传一次，SDK 会在 25%/50%/75% 处各记一次
- (void)notifyCustomVideoDidReachProgress:(CGFloat)progress;

/// 播放完成，重复调用无效
- (void)notifyCustomVideoDidComplete;

/// 播放失败
- (void)notifyCustomVideoDidFailWithError:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END

