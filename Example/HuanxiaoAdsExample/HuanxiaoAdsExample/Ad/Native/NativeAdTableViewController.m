//
//  NativeAdTableViewController.m
//  HuanxiaoAdsExample
//

#import "NativeAdTableViewController.h"
#import <HuanxiaoAds/HuanxiaoAds.h>

#pragma mark - 内容单元格

@interface HXContentCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@end

@implementation HXContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        self.titleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.titleLabel];
        
        self.coverImageView = [[UIImageView alloc] init];
        self.coverImageView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.coverImageView.layer.cornerRadius = 6;
        self.coverImageView.clipsToBounds = YES;
        self.coverImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.coverImageView];
        
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.font = [UIFont systemFontOfSize:13];
        self.contentLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.contentLabel];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.coverImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
            [self.coverImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12],
            [self.coverImageView.widthAnchor constraintEqualToConstant:100],
            [self.coverImageView.heightAnchor constraintEqualToConstant:70],
            [self.coverImageView.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor constant:-12],
            
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.coverImageView.leadingAnchor constant:-12],
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12],
            
            [self.contentLabel.leadingAnchor constraintEqualToAnchor:self.titleLabel.leadingAnchor],
            [self.contentLabel.trailingAnchor constraintEqualToAnchor:self.titleLabel.trailingAnchor],
            [self.contentLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8],
            [self.contentLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.contentView.bottomAnchor constant:-12],
        ]];
    }
    return self;
}

- (void)configureWithTitle:(NSString *)title content:(NSString *)content {
    self.titleLabel.text = title;
    self.contentLabel.text = content;
    self.coverImageView.backgroundColor = [UIColor colorWithHue:(arc4random() % 100) / 100.0 saturation:0.3 brightness:0.9 alpha:1.0];
}

@end

#pragma mark - 广告单元格

@interface HXNativeAdCell : UITableViewCell
@property (nonatomic, strong) UIView *adContainerView;
@property (nonatomic, strong) HXNativeAd *nativeAd;
@end

@implementation HXNativeAdCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.adContainerView = [[UIView alloc] init];
        self.adContainerView.backgroundColor = [UIColor whiteColor];
        self.adContainerView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:self.adContainerView];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.adContainerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
            [self.adContainerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:12],
            [self.adContainerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-12],
            [self.adContainerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        ]];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    for (UIView *subview in self.adContainerView.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)configureWithAdView:(UIView *)adView {
    for (UIView *subview in self.adContainerView.subviews) {
        [subview removeFromSuperview];
    }
    
    if (adView) {
        adView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.adContainerView addSubview:adView];
        [NSLayoutConstraint activateConstraints:@[
            [adView.topAnchor constraintEqualToAnchor:self.adContainerView.topAnchor],
            [adView.leadingAnchor constraintEqualToAnchor:self.adContainerView.leadingAnchor],
            [adView.trailingAnchor constraintEqualToAnchor:self.adContainerView.trailingAnchor],
            [adView.bottomAnchor constraintEqualToAnchor:self.adContainerView.bottomAnchor],
        ]];
    }
}

@end

#pragma mark - 数据模型

typedef NS_ENUM(NSInteger, HXFeedItemType) {
    HXFeedItemTypeContent,
    HXFeedItemTypeAd,
};

@interface HXFeedItem : NSObject
@property (nonatomic, assign) HXFeedItemType type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) HXNativeAd *nativeAd;
@property (nonatomic, assign) CGFloat adHeight;
@end

@implementation HXFeedItem
@end

#pragma mark - NativeAdTableViewController

@interface NativeAdTableViewController () <UITableViewDelegate, UITableViewDataSource, HXNativeAdDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<HXFeedItem *> *feedItems;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, copy) NSString *adSpotID;
@end

@implementation NativeAdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupData];
    [self loadAds];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    // 状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.text = @"正在加载广告...";
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView registerClass:[HXContentCell class] forCellReuseIdentifier:@"ContentCell"];
    [self.tableView registerClass:[HXNativeAdCell class] forCellReuseIdentifier:@"AdCell"];
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        
        [self.tableView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:8],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    // 刷新按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadAds)];
}

