//
//  HXInteractionContainerView.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  自渲染广告交互容器视图
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 交互类型（公开枚举）

/**
 * @brief 交互容器的交互类型
 */
typedef NS_ENUM(NSUInteger, HXInteractionType) {
    /// 无交互（默认）
    HXInteractionTypeNone   = 0,
    /// 摇一摇
    HXInteractionTypeShake  = 1,
    /// 扭一扭
    HXInteractionTypeTwist  = 2,
    /// 滑动
    HXInteractionTypeSwipe  = 3,
};

/**
 * @class HXInteractionContainerView
 * @brief 自渲染广告交互容器视图
 *
 * @discussion
 * SDK 提供的交互容器，内置摇一摇/扭一扭/滑动的交互监测能力。
 * 媒体开发者可通过 addSubview 在容器中添加自定义内容。
 *
 * 使用流程：
 * 1. 从 HXNativeAdRenderData.interactionContainerView 获取容器
 * 2. 可选：隐藏 defaultAnimationView，添加自定义子视图（如自定义图标、文案等）
 * 3. 将容器添加到广告视图层级并设置布局约束
 * 4. 调用 bindWithContainer:clickableViews: 后，SDK 自动启动交互监测和动画
 *
 * @note 容器的 width/height 为 1:1 时效果最佳
 */
@interface HXInteractionContainerView : UIView

/// 交互类型（摇一摇/扭一扭/滑动）
@property (nonatomic, assign, readonly) HXInteractionType interactionType;

/// SDK 提供的默认动画指示视图（如摇一摇手机图标）
@property (nonatomic, strong, readonly, nullable) UIView *defaultAnimationView;

/**
 * 媒体自定义内容视图。设置后 SDK 会：
 * 1. 自动隐藏 defaultAnimationView
 * 2. 将自定义视图添加到容器并撑满
 * 3. 对自定义视图应用与交互类型匹配的提示动画（摇摆/旋转/上下浮动）
 *
 * 设为 nil 则恢复 SDK 默认动画视图。
 *
 * @code
 * UIImageView *myIcon = [[UIImageView alloc] initWithImage:myBrandImage];
 * container.customContentView = myIcon;
 * @endcode
 */
@property (nonatomic, strong, nullable) UIView *customContentView;

/// 开始播放交互提示动画（作用于 customContentView 或 defaultAnimationView）
- (void)startAnimation;

/// 停止播放交互提示动画
- (void)stopAnimation;

/// 动画是否正在播放
@property (nonatomic, assign, readonly, getter=isAnimating) BOOL animating;

@end

NS_ASSUME_NONNULL_END
