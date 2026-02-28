//
//  CustomRenderNativeAdViewController.m
//  HuanxiaoAdsExample
//
//  自渲染信息流广告测试页面
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

#import "CustomRenderNativeAdViewController.h"
#import <HuanxiaoAds/HuanxiaoAds.h>

@interface CustomRenderNativeAdViewController () <HXNativeAdDelegate, UITextFieldDelegate>

#pragma mark - 输入区域
@property (nonatomic, strong) UITextField *adSpotTextField;
@property (nonatomic, strong) UIButton *loadButton;
@property (nonatomic, strong) UILabel *statusLabel;

#pragma mark - 广告容器
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *adContainerView;

#pragma mark - 自渲染 UI 组件
@property (nonatomic, strong) UIView *customAdView;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *ctaButton;
@property (nonatomic, strong) UIView *adBadgeContainer;
@property (nonatomic, strong) UIImageView *adBadgeIconView;
@property (nonatomic, strong) UILabel *adBadgeLabel;
@property (nonatomic, strong) UIView *interactionHintView;
@property (nonatomic, strong) UILabel *interactionHintLabel;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIView *videoContainerView;
@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, assign) BOOL isMuted;

#pragma mark - 广告对象
@property (nonatomic, strong) HXNativeAd *nativeAd;

@end

@implementation CustomRenderNativeAdViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    self.title = @"自渲染信息流";
    
    [self setupInputArea];
    [self setupScrollView];
    [self setupAdContainer];
}

- (void)dealloc {
    [self.nativeAd close];
    self.nativeAd = nil;
    NSLog(@"[CustomRenderNativeAd] ViewController dealloc");
}

#pragma mark - UI Setup

- (void)setupInputArea {
    // 输入框
    self.adSpotTextField = [[UITextField alloc] init];
    self.adSpotTextField.placeholder = @"请输入广告位 ID";
    self.adSpotTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.adSpotTextField.font = [UIFont systemFontOfSize:15];
    self.adSpotTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.adSpotTextField.returnKeyType = UIReturnKeyDone;
    self.adSpotTextField.delegate = self;
    self.adSpotTextField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.adSpotTextField];
    
    // 加载按钮
    self.loadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.loadButton setTitle:@"加载广告" forState:UIControlStateNormal];
    self.loadButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.loadButton.backgroundColor = [UIColor systemBlueColor];
    [self.loadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loadButton.layer.cornerRadius = 8;
    [self.loadButton addTarget:self action:@selector(loadAdButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.loadButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.loadButton];
    
    // 状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.textColor = [UIColor grayColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.text = @"请输入广告位 ID 后点击加载";
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];
    
    CGFloat safeTop = 0;
    if (@available(iOS 11.0, *)) {
        safeTop = [UIApplication sharedApplication].windows.firstObject.safeAreaInsets.top;
    }
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height + safeTop;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.adSpotTextField.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:navHeight + 20],
        [self.adSpotTextField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.adSpotTextField.heightAnchor constraintEqualToConstant:44],
        
        [self.loadButton.leadingAnchor constraintEqualToAnchor:self.adSpotTextField.trailingAnchor constant:12],
        [self.loadButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.loadButton.centerYAnchor constraintEqualToAnchor:self.adSpotTextField.centerYAnchor],
        [self.loadButton.widthAnchor constraintEqualToConstant:90],
        [self.loadButton.heightAnchor constraintEqualToConstant:44],
        
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.adSpotTextField.bottomAnchor constant:12],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
    ]];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:20],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (void)setupAdContainer {
    self.adContainerView = [[UIView alloc] init];
    self.adContainerView.backgroundColor = [UIColor clearColor];
    self.adContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.adContainerView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.adContainerView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor constant:16],
        [self.adContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.adContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        [self.adContainerView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor constant:-16],
    ]];
}

#pragma mark - Actions

