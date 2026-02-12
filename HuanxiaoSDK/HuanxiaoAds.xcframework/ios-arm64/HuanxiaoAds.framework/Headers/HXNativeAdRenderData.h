//
//  HXNativeAdRenderData.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  自渲染信息流广告数据模型
//  提供媒体渲染所需的安全数据，不暴露敏感信息
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class HXNativeAdRenderData
 * @brief 自渲染信息流广告数据模型
 *
 * @discussion
 * 仅包含媒体渲染 UI 所需的数据，不暴露任何敏感信息：
 * - 不包含 tracking URLs（曝光/点击上报地址）
 * - 不包含原始素材 URL（图片/视频地址）
 * - 不包含 deeplink 地址
 * - 不包含其他后端配置参数
 *
 * 所有属性均为只读，数据由 SDK 内部填充。
 */
@interface HXNativeAdRenderData : NSObject

#pragma mark - 基础信息

/// 广告标题
@property (nonatomic, copy, readonly) NSString *title;

/// 广告描述
@property (nonatomic, copy, readonly) NSString *desc;

/// 行动按钮文案（如 "立即下载"、"查看详情"、"了解更多"）
@property (nonatomic, copy, readonly) NSString *ctaText;

/// 广告来源/品牌名（如 "广告主名称"）
@property (nonatomic, copy, readonly, nullable) NSString *source;

#pragma mark - 图片资源

/// 主图（已加载的 UIImage，可能为空）
@property (nonatomic, strong, readonly, nullable) UIImage *mainImage;

/// 图标（已加载的 UIImage，可能为空）
@property (nonatomic, strong, readonly, nullable) UIImage *iconImage;

#pragma mark - 尺寸信息

/// 主图原始尺寸（像素）
@property (nonatomic, assign, readonly) CGSize mainImageSize;

/// 主图宽高比（width / height），用于媒体计算布局
/// 例如：16:9 返回 1.778，9:16 返回 0.5625
@property (nonatomic, assign, readonly) CGFloat imageRatio;

#pragma mark - 广告类型

/// 是否为视频广告
@property (nonatomic, assign, readonly) BOOL isVideoAd;

/// 是否为下载类广告（App 下载推广）
@property (nonatomic, assign, readonly) BOOL isDownloadAd;

#pragma mark - 交互信息

/**
 * @brief 交互类型
 *
 * @discussion
 * 值含义：
 * - 0: 点击
 * - 1: 摇一摇
 * - 2: 扭一扭
 * - 3: 滑动
 * - 10: 摇一摇+点击
 * - 20: 扭一扭+点击
 * - 30: 滑动+点击
 */
@property (nonatomic, assign, readonly) NSInteger interactionType;

/**
 * @brief 交互图标类型标识
 *
 * @discussion
 * 媒体可根据此值选择展示对应的交互图标：
 * - "click": 点击
 * - "shake": 摇一摇
 * - "twist": 扭一扭
 * - "swipe": 滑动
 *
 * 当 interactionType 为复合类型（10/20/30）时，
 * 此值返回主交互类型（shake/twist/swipe）
 */
@property (nonatomic, copy, readonly, nullable) NSString *interactionIconType;

/**
 * @brief 交互提示文案
 *
 * @discussion
 * 用于展示给用户的提示语，例如：
 * - "摇一摇查看详情"
 * - "扭动手机了解更多"
 * - "向上滑动打开"
 * - nil（点击类型无提示语）
 */
@property (nonatomic, copy, readonly, nullable) NSString *interactionHintText;

#pragma mark - 合规标识

/// 广告标识文案（通常为 "广告" 或 "AD"）
/// 媒体必须在广告视图上展示此标识以符合法规要求
@property (nonatomic, copy, readonly) NSString *adBadgeText;

/// 广告标识图标（已加载的 UIImage）
/// 媒体可将此图标与 adBadgeText 一起展示，增强广告标识的可识别性
@property (nonatomic, strong, readonly, nullable) UIImage *adBadgeIcon;

#pragma mark - 视频信息（仅视频广告有值）

/// 视频时长（秒），非视频广告返回 0
@property (nonatomic, assign, readonly) NSTimeInterval videoDuration;

/// 是否自动播放
@property (nonatomic, assign, readonly) BOOL videoAutoPlay;

/// 是否默认静音
@property (nonatomic, assign, readonly) BOOL videoMuted;

#pragma mark - 应用信息（仅下载类广告有值）

/// 应用名称
@property (nonatomic, copy, readonly, nullable) NSString *appName;

/// 开发者名称
@property (nonatomic, copy, readonly, nullable) NSString *appDeveloper;

/// 应用版本号
@property (nonatomic, copy, readonly, nullable) NSString *appVersion;

/// 应用大小（已格式化，如 "52.3 MB"）
@property (nonatomic, copy, readonly, nullable) NSString *appSize;

/// 应用图标（已加载的 UIImage，可能与 iconImage 相同）
@property (nonatomic, strong, readonly, nullable) UIImage *appIcon;

@end

NS_ASSUME_NONNULL_END
