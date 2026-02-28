//
//  ViewController.m
//  HuanxiaoAdsExample
//
//  HuanxiaoAds SDK 官方示例
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

#import "ViewController.h"
#import "SplashAdViewController.h"
#import "InterstitialAdViewController.h"
#import "NativeAdViewController.h"
#import "NativeAdTableViewController.h"
#import "NativeAdWaterfallViewController.h"
#import "CustomRenderNativeAdViewController.h"
#import "RewardVideoAdViewController.h"
#import <HuanxiaoAds/HuanxiaoAds.h>

#pragma mark - 菜单项模型

@interface HXMenuItem : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, assign) BOOL showStatus;
@property (nonatomic, assign) BOOL isInitialized;
@property (nonatomic, strong) Class targetClass;
+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle iconName:(NSString *)iconName targetClass:(Class)targetClass;
+ (instancetype)statusItemWithTitle:(NSString *)title subtitle:(NSString *)subtitle;
@end

@implementation HXMenuItem
+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle iconName:(NSString *)iconName targetClass:(Class)targetClass {
    HXMenuItem *item = [[HXMenuItem alloc] init];
    item.title = title;
    item.subtitle = subtitle;
    item.iconName = iconName;
    item.targetClass = targetClass;
    item.showStatus = NO;
    return item;
}
+ (instancetype)statusItemWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    HXMenuItem *item = [[HXMenuItem alloc] init];
    item.title = title;
    item.subtitle = subtitle;
    item.showStatus = YES;
    return item;
}
@end

#pragma mark - 菜单单元格

@interface HXMenuCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *statusDot;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *arrowView;
@end

@implementation HXMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.titleLabel];
    
    // 副标题
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.font = [UIFont systemFontOfSize:13];
    self.subtitleLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.subtitleLabel];
    
    // 状态圆点
    self.statusDot = [[UIView alloc] init];
    self.statusDot.layer.cornerRadius = 4;
    self.statusDot.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusDot.hidden = YES;
    [self.contentView addSubview:self.statusDot];
    
    // 状态文字
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusLabel.hidden = YES;
    [self.contentView addSubview:self.statusLabel];
    
    // 箭头
    self.arrowView = [[UIImageView alloc] init];
    self.arrowView.image = [UIImage systemImageNamed:@"chevron.right"];
    self.arrowView.tintColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    self.arrowView.contentMode = UIViewContentModeScaleAspectFit;
    self.arrowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.arrowView];
    
    // 约束
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:14],
        
        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:4],
        [self.subtitleLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-14],
        
        [self.arrowView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.arrowView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.arrowView.widthAnchor constraintEqualToConstant:12],
        [self.arrowView.heightAnchor constraintEqualToConstant:16],
        
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.arrowView.leadingAnchor constant:-8],
        [self.statusLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        
        [self.statusDot.trailingAnchor constraintEqualToAnchor:self.statusLabel.leadingAnchor constant:-6],
        [self.statusDot.centerYAnchor constraintEqualToAnchor:self.statusLabel.centerYAnchor],
        [self.statusDot.widthAnchor constraintEqualToConstant:8],
        [self.statusDot.heightAnchor constraintEqualToConstant:8],
    ]];
}

- (void)configureWithItem:(HXMenuItem *)item {
    self.titleLabel.text = item.title;
    self.subtitleLabel.text = item.subtitle;
    
    if (item.showStatus) {
        self.statusDot.hidden = NO;
        self.statusLabel.hidden = NO;
        self.arrowView.hidden = YES;
        
        if (item.isInitialized) {
            self.statusDot.backgroundColor = [UIColor colorWithRed:0.2 green:0.78 blue:0.35 alpha:1.0];
            self.statusLabel.text = @"已初始化";
            self.statusLabel.textColor = [UIColor colorWithRed:0.2 green:0.78 blue:0.35 alpha:1.0];
        } else {
            self.statusDot.backgroundColor = [UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0];
            self.statusLabel.text = @"未初始化";
            self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0];
        }
    } else {
        self.statusDot.hidden = YES;
        self.statusLabel.hidden = YES;
        self.arrowView.hidden = NO;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor = highlighted ? [UIColor colorWithWhite:0.95 alpha:1.0] : [UIColor whiteColor];
}