- (void)loadAdButtonTapped {
    [self.view endEditing:YES];
    
    NSString *adSpotID = self.adSpotTextField.text;
    if (adSpotID.length == 0) {
        self.statusLabel.text = @"请输入广告位 ID";
        self.statusLabel.textColor = [UIColor redColor];
        return;
    }
    
    // 清除旧广告
    [self clearOldAd];
    
    self.statusLabel.text = @"正在加载...";
    self.statusLabel.textColor = [UIColor grayColor];
    self.loadButton.enabled = NO;
    
    // 创建自渲染广告
    CGFloat adWidth = self.view.bounds.size.width - 32;
    self.nativeAd = [[HXNativeAd alloc] initWithAdSpotID:adSpotID size:CGSizeMake(adWidth, 0)];
    self.nativeAd.renderMode = HXNativeAdRenderModeCustom;  // 关键：设置为自渲染模式
    self.nativeAd.delegate = self;
    
    [self.nativeAd loadAd];
    
    NSLog(@"[CustomRenderNativeAd] 开始加载广告: %@", adSpotID);
}

- (void)clearOldAd {
    [self.nativeAd close];
    self.nativeAd = nil;
    
    [self.customAdView removeFromSuperview];
    self.customAdView = nil;
}

- (void)closeButtonTapped {
    NSLog(@"[CustomRenderNativeAd] 关闭按钮点击");
    [self.nativeAd close];
}

- (void)muteButtonTapped {
    self.isMuted = !self.isMuted;
    self.nativeAd.videoMuted = self.isMuted;
    [self updateMuteButtonIcon];
    NSLog(@"[CustomRenderNativeAd] 静音状态: %@", self.isMuted ? @"静音" : @"有声");
}

- (void)updateMuteButtonIcon {
    NSString *iconName = self.isMuted ? @"speaker.slash.fill" : @"speaker.wave.2.fill";
    UIImage *icon = [UIImage systemImageNamed:iconName];
    [self.muteButton setImage:icon forState:UIControlStateNormal];
    self.muteButton.tintColor = [UIColor whiteColor];
}

#pragma mark - 自渲染 UI 构建

