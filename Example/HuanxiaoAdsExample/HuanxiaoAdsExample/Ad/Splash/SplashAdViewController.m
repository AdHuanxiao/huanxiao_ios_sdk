//
//  SplashAdViewController.m
//  HuanxiaoAdsExample
//

#import "SplashAdViewController.h"
#import "HXAdConfigCell.h"
#import <HuanxiaoAds/HuanxiaoAds.h>

@interface SplashAdViewController () <UITableViewDelegate, UITableViewDataSource, HXSplashAdDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *adSpotIDField;
@property (nonatomic, strong) HXSplashAd *splashAd;
@property (nonatomic, strong) UILabel *statusLabel;
// 连续展示相关
@property (nonatomic, strong) NSMutableArray<HXSplashAd *> *splashAdQueue;
@property (nonatomic, assign) NSInteger currentAdIndex;
@property (nonatomic, assign) BOOL isContinuousMode;
@property (nonatomic, assign) NSInteger loadedAdCount;
@property (nonatomic, assign) NSInteger totalAdCount;
@property (nonatomic, assign) BOOL isVideoMuted;
@end

@implementation SplashAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isVideoMuted = YES;   //默认静音播放
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
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[HXAdConfigInputCell class] forCellReuseIdentifier:@"HXAdConfigInputCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ActionCell"];
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.tableView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:8],
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
    
    [self updateStatus:@"正在加载..." color:[self colorLoading]];
    
    self.splashAd = [[HXSplashAd alloc] initWithAdSpotID:adSpotID];
    self.splashAd.delegate = self;
    self.splashAd.videoMuted = self.isVideoMuted;
    [self.splashAd loadAd];
}

- (void)showAd {
    if (!self.splashAd || !self.splashAd.isAdValid) {
        [self updateStatus:@"请先加载广告" color:[self colorError]];
        return;
    }
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [self.splashAd showInWindow:window];
}

- (void)loadAndShowAd {
    [self dismissKeyboard];
    NSString *adSpotID = self.adSpotIDField.text;
    if (adSpotID.length == 0) {
        [self updateStatus:@"请输入广告位 ID" color:[self colorError]];
        return;
    }
    
    [self updateStatus:@"正在加载..." color:[self colorLoading]];
    
    self.splashAd = [[HXSplashAd alloc] initWithAdSpotID:adSpotID];
    self.splashAd.delegate = self;
    self.splashAd.videoMuted = self.isVideoMuted;
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [self.splashAd loadAndShowInWindow:window];
}

- (void)loadAndShowAdWithBottomLogo {
    [self dismissKeyboard];
    NSString *adSpotID = self.adSpotIDField.text;
    if (adSpotID.length == 0) {
        [self updateStatus:@"请输入广告位 ID" color:[self colorError]];
        return;
    }
    
    [self updateStatus:@"正在加载..." color:[self colorLoading]];
    
    self.splashAd = [[HXSplashAd alloc] initWithAdSpotID:adSpotID];
    self.splashAd.delegate = self;
    self.splashAd.videoMuted = self.isVideoMuted;
    
    // 创建底部 Logo 视图
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    // 获取 App Icon
    UIImage *appIcon = nil;
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSArray *iconFiles = infoPlist[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    if (iconFiles.count > 0) {
        appIcon = [UIImage imageNamed:iconFiles.lastObject];
    }
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:appIcon];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    logoImageView.layer.cornerRadius = 12;
    logoImageView.clipsToBounds = YES;
    logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomView addSubview:logoImageView];
    
    // 获取 App 名称
    NSString *appName = infoPlist[@"CFBundleDisplayName"] ?: infoPlist[@"CFBundleName"] ?: @"";
    
    UILabel *logoLabel = [[UILabel alloc] init];
    logoLabel.text = appName;
    logoLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    logoLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
    logoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomView addSubview:logoLabel];
    
    // 容器视图用于整体居中
    UIView *containerView = [[UIView alloc] init];
    containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [bottomView addSubview:containerView];
    
    [logoImageView removeFromSuperview];
    [logoLabel removeFromSuperview];
    [containerView addSubview:logoImageView];
    [containerView addSubview:logoLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        // 容器整体居中
        [containerView.centerXAnchor constraintEqualToAnchor:bottomView.centerXAnchor],
        [containerView.centerYAnchor constraintEqualToAnchor:bottomView.centerYAnchor],
        
        // Logo 在容器顶部居中
        [logoImageView.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [logoImageView.topAnchor constraintEqualToAnchor:containerView.topAnchor],
        [logoImageView.widthAnchor constraintEqualToConstant:60],
        [logoImageView.heightAnchor constraintEqualToConstant:60],
        
        // Label 在 Logo 下方居中
        [logoLabel.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor],
        [logoLabel.topAnchor constraintEqualToAnchor:logoImageView.bottomAnchor constant:10],
        [logoLabel.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
    ]];
    
    self.splashAd.bottomView = bottomView;
    self.splashAd.bottomViewHeight = 180;
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [self.splashAd loadAndShowInWindow:window];
}

- (void)loadAndShowContinuousAds {
    [self dismissKeyboard];
    NSString *adSpotID = self.adSpotIDField.text;
    if (adSpotID.length == 0) {
        [self updateStatus:@"请输入广告位 ID" color:[self colorError]];
        return;
    }
    
    // 初始化连续展示状态
    self.isContinuousMode = YES;
    self.currentAdIndex = 0;
    self.loadedAdCount = 0;
    self.totalAdCount = 3;
    self.splashAdQueue = [NSMutableArray arrayWithCapacity:self.totalAdCount];
    
    [self updateStatus:@"正在加载 3 个广告..." color:[self colorLoading]];
    
    // 创建并加载 3 个广告
    for (NSInteger i = 0; i < self.totalAdCount; i++) {
        HXSplashAd *ad = [[HXSplashAd alloc] initWithAdSpotID:adSpotID];
        ad.delegate = self;
        ad.videoMuted = self.isVideoMuted;
        [self.splashAdQueue addObject:ad];
        [ad loadAd];
    }
}

