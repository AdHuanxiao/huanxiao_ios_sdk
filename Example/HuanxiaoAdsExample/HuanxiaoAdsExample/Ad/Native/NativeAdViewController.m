//
//  NativeAdViewController.m
//  HuanxiaoAdsExample
//

#import "NativeAdViewController.h"
#import "HXAdConfigCell.h"
#import <HuanxiaoAds/HuanxiaoAds.h>

@interface NativeAdViewController () <UITableViewDelegate, UITableViewDataSource, HXNativeAdDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *adSpotIDField;
@property (nonatomic, strong) HXNativeAd *nativeAd;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *adContainerView;
@property (nonatomic, strong) NSLayoutConstraint *adContainerHeightConstraint;
@property (nonatomic, assign) BOOL isVideoMuted;
@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isVideoMuted = YES;  // 信息流默认静音
    [self setupUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    // 状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    self.statusLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.text = @"等待操作";
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];
    
    // 广告容器
    self.adContainerView = [[UIView alloc] init];
    self.adContainerView.backgroundColor = [UIColor whiteColor];
    self.adContainerView.layer.cornerRadius = 12;
    self.adContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.adContainerView.layer.shadowOpacity = 0.1;
    self.adContainerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.adContainerView.layer.shadowRadius = 8;
    self.adContainerView.clipsToBounds = NO;
    self.adContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.adContainerView.hidden = YES;
    [self.view addSubview:self.adContainerView];
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[HXAdConfigInputCell class] forCellReuseIdentifier:@"HXAdConfigInputCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ActionCell"];
    [self.view addSubview:self.tableView];
    
    self.adContainerHeightConstraint = [self.adContainerView.heightAnchor constraintEqualToConstant:0];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.adContainerView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:12],
        [self.adContainerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.adContainerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        self.adContainerHeightConstraint,
        
        [self.tableView.topAnchor constraintEqualToAnchor:self.adContainerView.bottomAnchor constant:8],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (void)updateStatus:(NSString *)status color:(UIColor *)color {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = status;
        self.statusLabel.textColor = color;
    });
}

- (UIColor *)colorLoading {
    return [UIColor colorWithRed:0.95 green:0.6 blue:0.1 alpha:1.0];
}

- (UIColor *)colorSuccess {
    return [UIColor colorWithRed:0.2 green:0.78 blue:0.35 alpha:1.0];
}

- (UIColor *)colorError {
    return [UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0];
}

- (UIColor *)colorGray {
    return [UIColor colorWithWhite:0.5 alpha:1.0];
}

- (void)videoMuteSwitchChanged:(UISwitch *)sender {
    self.isVideoMuted = sender.isOn;
}

#pragma mark - Actions

- (void)loadAd {
    [self dismissKeyboard];
    NSString *adSpotID = self.adSpotIDField.text;
    if (adSpotID.length == 0) {
        [self updateStatus:@"请输入广告位 ID" color:[self colorError]];
        return;
    }
    
    // 清除之前的广告
    [self clearAd];
    
    [self updateStatus:@"正在加载..." color:[self colorLoading]];
    
    // 计算广告宽度
    CGFloat adWidth = self.view.bounds.size.width - 32;
    
    self.nativeAd = [[HXNativeAd alloc] initWithAdSpotID:adSpotID size:CGSizeMake(adWidth, 0)];
    self.nativeAd.delegate = self;
    self.nativeAd.videoMuted = self.isVideoMuted;
    [self.nativeAd loadAd];
}

- (void)clearAd {
    // 移除现有广告视图
    for (UIView *subview in self.adContainerView.subviews) {
        [subview removeFromSuperview];
    }
    self.adContainerView.hidden = YES;
    self.adContainerHeightConstraint.constant = 0;
    
    if (self.nativeAd) {
        [self.nativeAd close];
        self.nativeAd = nil;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HXAdConfigInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXAdConfigInputCell" forIndexPath:indexPath];
            [cell configureWithTitle:@"广告位 ID" placeholder:@"请输入信息流广告位 ID" text:@""];
            self.adSpotIDField = cell.textField;
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.textLabel.text = @"视频静音播放";
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch *muteSwitch = [[UISwitch alloc] init];
            muteSwitch.on = self.isVideoMuted;
            [muteSwitch addTarget:self action:@selector(videoMuteSwitchChanged:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = muteSwitch;
            return cell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActionCell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.47 blue:0.96 alpha:1.0];
    cell.textLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"加载广告";
            break;
        case 1:
            cell.textLabel.text = @"清除广告";
            cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0];
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"基础配置" : @"操作";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"信息流广告可融入内容流中展示，支持多种模板样式";
    }
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self loadAd];
                break;
            case 1:
                [self clearAd];
                [self updateStatus:@"广告已清除" color:[self colorGray]];
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - HXNativeAdDelegate

// 广告加载成功
- (void)nativeAdDidLoad:(HXNativeAd *)nativeAd {
    [self updateStatus:@"广告加载成功" color:[self colorSuccess]];
    
    // 获取广告视图并添加到容器
    UIView *adView = nativeAd.adView;
    if (adView) {
        self.adContainerView.hidden = NO;
        adView.translatesAutoresizingMaskIntoConstraints = NO;
        adView.layer.cornerRadius = 12;
        adView.clipsToBounds = YES;
        [self.adContainerView addSubview:adView];
        
        // 使用广告视图自身的尺寸（不强制拉伸）
        CGFloat adWidth = adView.frame.size.width;
        CGFloat adHeight = adView.frame.size.height;
        
        [NSLayoutConstraint activateConstraints:@[
            [adView.topAnchor constraintEqualToAnchor:self.adContainerView.topAnchor],
            [adView.centerXAnchor constraintEqualToAnchor:self.adContainerView.centerXAnchor],
            [adView.widthAnchor constraintEqualToConstant:adWidth],
            [adView.heightAnchor constraintEqualToConstant:adHeight],
        ]];
        
        // 直接使用广告视图的高度更新容器高度
        self.adContainerHeightConstraint.constant = adHeight;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

// 广告加载失败
- (void)nativeAd:(HXNativeAd *)nativeAd didFailWithError:(NSError *)error {
    [self updateStatus:[NSString stringWithFormat:@"加载失败: %@", error.localizedDescription] color:[self colorError]];
}

// 广告曝光成功
- (void)nativeAdDidExpose:(HXNativeAd *)nativeAd {
    [self updateStatus:@"广告已曝光" color:[self colorSuccess]];
}

// 广告被点击
- (void)nativeAdDidClick:(HXNativeAd *)nativeAd {
    [self updateStatus:@"广告被点击" color:[self colorSuccess]];
}

// 广告关闭
- (void)nativeAdDidClose:(HXNativeAd *)nativeAd {
    [self updateStatus:@"广告已关闭" color:[self colorGray]];
    [self clearAd];
}

// 推荐高度计算完成
- (void)nativeAd:(HXNativeAd *)nativeAd didCalculateRecommendedHeight:(CGFloat)recommendedHeight {
    NSLog(@"[NativeAd] 推荐高度: %.1f", recommendedHeight);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 更新容器高度
        self.adContainerHeightConstraint.constant = recommendedHeight;
        
        // 更新广告视图的高度约束
        UIView *adView = nativeAd.adView;
        if (adView && adView.superview == self.adContainerView) {
            for (NSLayoutConstraint *constraint in adView.constraints) {
                if (constraint.firstAttribute == NSLayoutAttributeHeight && constraint.firstItem == adView) {
                    constraint.constant = recommendedHeight;
                    break;
                }
            }
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    });
}

@end