- (void)buildCustomAdViewWithData:(HXNativeAdRenderData *)data {
    CGFloat containerWidth = self.view.bounds.size.width - 32;
    
    // 创建广告容器
    self.customAdView = [[UIView alloc] init];
    self.customAdView.backgroundColor = [UIColor whiteColor];
    self.customAdView.layer.cornerRadius = 12;
    self.customAdView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.customAdView.layer.shadowOffset = CGSizeMake(0, 2);
    self.customAdView.layer.shadowOpacity = 0.1;
    self.customAdView.layer.shadowRadius = 8;
    self.customAdView.clipsToBounds = NO;
    self.customAdView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adContainerView addSubview:self.customAdView];
    
    // 内容容器（用于裁剪圆角）
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 12;
    contentView.clipsToBounds = YES;
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.customAdView addSubview:contentView];
    
    CGFloat imageHeight = 0;
    
    if (data.isVideoAd) {
        // 视频广告：创建视频容器
        self.videoContainerView = [[UIView alloc] init];
        self.videoContainerView.backgroundColor = [UIColor blackColor];
        self.videoContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:self.videoContainerView];
        
        imageHeight = containerWidth * 9.0 / 16.0; // 16:9 比例
        
        // 静音按钮
        self.isMuted = data.videoMuted;
        self.muteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self updateMuteButtonIcon];
        self.muteButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.muteButton.layer.cornerRadius = 16;
        self.muteButton.clipsToBounds = YES;
        [self.muteButton addTarget:self action:@selector(muteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        self.muteButton.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:self.muteButton];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.videoContainerView.topAnchor constraintEqualToAnchor:contentView.topAnchor],
            [self.videoContainerView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
            [self.videoContainerView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
            [self.videoContainerView.heightAnchor constraintEqualToConstant:imageHeight],
            
            // 静音按钮：视频区域右下角
            [self.muteButton.bottomAnchor constraintEqualToAnchor:self.videoContainerView.bottomAnchor constant:-12],
            [self.muteButton.trailingAnchor constraintEqualToAnchor:self.videoContainerView.trailingAnchor constant:-12],
            [self.muteButton.widthAnchor constraintEqualToConstant:32],
            [self.muteButton.heightAnchor constraintEqualToConstant:32],
        ]];
    } else {
        // 图片广告：主图
        self.mainImageView = [[UIImageView alloc] init];
        self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.mainImageView.clipsToBounds = YES;
        self.mainImageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        self.mainImageView.image = data.mainImage;
        self.mainImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:self.mainImageView];
        
        // 计算图片高度
        if (data.imageRatio > 0) {
            imageHeight = containerWidth / data.imageRatio;
        } else {
            imageHeight = containerWidth * 9.0 / 16.0;
        }
        
        [NSLayoutConstraint activateConstraints:@[
            [self.mainImageView.topAnchor constraintEqualToAnchor:contentView.topAnchor],
            [self.mainImageView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor],
            [self.mainImageView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor],
            [self.mainImageView.heightAnchor constraintEqualToConstant:imageHeight],
        ]];
    }
    
    // 广告标识（合规必须）- 放在图片/视频上层
    self.adBadgeContainer = [[UIView alloc] init];
    self.adBadgeContainer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    self.adBadgeContainer.layer.cornerRadius = 4;
    self.adBadgeContainer.clipsToBounds = YES;
    self.adBadgeContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:self.adBadgeContainer];
    
    // 广告标识图标
    self.adBadgeIconView = [[UIImageView alloc] init];
    self.adBadgeIconView.contentMode = UIViewContentModeScaleAspectFit;
    self.adBadgeIconView.tintColor = [UIColor whiteColor];
    self.adBadgeIconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adBadgeContainer addSubview:self.adBadgeIconView];
    
    // 设置图标：优先使用 SDK 返回的图标，否则使用系统图标
    if (data.adBadgeIcon) {
        self.adBadgeIconView.image = data.adBadgeIcon;
    } else {
        self.adBadgeIconView.image = [UIImage systemImageNamed:@"info.circle.fill"];
    }
    
    // 广告标识文字
    self.adBadgeLabel = [[UILabel alloc] init];
    self.adBadgeLabel.text = data.adBadgeText.length > 0 ? data.adBadgeText : @"广告";
    self.adBadgeLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightMedium];
    self.adBadgeLabel.textColor = [UIColor whiteColor];
    self.adBadgeLabel.textAlignment = NSTextAlignmentCenter;
    self.adBadgeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.adBadgeContainer addSubview:self.adBadgeLabel];
    
    // 广告标识内边距约束（图标 + 文字）
    [NSLayoutConstraint activateConstraints:@[
        // 图标
        [self.adBadgeIconView.leadingAnchor constraintEqualToAnchor:self.adBadgeContainer.leadingAnchor constant:4],
        [self.adBadgeIconView.centerYAnchor constraintEqualToAnchor:self.adBadgeContainer.centerYAnchor],
        [self.adBadgeIconView.widthAnchor constraintEqualToConstant:10],
        [self.adBadgeIconView.heightAnchor constraintEqualToConstant:10],
        
        // 文字
        [self.adBadgeLabel.topAnchor constraintEqualToAnchor:self.adBadgeContainer.topAnchor constant:2],
        [self.adBadgeLabel.bottomAnchor constraintEqualToAnchor:self.adBadgeContainer.bottomAnchor constant:-2],
        [self.adBadgeLabel.leadingAnchor constraintEqualToAnchor:self.adBadgeIconView.trailingAnchor constant:3],
        [self.adBadgeLabel.trailingAnchor constraintEqualToAnchor:self.adBadgeContainer.trailingAnchor constant:-5],
    ]];
    
    // 关闭按钮 - 放在图片/视频上层
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setImage:[UIImage systemImageNamed:@"xmark.circle.fill"] forState:UIControlStateNormal];
    self.closeButton.tintColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:self.closeButton];
    
    // 交互提示（如果有）
    if (data.interactionHintText.length > 0) {
        self.interactionHintView = [[UIView alloc] init];
        self.interactionHintView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        self.interactionHintView.layer.cornerRadius = 4;
        self.interactionHintView.translatesAutoresizingMaskIntoConstraints = NO;
        [contentView addSubview:self.interactionHintView];
        
        self.interactionHintLabel = [[UILabel alloc] init];
        self.interactionHintLabel.text = data.interactionHintText;
        self.interactionHintLabel.font = [UIFont systemFontOfSize:12];
        self.interactionHintLabel.textColor = [UIColor whiteColor];
        self.interactionHintLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.interactionHintView addSubview:self.interactionHintLabel];
        
        UIView *topView = data.isVideoAd ? self.videoContainerView : self.mainImageView;
        [NSLayoutConstraint activateConstraints:@[
            [self.interactionHintView.bottomAnchor constraintEqualToAnchor:topView.bottomAnchor constant:-12],
            [self.interactionHintView.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
            
            [self.interactionHintLabel.topAnchor constraintEqualToAnchor:self.interactionHintView.topAnchor constant:6],
            [self.interactionHintLabel.bottomAnchor constraintEqualToAnchor:self.interactionHintView.bottomAnchor constant:-6],
            [self.interactionHintLabel.leadingAnchor constraintEqualToAnchor:self.interactionHintView.leadingAnchor constant:12],
            [self.interactionHintLabel.trailingAnchor constraintEqualToAnchor:self.interactionHintView.trailingAnchor constant:-12],
        ]];
    }
    
    // 底部信息区
    UIView *infoView = [[UIView alloc] init];
    infoView.translatesAutoresizingMaskIntoConstraints = NO;
    [contentView addSubview:infoView];
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 6;
    self.iconImageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.iconImageView.image = data.iconImage ?: data.appIcon;
    self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [infoView addSubview:self.iconImageView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = data.title;
    self.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [infoView addSubview:self.titleLabel];
    
    // 描述
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.text = data.desc;
    self.descLabel.font = [UIFont systemFontOfSize:13];
    self.descLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    self.descLabel.numberOfLines = 2;
    self.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [infoView addSubview:self.descLabel];
    
    // CTA 按钮
    self.ctaButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.ctaButton setTitle:data.ctaText forState:UIControlStateNormal];
    self.ctaButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.ctaButton.backgroundColor = [UIColor systemBlueColor];
    [self.ctaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.ctaButton.layer.cornerRadius = 6;
    self.ctaButton.userInteractionEnabled = NO; // 点击由 SDK 处理
    self.ctaButton.translatesAutoresizingMaskIntoConstraints = NO;
    [infoView addSubview:self.ctaButton];
    
    UIView *topView = data.isVideoAd ? self.videoContainerView : self.mainImageView;
    
    [NSLayoutConstraint activateConstraints:@[
        // 广告容器
        [self.customAdView.topAnchor constraintEqualToAnchor:self.adContainerView.topAnchor],
        [self.customAdView.leadingAnchor constraintEqualToAnchor:self.adContainerView.leadingAnchor],
        [self.customAdView.trailingAnchor constraintEqualToAnchor:self.adContainerView.trailingAnchor],
        
        // 内容容器
        [contentView.topAnchor constraintEqualToAnchor:self.customAdView.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:self.customAdView.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:self.customAdView.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:self.customAdView.bottomAnchor],
        
        // 广告标识容器
        [self.adBadgeContainer.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:8],
        [self.adBadgeContainer.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:8],
        
        // 关闭按钮
        [self.closeButton.topAnchor constraintEqualToAnchor:contentView.topAnchor constant:8],
        [self.closeButton.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-8],
        [self.closeButton.widthAnchor constraintEqualToConstant:24],
        [self.closeButton.heightAnchor constraintEqualToConstant:24],
        
        // 底部信息区
        [infoView.topAnchor constraintEqualToAnchor:topView.bottomAnchor constant:12],
        [infoView.leadingAnchor constraintEqualToAnchor:contentView.leadingAnchor constant:12],
        [infoView.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor constant:-12],
        [infoView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor constant:-12],
        
        // 图标
        [self.iconImageView.topAnchor constraintEqualToAnchor:infoView.topAnchor],
        [self.iconImageView.leadingAnchor constraintEqualToAnchor:infoView.leadingAnchor],
        [self.iconImageView.widthAnchor constraintEqualToConstant:44],
        [self.iconImageView.heightAnchor constraintEqualToConstant:44],
        
        // 标题
        [self.titleLabel.topAnchor constraintEqualToAnchor:infoView.topAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.iconImageView.trailingAnchor constant:10],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.ctaButton.leadingAnchor constant:-10],
        
        // 描述
        [self.descLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:4],
        [self.descLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
        [self.descLabel.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor],
        [self.descLabel.bottomAnchor constraintLessThanOrEqualToAnchor:infoView.bottomAnchor],
        
        // CTA 按钮
        [self.ctaButton.centerYAnchor constraintEqualToAnchor:infoView.centerYAnchor],
        [self.ctaButton.trailingAnchor constraintEqualToAnchor:infoView.trailingAnchor],
        [self.ctaButton.widthAnchor constraintEqualToConstant:80],
        [self.ctaButton.heightAnchor constraintEqualToConstant:32],
        
        // 广告容器底部
        [self.customAdView.bottomAnchor constraintEqualToAnchor:self.adContainerView.bottomAnchor],
    ]];
    
    [self.view layoutIfNeeded];
    
    NSLog(@"[CustomRenderNativeAd] 自渲染 UI 构建完成，isVideoAd: %@", data.isVideoAd ? @"YES" : @"NO");
}

