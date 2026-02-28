//
//  InterstitialAdViewController.m
//  HuanxiaoAdsExample
//

#import "InterstitialAdViewController.h"
#import "HXAdConfigCell.h"
#import <HuanxiaoAds/HuanxiaoAds.h>

@interface InterstitialAdViewController () <UITableViewDelegate, UITableViewDataSource, HXInterstitialAdDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *adSpotIDField;
@property (nonatomic, strong) HXInterstitialAd *interstitialAd;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, assign) BOOL shouldShowAfterLoad;
@property (nonatomic, assign) BOOL isVideoMuted;
@end

@implementation InterstitialAdViewController

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
    
    self.shouldShowAfterLoad = NO;
    self.interstitialAd = [[HXInterstitialAd alloc] initWithAdSpotID:adSpotID];
    self.interstitialAd.delegate = self;
    self.interstitialAd.videoMuted = self.isVideoMuted;
    [self.interstitialAd loadAd];
}

- (void)showAd {
    if (!self.interstitialAd || !self.interstitialAd.isAdValid) {
        [self updateStatus:@"请先加载广告" color:[self colorError]];
        return;
    }
    
    [self.interstitialAd showFromViewController:self];
}

- (void)loadAndShowAd {
    [self dismissKeyboard];
    NSString *adSpotID = self.adSpotIDField.text;
    if (adSpotID.length == 0) {
        [self updateStatus:@"请输入广告位 ID" color:[self colorError]];
        return;
    }
    
    [self updateStatus:@"正在加载..." color:[self colorLoading]];
    
    self.shouldShowAfterLoad = YES;
    self.interstitialAd = [[HXInterstitialAd alloc] initWithAdSpotID:adSpotID];
    self.interstitialAd.delegate = self;
    self.interstitialAd.videoMuted = self.isVideoMuted;
    [self.interstitialAd loadAd];
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
            [cell configureWithTitle:@"广告位 ID" placeholder:@"请输入插屏广告位 ID" text:@""];
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
        return @"插屏广告适合在页面切换、关卡结束等场景展示";
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

#pragma mark - HXInterstitialAdDelegate

// 广告加载成功
- (void)interstitialAdDidLoad:(HXInterstitialAd *)interstitialAd {
    if (self.shouldShowAfterLoad) {
        self.shouldShowAfterLoad = NO;
        [self updateStatus:@"广告加载成功，正在展示..." color:[self colorSuccess]];
        [interstitialAd showFromViewController:self];
    } else {
        [self updateStatus:@"广告加载成功，可点击展示" color:[self colorSuccess]];
    }
}

// 广告加载失败
- (void)interstitialAd:(HXInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    [self updateStatus:[NSString stringWithFormat:@"加载失败: %@", error.localizedDescription] color:[self colorError]];
}

// 广告即将曝光
- (void)interstitialAdWillExpose:(HXInterstitialAd *)interstitialAd {
    [self updateStatus:@"广告即将曝光" color:[self colorLoading]];
}

// 广告曝光成功
- (void)interstitialAdDidExpose:(HXInterstitialAd *)interstitialAd {
    [self updateStatus:@"广告已曝光" color:[self colorSuccess]];
}

// 广告展示失败
- (void)interstitialAd:(HXInterstitialAd *)interstitialAd didFailToShowWithError:(NSError *)error {
    [self updateStatus:[NSString stringWithFormat:@"展示失败: %@", error.localizedDescription] color:[self colorError]];
}

// 广告被点击
- (void)interstitialAdDidClick:(HXInterstitialAd *)interstitialAd {
    [self updateStatus:@"广告被点击" color:[self colorSuccess]];
}

// 关闭按钮被点击
- (void)interstitialAdDidClickClose:(HXInterstitialAd *)interstitialAd {
    [self updateStatus:@"用户点击关闭" color:[self colorGray]];
}

// 广告即将关闭
- (void)interstitialAdWillClose:(HXInterstitialAd *)interstitialAd {
    [self updateStatus:@"广告即将关闭" color:[self colorLoading]];
}

// 广告已关闭
- (void)interstitialAdDidClose:(HXInterstitialAd *)interstitialAd {
    [self updateStatus:@"广告已关闭" color:[self colorGray]];
    self.interstitialAd = nil;
}

@end
