//
//  HXNativeAdCustomViews.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  自渲染信息流广告视图绑定配置
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class HXNativeAdCustomViews
 * @brief 自渲染信息流广告视图绑定配置
 *
 * @discussion
 * 媒体创建自定义视图后，通过此对象将视图引用传递给 SDK。
 * SDK 会在这些视图上：
 * - 添加必要的手势识别器（点击、滑动）
 * - 注册曝光检测
 * - 处理交互逻辑（摇一摇/扭一扭）
 * - 在视频容器中添加播放层
 *
 * ⚠️ 注意：
 * - adBadgeView 必须绑定，否则不符合广告法规要求
 * - 视频广告必须绑定 videoContainerView
 * - 所有视图使用 weak 引用，媒体需自行持有
 */
@interface HXNativeAdCustomViews : NSObject

#pragma mark - 内容视图（可选绑定）

/// 标题标签
/// SDK 不会修改其内容，仅用于记录绑定关系
@property (nonatomic, weak, nullable) UILabel *titleLabel;

/// 描述标签
/// SDK 不会修改其内容，仅用于记录绑定关系
@property (nonatomic, weak, nullable) UILabel *descLabel;

/// 主图视图
/// SDK 不会修改其内容，仅用于记录绑定关系
@property (nonatomic, weak, nullable) UIImageView *mainImageView;

/// 图标视图
/// SDK 不会修改其内容，仅用于记录绑定关系
@property (nonatomic, weak, nullable) UIImageView *iconImageView;

/// 行动按钮
/// SDK 会在此按钮上添加点击手势（如果 clickableView 未设置）
@property (nonatomic, weak, nullable) UIButton *actionButton;

#pragma mark - 必须绑定

/**
 * @brief 广告标识视图（合规必须）
 *
 * @discussion
 * 媒体需要自己创建并渲染广告标识（如 UILabel 显示 "广告"）。
 * SDK 会检测此视图是否正确展示：
 * - 视图不能为 nil
 * - 视图不能被隐藏（hidden = NO）
 * - 视图必须有有效尺寸
 *
 * ⚠️ 根据《广告法》要求，广告必须有明显标识，
 * 未正确展示广告标识可能导致法律风险。
 */
@property (nonatomic, weak, nullable) UIView *adBadgeView;

#pragma mark - 视频相关（视频广告必须绑定）

/**
 * @brief 视频容器视图
 *
 * @discussion
 * 媒体提供一个空的 UIView 作为视频容器，SDK 会在其中添加视频播放层。
 * 媒体只需要负责容器的布局（位置、大小）。
 *
 * 注意：
 * - 视频广告必须绑定此视图
 * - 容器的 clipsToBounds 会被设置为 YES
 * - SDK 添加的播放层会填满容器
 */
@property (nonatomic, weak, nullable) UIView *videoContainerView;

#pragma mark - 交互相关（可选）

/**
 * @brief 交互提示视图（摇一摇/扭一扭/滑动图标）
 *
 * @discussion
 * 媒体根据 renderData.interactionIconType 自行渲染交互提示图标。
 * SDK 只负责检测交互动作，不会修改此视图。
 *
 * 建议：
 * - 摇一摇：显示手机摇动图标
 * - 扭一扭：显示手机扭动图标
 * - 滑动：显示向上滑动箭头
 */
@property (nonatomic, weak, nullable) UIView *interactionHintView;

/**
 * @brief 可点击区域视图
 *
 * @discussion
 * SDK 会在此视图上添加点击手势。
 * 如果未设置，默认使用 bindCustomViews:container: 中的 container 作为点击区域。
 *
 * 使用场景：
 * - 只想让部分区域可点击（如底部信息栏）
 * - 不想让整个广告容器都可点击
 */
@property (nonatomic, weak, nullable) UIView *clickableView;

#pragma mark - 关闭按钮（可选）

/**
 * @brief 关闭按钮
 *
 * @discussion
 * 媒体自行创建关闭按钮，SDK 会添加点击事件处理。
 * 点击后 SDK 会：
 * 1. 停止视频播放（如果是视频广告）
 * 2. 停止交互检测
 * 3. 回调 nativeAdDidClose:
 */
@property (nonatomic, weak, nullable) UIButton *closeButton;

@end

NS_ASSUME_NONNULL_END