#pragma mark - HXNativeAdDelegate

- (void)nativeAdDidLoad:(HXNativeAd *)nativeAd {
    NSLog(@"[CustomRenderNativeAd] 广告加载成功");
    
    self.loadButton.enabled = YES;
    self.statusLabel.text = @"加载成功，正在渲染...";
    self.statusLabel.textColor = [UIColor colorWithRed:0.2 green:0.7 blue:0.3 alpha:1.0];
    
    // 获取自渲染数据
    HXNativeAdRenderData *renderData = nativeAd.renderData;
    if (!renderData) {
        self.statusLabel.text = @"渲染数据为空";
        self.statusLabel.textColor = [UIColor redColor];
        return;
    }
    
    NSLog(@"[CustomRenderNativeAd] 渲染数据: title=%@, desc=%@, isVideoAd=%@, interactionType=%ld",
          renderData.title, renderData.desc, renderData.isVideoAd ? @"YES" : @"NO", (long)renderData.interactionType);
    
    // 构建自渲染 UI
    [self buildCustomAdViewWithData:renderData];
    
    // 绑定视图给 SDK
    HXNativeAdCustomViews *customViews = [[HXNativeAdCustomViews alloc] init];
    customViews.titleLabel = self.titleLabel;
    customViews.descLabel = self.descLabel;
    customViews.mainImageView = self.mainImageView;
    customViews.iconImageView = self.iconImageView;
    customViews.actionButton = self.ctaButton;
    customViews.adBadgeView = self.adBadgeContainer;        // 合规必须
    customViews.interactionHintView = self.interactionHintView;
    customViews.closeButton = self.closeButton;
    customViews.clickableView = self.customAdView;         // 整个广告区域可点击
    
    if (renderData.isVideoAd) {
        customViews.videoContainerView = self.videoContainerView;
    }
    
    [nativeAd bindCustomViews:customViews
                    container:self.customAdView
           rootViewController:self];
    
    self.statusLabel.text = @"渲染完成，等待曝光...";
}