- (void)showNextAdInQueue {
    if (self.currentAdIndex >= self.splashAdQueue.count) {
        // 所有广告已展示完毕
        self.isContinuousMode = NO;
        [self updateStatus:@"连续展示完成" color:[self colorSuccess]];
        [self.splashAdQueue removeAllObjects];
        return;
    }
    
    HXSplashAd *nextAd = self.splashAdQueue[self.currentAdIndex];
    if (nextAd.isAdValid) {
        [self updateStatus:[NSString stringWithFormat:@"正在展示第 %ld/%ld 个广告", (long)(self.currentAdIndex + 1), (long)self.totalAdCount] color:[self colorLoading]];
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        [nextAd showInWindow:window];
    } else {
        // 当前广告无效，跳到下一个
        self.currentAdIndex++;
        [self showNextAdInQueue];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HXAdConfigInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXAdConfigInputCell" forIndexPath:indexPath];
            [cell configureWithTitle:@"广告位 ID" placeholder:@"请输入开屏广告位 ID" text:@""];
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
            cell.textLabel.text = @"展示广告";
            break;
        case 2:
            cell.textLabel.text = @"加载并展示广告";
            break;
        case 3:
            cell.textLabel.text = @"加载并展示（带底部 Logo）";
            break;
        case 4:
            cell.textLabel.text = @"开屏广告连续触发（3个）";
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"基础配置" : @"操作";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"请在 Huanxiao开发者后台创建广告位获取 ID";
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
                [self showAd];
                break;
            case 2:
                [self loadAndShowAd];
                break;
            case 3:
                [self loadAndShowAdWithBottomLogo];
                break;
            case 4:
                [self loadAndShowContinuousAds];
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - HXSplashAdDelegate

// 广告加载成功
- (void)splashAdDidLoad:(HXSplashAd *)splashAd {
    if (self.isContinuousMode) {
        self.loadedAdCount++;
        [self updateStatus:[NSString stringWithFormat:@"已加载 %ld/%ld 个广告", (long)self.loadedAdCount, (long)self.totalAdCount] color:[self colorLoading]];
        
        // 所有广告加载完成后开始展示
        if (self.loadedAdCount >= self.totalAdCount) {
            [self updateStatus:@"全部加载完成，开始连续展示" color:[self colorSuccess]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showNextAdInQueue];
            });
        }
    } else {
        [self updateStatus:@"广告加载成功，可点击展示" color:[self colorSuccess]];
    }
}

// 广告加载失败
- (void)splashAd:(HXSplashAd *)splashAd didFailWithError:(NSError *)error {
    if (self.isContinuousMode) {
        self.loadedAdCount++;
        [self updateStatus:[NSString stringWithFormat:@"第 %ld 个广告加载失败: %@", (long)self.loadedAdCount, error.localizedDescription] color:[self colorError]];
        
        // 即使有广告加载失败，也尝试展示已加载成功的广告
        if (self.loadedAdCount >= self.totalAdCount) {
            BOOL hasValidAd = NO;
            for (HXSplashAd *ad in self.splashAdQueue) {
                if (ad.isAdValid) {
                    hasValidAd = YES;
                    break;
                }
            }
            if (hasValidAd) {
                [self updateStatus:@"部分广告加载完成，开始连续展示" color:[self colorLoading]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self showNextAdInQueue];
                });
            } else {
                self.isContinuousMode = NO;
                [self updateStatus:@"所有广告加载失败" color:[self colorError]];
                [self.splashAdQueue removeAllObjects];
            }
        }
    } else {
        [self updateStatus:[NSString stringWithFormat:@"加载失败: %@", error.localizedDescription] color:[self colorError]];
    }
}

// 广告即将曝光
- (void)splashAdWillExpose:(HXSplashAd *)splashAd {
    [self updateStatus:@"广告即将曝光" color:[self colorLoading]];
}

// 广告曝光成功
- (void)splashAdDidExpose:(HXSplashAd *)splashAd {
    [self updateStatus:@"广告已曝光" color:[self colorSuccess]];
}

// 广告展示失败
- (void)splashAd:(HXSplashAd *)splashAd didFailToShowWithError:(NSError *)error {
    [self updateStatus:[NSString stringWithFormat:@"展示失败: %@", error.localizedDescription] color:[self colorError]];
}

// 广告被点击
- (void)splashAdDidClick:(HXSplashAd *)splashAd {
    [self updateStatus:@"广告被点击" color:[self colorSuccess]];
}

// 跳过按钮被点击
- (void)splashAdDidClickSkip:(HXSplashAd *)splashAd {
    [self updateStatus:@"用户点击跳过" color:[self colorGray]];
}

// 广告即将关闭
- (void)splashAdWillClose:(HXSplashAd *)splashAd {
    [self updateStatus:@"广告即将关闭" color:[self colorLoading]];
}

// 广告已关闭
- (void)splashAdDidClose:(HXSplashAd *)splashAd {
    if (self.isContinuousMode) {
        [self updateStatus:[NSString stringWithFormat:@"第 %ld/%ld 个广告已关闭", (long)(self.currentAdIndex + 1), (long)self.totalAdCount] color:[self colorGray]];
        self.currentAdIndex++;
        // 延迟一小段时间后展示下一个广告
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showNextAdInQueue];
        });
    } else {
        [self updateStatus:@"广告已关闭" color:[self colorGray]];
        self.splashAd = nil;
    }
}

@end
