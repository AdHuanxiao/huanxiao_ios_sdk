//
//  RewardVideoAdViewController.m
//  HuanxiaoAdsExample
//

#import "RewardVideoAdViewController.h"
#import "HXAdConfigCell.h"
#import <HuanxiaoAds/HuanxiaoAds.h>

@interface RewardVideoAdViewController () <UITableViewDelegate, UITableViewDataSource, HXRewardVideoAdDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *adSpotIDField;
@property (nonatomic, strong) HXRewardVideoAd *rewardVideoAd;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic, assign) BOOL shouldShowAfterLoad;
@property (nonatomic, assign) BOOL isVideoMuted;
@end

@implementation RewardVideoAdViewController

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
    
    // 播放进度标签
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:UIFontWeightRegular];
    self.progressLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.text = @"";
    self.progressLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.progressLabel];
    
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
        
        [self.progressLabel.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:4],
        [self.progressLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.progressLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.tableView.topAnchor constraintEqualToAnchor:self.progressLabel.bottomAnchor constant:8],
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

- (void)updateProgress:(NSString *)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressLabel.text = progress;
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

- (UIColor *)colorReward {
    return [UIColor colorWithRed:1.0 green:0.58 blue:0.0 alpha:1.0];
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
    [self updateProgress:@""];
    
    self.shouldShowAfterLoad = NO;
    self.rewardVideoAd = [[HXRewardVideoAd alloc] initWithAdSpotID:adSpotID];
    self.rewardVideoAd.delegate = self;
    self.rewardVideoAd.videoMuted = self.isVideoMuted;
    [self.rewardVideoAd loadAd];
}

- (void)showAd {
    [self dismissKeyboard];
    if (!self.rewardVideoAd || !self.rewardVideoAd.isAdValid) {
        [self updateStatus:@"请先加载广告" color:[self colorError]];
        return;
    }
    
    [self updateStatus:@"正在展示..." color:[self colorLoading]];
    [self.rewardVideoAd showFromViewController:self];
}

- (void)loadAndShowAd {
    [self dismissKeyboard];
    NSString *adSpotID = self.adSpotIDField.text;
    if (adSpotID.length == 0) {
        [self updateStatus:@"请输入广告位 ID" color:[self colorError]];
        return;
    }
    
    [self updateStatus:@"正在加载..." color:[self colorLoading]];
    [self updateProgress:@""];
    
    self.shouldShowAfterLoad = YES;
    self.rewardVideoAd = [[HXRewardVideoAd alloc] initWithAdSpotID:adSpotID];
    self.rewardVideoAd.delegate = self;
    self.rewardVideoAd.videoMuted = self.isVideoMuted;
    [self.rewardVideoAd loadAd];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 2 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            HXAdConfigInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXAdConfigInputCell" forIndexPath:indexPath];
            [cell configureWithTitle:@"广告位 ID" placeholder:@"请输入激励视频广告位 ID" text:@""];
            cell.textField.text = @"7";
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
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? @"基础配置" : @"操作";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"用户观看完整视频后可获得奖励，适合游戏、积分场景";
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
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - HXRewardVideoAdDelegate - 加载

// 广告加载成功
- (void)rewardVideoAdDidLoad:(HXRewardVideoAd *)rewardVideoAd {
    if (self.shouldShowAfterLoad) {
        self.shouldShowAfterLoad = NO;
        [self updateStatus:@"加载成功，正在展示..." color:[self colorSuccess]];
        [rewardVideoAd showFromViewController:self];
    } else {
        [self updateStatus:@"广告加载成功，可点击展示" color:[self colorSuccess]];
    }
}

// 广告加载失败
- (void)rewardVideoAd:(HXRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    self.shouldShowAfterLoad = NO;
    [self updateStatus:[NSString stringWithFormat:@"加载失败: %@", error.localizedDescription] color:[self colorError]];
}

#pragma mark - HXRewardVideoAdDelegate - 展示

// 广告即将曝光
- (void)rewardVideoAdWillExpose:(HXRewardVideoAd *)rewardVideoAd {
    [self updateStatus:@"广告即将展示" color:[self colorLoading]];
}

// 广告曝光成功
- (void)rewardVideoAdDidExpose:(HXRewardVideoAd *)rewardVideoAd {
    [self updateStatus:@"广告已曝光" color:[self colorSuccess]];
}

// 广告展示失败
- (void)rewardVideoAd:(HXRewardVideoAd *)rewardVideoAd didFailToShowWithError:(NSError *)error {
    [self updateStatus:[NSString stringWithFormat:@"展示失败: %@", error.localizedDescription] color:[self colorError]];
}

#pragma mark - HXRewardVideoAdDelegate - 视频播放

// 视频开始播放
- (void)rewardVideoAdDidStartPlay:(HXRewardVideoAd *)rewardVideoAd {
    [self updateStatus:@"视频开始播放" color:[self colorSuccess]];
}

// 视频播放进度
- (void)rewardVideoAd:(HXRewardVideoAd *)rewardVideoAd playProgress:(CGFloat)progress currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    NSString *progressText = [NSString stringWithFormat:@"%.0f%% | %.1fs / %.1fs", progress * 100, currentTime, totalTime];
    [self updateProgress:progressText];
}

// 视频播放完成
- (void)rewardVideoAdDidPlayFinish:(HXRewardVideoAd *)rewardVideoAd {
    [self updateStatus:@"视频播放完成" color:[self colorSuccess]];
}

// 视频播放失败
- (void)rewardVideoAd:(HXRewardVideoAd *)rewardVideoAd didPlayFailWithError:(NSError *)error {
    [self updateStatus:[NSString stringWithFormat:@"播放失败: %@", error.localizedDescription] color:[self colorError]];
}

#pragma mark - HXRewardVideoAdDelegate - 奖励

// 用户获得奖励
- (void)rewardVideoAd:(HXRewardVideoAd *)rewardVideoAd didRewardWithInfo:(HXRewardInfo *)rewardInfo {
    if (rewardInfo.isValid) {
        NSString *rewardText = [NSString stringWithFormat:@"🎉 获得奖励: %@ x%ld", rewardInfo.rewardName, (long)rewardInfo.rewardAmount];
        [self updateStatus:rewardText color:[self colorReward]];
    } else {
        [self updateStatus:@"奖励无效" color:[self colorGray]];
    }
}

#pragma mark - HXRewardVideoAdDelegate - 交互

// 广告被点击
- (void)rewardVideoAdDidClick:(HXRewardVideoAd *)rewardVideoAd {
    [self updateStatus:@"广告被点击" color:[self colorSuccess]];
}

// 跳过按钮被点击
- (void)rewardVideoAdDidClickSkip:(HXRewardVideoAd *)rewardVideoAd {
    [self updateStatus:@"用户点击跳过" color:[self colorGray]];
}

#pragma mark - HXRewardVideoAdDelegate - 关闭

// 广告即将关闭
- (void)rewardVideoAdWillClose:(HXRewardVideoAd *)rewardVideoAd {
    // 即将关闭
}

// 广告已关闭
- (void)rewardVideoAdDidClose:(HXRewardVideoAd *)rewardVideoAd {
    [self updateStatus:@"广告已关闭" color:[self colorGray]];
    [self updateProgress:@""];
}

@end
