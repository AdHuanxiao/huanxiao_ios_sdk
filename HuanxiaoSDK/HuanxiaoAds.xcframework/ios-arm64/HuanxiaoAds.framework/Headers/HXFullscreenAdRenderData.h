//
//  HXFullscreenAdRenderData.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXMediaView;
@class HXInteractionContainerView;

NS_ASSUME_NONNULL_BEGIN

/// 服务端决定的广告渲染方式，仅加载成功后的查询结果有效。
typedef NS_ENUM(NSInteger, HXFullscreenAdRenderMode) {
    HXFullscreenAdRenderModeTemplate = 0,
    HXFullscreenAdRenderModeCustom = 1,
};

/// 下载类广告的应用信息快照；由 SDK 创建。
@interface HXFullscreenAdAppInfo : NSObject
@property (nonatomic, copy, readonly, nullable) NSString *name;
@property (nonatomic, copy, readonly, nullable) NSString *iconUrl;
/// 应用大小，单位 KB。
@property (nonatomic, assign, readonly) NSUInteger sizeInKilobytes;
@property (nonatomic, copy, readonly, nullable) NSString *versionName;
@property (nonatomic, copy, readonly, nullable) NSString *packageName;
@property (nonatomic, copy, readonly, nullable) NSString *developer;
@property (nonatomic, copy, readonly, nullable) NSString *permissionUrl;
@property (nonatomic, copy, readonly, nullable) NSString *privacyUrl;
@property (nonatomic, copy, readonly, nullable) NSString *descriptionUrl;
@property (nonatomic, copy, readonly, nullable) NSString *icpUrl;
@property (nonatomic, copy, readonly, nullable) NSString *ageLimit;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

/// 开屏、插屏自渲染素材及 SDK 提供的视图。数据在加载完成后保持不变。
/// 自渲染仍须展示广告标识及下载类应用信息；通过 appInfoView 可使用 SDK 的合规信息与链接。
@interface HXFullscreenAdRenderData : NSObject
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *desc;
@property (nonatomic, copy, readonly) NSString *ctaText;
/// 已缓存的主图或视频封面；未缓存时为空，请使用 imageUrls/videoCoverUrl。
@property (nonatomic, copy, readonly) NSArray<UIImage *> *images;
@property (nonatomic, copy, readonly) NSArray<NSString *> *imageUrls;
/// 素材像素尺寸；视频尺寸缺失时回退到首张图片。
@property (nonatomic, assign, readonly) CGSize imageSize;
@property (nonatomic, assign, readonly) NSInteger width;
@property (nonatomic, assign, readonly) NSInteger height;
@property (nonatomic, copy, readonly, nullable) NSString *iconUrl;
@property (nonatomic, strong, readonly, nullable) UIImage *appIcon;
@property (nonatomic, copy, readonly, nullable) NSString *appIconUrl;
@property (nonatomic, strong, readonly, nullable) HXFullscreenAdAppInfo *appInfo;
@property (nonatomic, assign, readonly) BOOL isDownloadAd;
/// adLabelImage 无法生成时的文字兜底；两者二选一，不要重复叠加。
@property (nonatomic, copy, readonly) NSString *adLabel;
/// 包含所需文字的完整广告标识图，优先显示；隐藏 Logo 或源图缺失时为仅“广告”文字的图片。
@property (nonatomic, strong, readonly, nullable) UIImage *adLabelImage;
/// 与 logoImage 配合：完整图片模式成功时为空；纯 Logo 模式或没有图片时为“广告”。
@property (nonatomic, copy, readonly) NSString *logoLabel;
/// 按构建配置返回的原始角标图；服务端隐藏 Logo 时为 nil。
@property (nonatomic, strong, readonly, nullable) UIImage *logoImage;

@property (nonatomic, assign, readonly) BOOL isVideoAd;
@property (nonatomic, copy, readonly, nullable) NSString *videoUrl;
@property (nonatomic, copy, readonly, nullable) NSString *videoCoverUrl;
@property (nonatomic, assign, readonly) CGSize videoSize;
/// 视频时长，单位秒。
@property (nonatomic, assign, readonly) NSTimeInterval videoDuration;
/// 视频广告使用 SDK 播放组件。将它放入容器后再绑定，展示时由 SDK 管理播放和统计。
@property (nonatomic, strong, readonly, nullable) HXMediaView *mediaView;
/// 摇一摇/扭一扭/滑动提示容器。可自定义其内容；绑定阶段不会开始运动检测或提示动画。
@property (nonatomic, strong, readonly, nullable) HXInteractionContainerView *interactionContainerView;
/// SDK 关闭/跳过按钮。媒体可设置外观和布局；标题、可用状态及关闭时机由 SDK 管理。
@property (nonatomic, strong, readonly) UIButton *closeButton;
/// SDK 广告标识与应用信息视图，包含权限、隐私等链接。请加入广告内容容器并完整展示。
/// 可通过 sizeThatFits: 按可用宽度获取所需高度；SDK 不修改媒体分配的 frame。
@property (nonatomic, strong, readonly) UIView *appInfoView;

/// 主线程调用。绑定仅准备展示，不会启动播放、曝光或交互；随后调用所属广告的展示方法。
/// 开屏内容容器应填满展示区域；插屏内容容器的尺寸由媒体布局。
/// 可点击视图必须属于 containerView（可包含容器自身）；SDK 组件可先添加并布局。
/// rootViewController 用于广告及合规链接页面跳转。返回 NO 时旧绑定保持不变，error 可传 nil。
- (BOOL)bindWithContainer:(UIView *)containerView
          clickableViews:(NSArray<UIView *> *)clickableViews
      rootViewController:(UIViewController *)rootViewController
                   error:(NSError * _Nullable * _Nullable)error;

/// 主线程调用。登记自定义关闭区域，仅准备事件绑定；实际关闭仍遵守 SDK 的关闭时机。
/// 使用 closeButton 时无需重复登记。自定义区域应属于已绑定的广告内容容器。
- (BOOL)addCloseTarget:(UIView *)targetView error:(NSError * _Nullable * _Nullable)error;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
