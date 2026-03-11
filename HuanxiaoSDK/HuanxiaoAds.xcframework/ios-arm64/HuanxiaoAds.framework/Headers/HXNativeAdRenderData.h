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

NS_ASSUME_NONNULL_BEGIN

@interface HXNativeAdRenderData : NSObject

//  按钮文字
@property (nonatomic, copy, readonly) NSString *ctaText;
//  广告标题
@property (nonatomic, copy, readonly) NSString *title;
//  广告图片素材
@property (nonatomic, strong, readonly) NSArray *images;
//  广告文字素材
@property (nonatomic, strong, readonly) NSArray *texts;
//  广告视频素材
@property (nonatomic, strong, readonly) NSArray *videos;
//  广告素材宽
@property (nonatomic, assign, readonly) NSInteger width;
//  广告素材高
@property (nonatomic, assign, readonly) NSInteger height;
// 由于广告法规定，必须添加广告标识（建议：广告标识放置在广告的左下角，logo放置在广告的右下角）
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
//  摇一摇的 UIImageView 视图，调用 startAnimating 方法即可开启动画，视图 width/height = 1:1
@property (nonatomic, strong, readonly, nullable) UIImageView *shakeAnimationView;
//  是否是视频
@property (nonatomic, assign, readonly) BOOL isVideoAd;
//  如果 isVideoAd=YES，会提供视频播放器视图
@property (nonatomic, strong, readonly, nullable) HXMediaView *mediaView;

// 绑定展示视图和广告点击 View（该视图点击可以跳转到落地页）
- (void)bindWithContainer:(UIView *)containerView clickableViews:(NSArray *)clickableViews;
// 添加关闭视图（该视图点击，可以关闭广告）
- (void)addCloseTarget:(UIView *)targetView;
// 添加摇一摇视图，调用此方法后，SDK 内会开启摇一摇的监听，以及 targetView 的点击响应
- (void)addShakeTarget:(UIView *)targetView;
// 添加支持手势滑动的视图
- (void)addSwipeTargets:(NSArray *)swipeViews;

@end

NS_ASSUME_NONNULL_END