- (void)setupData {
    self.adSpotID = @"1010"; // 设置广告位 ID
    self.feedItems = [NSMutableArray array];
    
    // 模拟内容数据
    NSArray *titles = @[
        @"Swift 5.9 新特性解析：宏系统与性能优化",
        @"iOS 26 适配指南：隐私权限变更详解",
        @"SwiftUI 动画进阶：自定义转场效果",
        @"Core Data 与 SwiftData 迁移实践",
        @"Metal 3 图形渲染性能调优技巧",
        @"Combine 框架深度解析与实战应用",
        @"Widget 开发指南：从入门到精通",
        @"App Clip 最佳实践与用户体验优化",
        @"Xcode Cloud 持续集成完整指南",
        @"ARKit 6 新功能与场景理解技术",
        @"Vision Pro 开发入门：空间计算基础",
        @"性能监控与崩溃分析最佳实践",
    ];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        HXFeedItem *item = [[HXFeedItem alloc] init];
        item.type = HXFeedItemTypeContent;
        item.title = titles[i];
        item.content = @"技术资讯 · 5分钟阅读";
        [self.feedItems addObject:item];
        
        // 每隔 3 条内容插入一个广告位
        if ((i + 1) % 3 == 0 && i < titles.count - 1) {
            HXFeedItem *adItem = [[HXFeedItem alloc] init];
            adItem.type = HXFeedItemTypeAd;
            adItem.adHeight = 0; // 初始高度为 0，加载后更新
            [self.feedItems addObject:adItem];
        }
    }
}

- (void)loadAds {
    if (self.adSpotID.length == 0) {
        self.statusLabel.text = @"请在代码中设置广告位 ID";
        self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0];
        return;
    }
    
    self.statusLabel.text = @"正在加载广告...";
    self.statusLabel.textColor = [UIColor colorWithRed:0.95 green:0.6 blue:0.1 alpha:1.0];
    
    CGFloat adWidth = self.view.bounds.size.width - 12 * 2;
    
    for (HXFeedItem *item in self.feedItems) {
        if (item.type == HXFeedItemTypeAd) {
            // 清理旧广告
            if (item.nativeAd) {
                [item.nativeAd close];
                item.nativeAd = nil;
            }
            
            // 创建新广告
            HXNativeAd *nativeAd = [[HXNativeAd alloc] initWithAdSpotID:self.adSpotID size:CGSizeMake(adWidth, 0)];
            nativeAd.delegate = self;
            item.nativeAd = nativeAd;
            [nativeAd loadAd];
        }
    }
}

- (void)updateStatus:(NSString *)status color:(UIColor *)color {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text = status;
        self.statusLabel.textColor = color;
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.feedItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXFeedItem *item = self.feedItems[indexPath.row];
    
    if (item.type == HXFeedItemTypeAd) {
        HXNativeAdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdCell" forIndexPath:indexPath];
        if (item.nativeAd && item.nativeAd.adView) {
            [cell configureWithAdView:item.nativeAd.adView];
        }
        return cell;
    } else {
        HXContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
        [cell configureWithTitle:item.title content:item.content];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXFeedItem *item = self.feedItems[indexPath.row];
    if (item.type == HXFeedItemTypeAd) {
        return item.adHeight > 0 ? item.adHeight : 0.01; // 返回极小值避免空白
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HXFeedItem *item = self.feedItems[indexPath.row];
    if (item.type == HXFeedItemTypeAd) {
        return item.adHeight > 0 ? item.adHeight : 200;
    }
    return 94;
}

#pragma mark - HXNativeAdDelegate

- (void)nativeAdDidLoad:(HXNativeAd *)nativeAd {
    [self updateStatus:@"广告加载成功" color:[UIColor colorWithRed:0.2 green:0.78 blue:0.35 alpha:1.0]];
    
    // 找到对应的 item 并刷新
    for (NSInteger i = 0; i < self.feedItems.count; i++) {
        HXFeedItem *item = self.feedItems[i];
        if (item.nativeAd == nativeAd) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)nativeAd:(HXNativeAd *)nativeAd didFailWithError:(NSError *)error {
    [self updateStatus:[NSString stringWithFormat:@"加载失败: %@", error.localizedDescription] color:[UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0]];
}

- (void)nativeAdDidExpose:(HXNativeAd *)nativeAd {
    NSLog(@"信息流广告已曝光");
}

- (void)nativeAdDidClick:(HXNativeAd *)nativeAd {
    NSLog(@"信息流广告被点击");
}

- (void)nativeAdDidClose:(HXNativeAd *)nativeAd {
    // 找到对应的广告 item，重置状态（保留槽位，刷新时可重新加载）
    for (NSInteger i = 0; i < self.feedItems.count; i++) {
        HXFeedItem *item = self.feedItems[i];
        if (item.nativeAd == nativeAd) {
            [item.nativeAd close];
            item.nativeAd = nil;
            item.adHeight = 0;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

- (void)nativeAd:(HXNativeAd *)nativeAd didCalculateRecommendedHeight:(CGFloat)recommendedHeight {
    // 更新广告高度并刷新
    for (NSInteger i = 0; i < self.feedItems.count; i++) {
        HXFeedItem *item = self.feedItems[i];
        if (item.nativeAd == nativeAd) {
            item.adHeight = recommendedHeight;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

@end