@end

#pragma mark - ViewController

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<HXMenuItem *> *menuItems;
@property (nonatomic, strong) HXMenuItem *sdkStatusItem;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    [self setupData];
    [self setupTableView];
    
    // 监听 SDK 初始化完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSDKStatus)
                                                 name:@"HXAdsSDKDidInitializeNotification"
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateSDKStatus];
}

- (void)setupNavigation {
    self.title = @"Huanxiao SDK";
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = [UIColor whiteColor];
        appearance.shadowColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
        
        self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
    }
}

- (void)setupData {
    self.sdkStatusItem = [HXMenuItem statusItemWithTitle:@"SDK 初始化状态" subtitle:@"检查 SDK 是否正确初始化"];
    
    self.menuItems = @[
        self.sdkStatusItem,
        [HXMenuItem itemWithTitle:@"开屏广告" subtitle:@"Splash Ad - 应用启动时展示" iconName:@"rectangle.portrait" targetClass:[SplashAdViewController class]],
        [HXMenuItem itemWithTitle:@"插屏广告" subtitle:@"Interstitial Ad - 页面切换时展示" iconName:@"rectangle.center.inset.filled" targetClass:[InterstitialAdViewController class]],
        [HXMenuItem itemWithTitle:@"信息流广告" subtitle:@"Native Ad - 原生内容展示" iconName:@"list.bullet.rectangle" targetClass:[NativeAdViewController class]],
        [HXMenuItem itemWithTitle:@"信息流广告 (列表)" subtitle:@"Native Ad in TableView - 嵌入内容流展示" iconName:@"list.bullet" targetClass:[NativeAdTableViewController class]],
        [HXMenuItem itemWithTitle:@"信息流广告 (瀑布流)" subtitle:@"Native Ad Waterfall - 双列瀑布流展示" iconName:@"square.grid.2x2" targetClass:[NativeAdWaterfallViewController class]],
        [HXMenuItem itemWithTitle:@"自渲染信息流" subtitle:@"Custom Render Native Ad - 媒体自定义 UI" iconName:@"paintbrush" targetClass:[CustomRenderNativeAdViewController class]],
        [HXMenuItem itemWithTitle:@"激励视频广告" subtitle:@"Reward Video Ad - 观看获得奖励" iconName:@"play.rectangle" targetClass:[RewardVideoAdViewController class]],
    ];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[HXMenuCell class] forCellReuseIdentifier:@"HXMenuCell"];
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    // 添加 Footer
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    footerLabel.text = [NSString stringWithFormat:@"SDK Version: %@", [HXAdsSDK sdkVersion]];
    footerLabel.textAlignment = NSTextAlignmentCenter;
    footerLabel.font = [UIFont systemFontOfSize:12];
    footerLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    self.tableView.tableFooterView = footerLabel;
}

- (void)updateSDKStatus {
    self.sdkStatusItem.isInitialized = [HXAdsSDK sharedInstance].isInitialized;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1; // SDK 状态
    }
    return self.menuItems.count - 1; // 广告类型
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HXMenuCell" forIndexPath:indexPath];
    
    NSInteger itemIndex = (indexPath.section == 0) ? 0 : indexPath.row + 1;
    HXMenuItem *item = self.menuItems[itemIndex];
    [cell configureWithItem:item];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"状态";
    }
    return @"广告类型";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        // 点击 SDK 状态，刷新状态
        [self updateSDKStatus];
        return;
    }
    
    NSInteger itemIndex = indexPath.row + 1;
    HXMenuItem *item = self.menuItems[itemIndex];
    
    if (item.targetClass) {
        UIViewController *vc = [[item.targetClass alloc] init];
        vc.title = item.title;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