- (void)nativeAd:(HXNativeAd *)nativeAd didFailWithError:(NSError *)error {
    NSLog(@"[CustomRenderNativeAd] 广告加载失败: %@", error.localizedDescription);
    
    self.loadButton.enabled = YES;
    self.statusLabel.text = [NSString stringWithFormat:@"加载失败: %@", error.localizedDescription];
    self.statusLabel.textColor = [UIColor redColor];
}

- (void)nativeAdDidExpose:(HXNativeAd *)nativeAd {
    NSLog(@"[CustomRenderNativeAd] 广告曝光");
    self.statusLabel.text = @"广告已曝光";
    self.statusLabel.textColor = [UIColor colorWithRed:0.2 green:0.7 blue:0.3 alpha:1.0];
}

- (void)nativeAdDidClick:(HXNativeAd *)nativeAd {
    NSLog(@"[CustomRenderNativeAd] 广告点击");
    self.statusLabel.text = @"广告被点击";
}

- (void)nativeAdDidClose:(HXNativeAd *)nativeAd {
    NSLog(@"[CustomRenderNativeAd] 广告关闭");
    self.statusLabel.text = @"广告已关闭";
    
    [self.customAdView removeFromSuperview];
    self.customAdView = nil;
    self.nativeAd = nil;
}

- (void)nativeAd:(HXNativeAd *)nativeAd didCalculateRecommendedHeight:(CGFloat)recommendedHeight {
    NSLog(@"[CustomRenderNativeAd] 推荐高度: %.1f", recommendedHeight);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
