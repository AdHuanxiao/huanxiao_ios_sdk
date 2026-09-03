//
//  HXNativeAdRenderData.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  自渲染信息流广告数据模型
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HXMediaView;
@class HXInteractionContainerView;
@protocol HXNativeAdCustomVideoDelegate;

NS_ASSUME_NONNULL_BEGIN

/// 自渲染广告的应用信息。下载类广告应使用这些字段展示应用合规信息。
@interface HXNativeAdAppInfo : NSObject

/// 应用名称
@property (nonatomic, copy, readonly, nullable) NSString *name;
/// 应用图标地址。
@property (nonatomic, copy, readonly, nullable) NSString *iconUrl;
/// 应用大小，单位 KB；
@property (nonatomic, assign, readonly) NSUInteger sizeInKilobytes;
/// 应用版本号
@property (nonatomic, copy, readonly, nullable) NSString *versionName;
/// 应用包名
@property (nonatomic, copy, readonly, nullable) NSString *packageName;
/// 应用开发者
@property (nonatomic, copy, readonly, nullable) NSString *developer;
/// 应用权限说明页面地址
@property (nonatomic, copy, readonly, nullable) NSString *permissionUrl;
/// 应用隐私协议页面地址
@property (nonatomic, copy, readonly, nullable) NSString *privacyUrl;
/// 应用介绍页面地址
@property (nonatomic, copy, readonly, nullable) NSString *descriptionUrl;
/// 应用备案信息页面地址
@property (nonatomic, copy, readonly, nullable) NSString *icpUrl;
/// 应用适用年龄
@property (nonatomic, copy, readonly, nullable) NSString *ageLimit;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

@interface HXNativeAdRenderData : NSObject

//  按钮文字
@property (nonatomic, copy, readonly) NSString *ctaText;
//  广告标题
@property (nonatomic, copy, readonly) NSString *title;
//  广告图片素材
@property (nonatomic, strong, readonly) NSArray *images;
//  广告图片素材URL
@property (nonatomic, strong, readonly) NSArray<NSString *> *imageUrls;
//  广告文字素材
@property (nonatomic, strong, readonly) NSArray *texts;
//  广告视频素材
@property (nonatomic, strong, readonly) NSArray *videos;
//  广告素材宽
@property (nonatomic, assign, readonly) NSInteger width;
//  广告素材高
@property (nonatomic, assign, readonly) NSInteger height;
//  由于广告法规定，必须添加广告标识（建议：广告标识放置在广告的左下角，logo放置在广告的右下角）
//  广告标识图片
@property (nonatomic, strong, readonly, nullable) UIImage *adLabelImage;
//  广告标识文字
@property (nonatomic, copy, readonly) NSString *adLabel;
//  logo图片
@property (nonatomic, strong, readonly, nullable) UIImage *logoImage;
//  logo文字
@property (nonatomic, copy, readonly, nullable) NSString *logoLabel;
//  广告图标URL
@property (nonatomic, copy, readonly, nullable) NSString *iconUrl;
//  应用图标
@property (nonatomic, strong, readonly, nullable) UIImage *appIcon;
//  应用图标URL
@property (nonatomic, copy, readonly, nullable) NSString *appIconUrl;
/// 应用信息。下载类广告应按监管要求展示相应信息。
@property (nonatomic, strong, readonly, nullable) HXNativeAdAppInfo *appInfo;

/**
 * 交互容器视图（摇一摇/扭一扭/滑动），媒体可在容器内 addSubview 添加自定义内容。
 * 将容器添加到广告视图层级后，调用 bindWithContainer:clickableViews: 时 SDK 自动启动交互监测。
 * 容器 width/height 建议 1:1，如 55x55
 */
@property (nonatomic, strong, readonly, nullable) HXInteractionContainerView *interactionContainerView;

//  摇一摇的 UIImageView 视图（已废弃，请使用 interactionContainerView 替代）
@property (nonatomic, strong, readonly, nullable) UIImageView *shakeAnimationView
    __deprecated_msg("请使用 interactionContainerView 替代");

//  是否是视频
@property (nonatomic, assign, readonly) BOOL isVideoAd;
/// 是否是下载类广告。
@property (nonatomic, assign, readonly) BOOL isDownloadAd;
//  视频播放视图，isVideoAd=YES 时有值。
//  videoRenderMode 设为 Custom 时为 nil，请用下方 videoUrl 等字段自行播放
@property (nonatomic, strong, readonly, nullable) HXMediaView *mediaView;

#pragma mark - 视频素材（isVideoAd=YES 时有值，自定义视频模式使用）

//  视频播放地址
@property (nonatomic, copy, readonly, nullable) NSString *videoUrl;
//  视频封面图地址
@property (nonatomic, copy, readonly, nullable) NSString *videoCoverUrl;
//  视频时长（秒）
@property (nonatomic, assign, readonly) NSTimeInterval videoDuration;
//  视频素材宽高（像素）
@property (nonatomic, assign, readonly) CGSize videoSize;

#pragma mark - 行为激励信息（actReward 开启时有值）

/// 激励信息文案，如 "浏览获得奖励"
@property (nonatomic, copy, readonly, nullable) NSString *rewardInfoText;
/// 达标所需浏览时长（秒）
@property (nonatomic, assign, readonly) NSUInteger rewardSeconds;

/// 绑定展示视图和广告点击 View（该视图点击可以跳转到落地页）。
/// 如果 interactionContainerView 已添加到视图层级中，SDK 会自动启动交互监测和提示动画。
- (void)bindWithContainer:(UIView *)containerView clickableViews:(NSArray *)clickableViews;

/// 绑定展示视图和可点击区域。videoRenderMode = Custom 且为视频广告时使用：
/// customVideoView 传你的播放器视图（弱引用），videoDelegate 传播放控制实现（弱引用）。
/// 需要点击视频区域跳转时，把视频视图一并放进 clickableViews。
- (void)bindWithContainer:(UIView *)containerView
           clickableViews:(NSArray *)clickableViews
          customVideoView:(nullable UIView *)customVideoView
            videoDelegate:(nullable id<HXNativeAdCustomVideoDelegate>)videoDelegate;

/// 添加关闭视图（该视图点击，可以关闭广告）
- (void)addCloseTarget:(UIView *)targetView;

/// 已废弃：使用 interactionContainerView 替代，bindWithContainer: 时 SDK 自动绑定交互
- (void)addShakeTarget:(UIView *)targetView
    __deprecated_msg("请使用 interactionContainerView 替代，bindWithContainer: 时 SDK 自动绑定交互");

/// 已废弃：使用 interactionContainerView 替代，bindWithContainer: 时 SDK 自动绑定交互
- (void)addSwipeTargets:(NSArray *)swipeViews
    __deprecated_msg("请使用 interactionContainerView 替代，bindWithContainer: 时 SDK 自动绑定交互");

@end

NS_ASSUME_NONNULL_END
