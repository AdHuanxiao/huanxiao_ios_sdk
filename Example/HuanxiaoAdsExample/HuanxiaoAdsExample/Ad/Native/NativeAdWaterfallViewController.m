//
//  NativeAdWaterfallViewController.m
//  HuanxiaoAdsExample
//
//  信息流广告瀑布流展示示例
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

#import "NativeAdWaterfallViewController.h"
#import <HuanxiaoAds/HuanxiaoAds.h>

#pragma mark - 瀑布流布局

@interface HXWaterfallLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) NSInteger numberOfColumns;
@property (nonatomic, assign) CGFloat columnSpacing;
@property (nonatomic, assign) CGFloat rowSpacing;
@property (nonatomic, copy) CGFloat (^heightForItemAtIndexPath)(NSIndexPath *indexPath, CGFloat width);
@end

@interface HXWaterfallLayout ()
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *attributesArray;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *columnHeights;
@end

@implementation HXWaterfallLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _numberOfColumns = 2;
        _columnSpacing = 10;
        _rowSpacing = 10;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.attributesArray = [NSMutableArray array];
    self.columnHeights = [NSMutableArray array];
    
    // 初始化列高度
    for (NSInteger i = 0; i < self.numberOfColumns; i++) {
        [self.columnHeights addObject:@(self.sectionInset.top)];
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat totalWidth = self.collectionView.bounds.size.width - self.sectionInset.left - self.sectionInset.right;
    CGFloat itemWidth = (totalWidth - (self.numberOfColumns - 1) * self.columnSpacing) / self.numberOfColumns;
    
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        // 找到最短的列
        NSInteger shortestColumn = 0;
        CGFloat minHeight = [self.columnHeights[0] floatValue];
        for (NSInteger j = 1; j < self.numberOfColumns; j++) {
            if ([self.columnHeights[j] floatValue] < minHeight) {
                minHeight = [self.columnHeights[j] floatValue];
                shortestColumn = j;
            }
        }
        
        CGFloat x = self.sectionInset.left + shortestColumn * (itemWidth + self.columnSpacing);
        CGFloat y = [self.columnHeights[shortestColumn] floatValue];
        CGFloat height = 200; // 默认高度
        
        if (self.heightForItemAtIndexPath) {
            height = self.heightForItemAtIndexPath(indexPath, itemWidth);
        }
        
        attributes.frame = CGRectMake(x, y, itemWidth, height);
        [self.attributesArray addObject:attributes];
        
        // 更新列高度
        self.columnHeights[shortestColumn] = @(y + height + self.rowSpacing);
    }
}

- (CGSize)collectionViewContentSize {
    CGFloat maxHeight = 0;
    for (NSNumber *height in self.columnHeights) {
        if ([height floatValue] > maxHeight) {
            maxHeight = [height floatValue];
        }
    }
    return CGSizeMake(self.collectionView.bounds.size.width, maxHeight + self.sectionInset.bottom);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *visibleAttributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in self.attributesArray) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [visibleAttributes addObject:attributes];
        }
    }
    return visibleAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < self.attributesArray.count) {
        return self.attributesArray[indexPath.item];
    }
    return nil;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return !CGSizeEqualToSize(self.collectionView.bounds.size, newBounds.size);
}

@end

#pragma mark - 瀑布流 Cell

@interface HXWaterfallCell : UICollectionViewCell
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HXWaterfallCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 8;
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOpacity = 0.1;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowRadius = 4;
    self.containerView.clipsToBounds = NO;
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.containerView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.imageView.layer.cornerRadius = 8;
    self.imageView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.imageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    self.titleLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        
        [self.imageView.topAnchor constraintEqualToAnchor:self.containerView.topAnchor],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor],
        [self.imageView.heightAnchor constraintEqualToAnchor:self.containerView.heightAnchor multiplier:0.7],
        
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:8],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.containerView.leadingAnchor constant:8],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.containerView.trailingAnchor constant:-8],
    ]];
}

- (void)configureWithTitle:(NSString *)title imageColor:(UIColor *)color {
    self.titleLabel.text = title;
    self.imageView.backgroundColor = color;
}

@end

#pragma mark - 广告 Cell

@interface HXWaterfallAdCell : UICollectionViewCell
@property (nonatomic, strong) UIView *adContainerView;
@end

@implementation HXWaterfallAdCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.adContainerView = [[UIView alloc] init];
    self.adContainerView.backgroundColor = [UIColor whiteColor];
    self.adContainerView.layer.cornerRadius = 8;
    self.adContainerView.clipsToBounds = YES;
    self.adContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.adContainerView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.adContainerView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.adContainerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.adContainerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.adContainerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
    ]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    for (UIView *subview in self.adContainerView.subviews) {
        [subview removeFromSuperview];
    }
}

- (void)configureWithAdView:(UIView *)adView {
    // 清除旧视图
    for (UIView *subview in self.adContainerView.subviews) {
        [subview removeFromSuperview];
    }
    
    if (adView) {
        adView.translatesAutoresizingMaskIntoConstraints = NO;
        adView.layer.cornerRadius = 8;
        adView.clipsToBounds = YES;
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

@interface HXWaterfallItem : NSObject
@property (nonatomic, assign) BOOL isAd;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) HXNativeAd *nativeAd;
@end

@implementation HXWaterfallItem
@end

#pragma mark - ViewController

static NSString * const kAdSpotID = @"1009";

@interface NativeAdWaterfallViewController () <UICollectionViewDelegate, UICollectionViewDataSource, HXNativeAdDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) HXWaterfallLayout *waterfallLayout;
@property (nonatomic, strong) NSMutableArray<HXWaterfallItem *> *items;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation NativeAdWaterfallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadInitialData];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    self.title = @"信息流瀑布流";
    
    // 状态标签
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.statusLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.text = @"";
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.statusLabel];
    
    // 瀑布流布局
    self.waterfallLayout = [[HXWaterfallLayout alloc] init];
    self.waterfallLayout.numberOfColumns = 2;
    self.waterfallLayout.columnSpacing = 10;
    self.waterfallLayout.rowSpacing = 10;
    self.waterfallLayout.sectionInset = UIEdgeInsetsMake(10, 16, 10, 16);
    
    __weak typeof(self) weakSelf = self;
    self.waterfallLayout.heightForItemAtIndexPath = ^CGFloat(NSIndexPath *indexPath, CGFloat width) {
        if (indexPath.item < weakSelf.items.count) {
            return weakSelf.items[indexPath.item].height;
        }
        return 200;
    };
    
    // CollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.waterfallLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView registerClass:[HXWaterfallCell class] forCellWithReuseIdentifier:@"HXWaterfallCell"];
    [self.collectionView registerClass:[HXWaterfallAdCell class] forCellWithReuseIdentifier:@"HXWaterfallAdCell"];
    [self.view addSubview:self.collectionView];
    
    // 下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.collectionView.refreshControl = self.refreshControl;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:8],
        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:16],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-16],
        
        [self.collectionView.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:8],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (void)loadInitialData {
    self.items = [NSMutableArray array];
    
    // 模拟内容数据
    NSArray *titles = @[
        @"春日踏青好去处",
        @"美食推荐：家常菜",
        @"旅行必备清单",
        @"健身小技巧",
        @"读书笔记分享",
        @"摄影构图指南",
        @"生活小妙招",
        @"音乐推荐",
        @"电影观后感",
        @"手工DIY教程",
        @"宠物日常",
        @"穿搭灵感",
        @"咖啡品鉴入门",
        @"周末露营攻略",
        @"数码产品评测",
        @"居家收纳技巧",
        @"护肤心得分享",
        @"烘焙新手教程",
        @"游戏攻略大全",
        @"职场干货分享",
        @"投资理财入门",
        @"健康饮食指南",
        @"家居装修灵感",
        @"亲子活动推荐",
        @"园艺种植技巧",
        @"汽车保养知识",
        @"瑜伽冥想入门",
        @"书法练习分享",
        @"绘画创作日记",
        @"户外徒步路线",
        @"美妆技巧教程",
        @"二手好物推荐",
        @"学习方法论",
        @"情绪管理技巧",
        @"睡眠改善方案",
        @"时间管理心得",
        @"社交技巧分享",
        @"语言学习打卡",
        @"科技新闻速递",
        @"艺术展览推荐",
    ];
    
    NSArray *colors = @[
        [UIColor colorWithRed:0.95 green:0.77 blue:0.77 alpha:1.0],
        [UIColor colorWithRed:0.77 green:0.95 blue:0.77 alpha:1.0],
        [UIColor colorWithRed:0.77 green:0.77 blue:0.95 alpha:1.0],
        [UIColor colorWithRed:0.95 green:0.95 blue:0.77 alpha:1.0],
        [UIColor colorWithRed:0.95 green:0.77 blue:0.95 alpha:1.0],
        [UIColor colorWithRed:0.77 green:0.95 blue:0.95 alpha:1.0],
        [UIColor colorWithRed:0.88 green:0.85 blue:0.95 alpha:1.0],
        [UIColor colorWithRed:0.95 green:0.88 blue:0.77 alpha:1.0],
        [UIColor colorWithRed:0.77 green:0.88 blue:0.95 alpha:1.0],
        [UIColor colorWithRed:0.85 green:0.95 blue:0.85 alpha:1.0],
    ];
    
    // 随机间隔插入广告
    NSInteger contentCountSinceLastAd = 0;
    NSInteger nextAdInterval = 4 + arc4random_uniform(4);
    
    for (NSInteger i = 0; i < titles.count; i++) {
        HXWaterfallItem *item = [[HXWaterfallItem alloc] init];
        item.isAd = NO;
        item.title = titles[i];
        item.color = colors[i % colors.count];
        // 随机高度
        item.height = 180 + arc4random_uniform(100);
        [self.items addObject:item];
        
        contentCountSinceLastAd++;
        
        // 达到随机间隔后插入广告位
        if (contentCountSinceLastAd >= nextAdInterval && i < titles.count - 1) {
            HXWaterfallItem *adItem = [[HXWaterfallItem alloc] init];
            adItem.isAd = YES;
            adItem.height = 250; // 广告默认高度
            [self.items addObject:adItem];
            
            // 重置计数并生成下一个随机间隔
            contentCountSinceLastAd = 0;
            nextAdInterval = 4 + arc4random_uniform(4);
        }
    }
    
    [self.collectionView reloadData];
    
    // 加载广告
    [self loadAds];
}

- (void)refreshData {
    // 清除旧广告
    for (HXWaterfallItem *item in self.items) {
        if (item.isAd && item.nativeAd) {
            [item.nativeAd close];
            item.nativeAd = nil;
        }
    }
    
    [self loadInitialData];
    [self.refreshControl endRefreshing];
}

- (void)loadAds {
    [self updateStatus:@"正在加载广告..." color:[UIColor colorWithRed:0.95 green:0.6 blue:0.1 alpha:1.0]];
    
    CGFloat adWidth = (self.view.bounds.size.width - 16 * 2 - 10) / 2; // 瀑布流单列宽度
    
    for (HXWaterfallItem *item in self.items) {
        if (item.isAd && !item.nativeAd) {
            HXNativeAd *nativeAd = [[HXNativeAd alloc] initWithAdSpotID:kAdSpotID size:CGSizeMake(adWidth, 0)];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXWaterfallItem *item = self.items[indexPath.item];
    
    if (item.isAd) {
        HXWaterfallAdCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXWaterfallAdCell" forIndexPath:indexPath];
        if (item.nativeAd && item.nativeAd.adView) {
            [cell configureWithAdView:item.nativeAd.adView];
        }
        return cell;
    } else {
        HXWaterfallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXWaterfallCell" forIndexPath:indexPath];
        [cell configureWithTitle:item.title imageColor:item.color];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HXWaterfallItem *item = self.items[indexPath.item];
    if (!item.isAd) {
        NSLog(@"[Waterfall] 点击内容: %@", item.title);
    }
}

#pragma mark - HXNativeAdDelegate

- (void)nativeAdDidLoad:(HXNativeAd *)nativeAd {
    [self updateStatus:@"广告加载成功" color:[UIColor colorWithRed:0.2 green:0.78 blue:0.35 alpha:1.0]];
    
    // 找到对应的 item 并更新
    for (NSInteger i = 0; i < self.items.count; i++) {
        HXWaterfallItem *item = self.items[i];
        if (item.nativeAd == nativeAd) {
            // 更新广告高度
            UIView *adView = nativeAd.adView;
            if (adView) {
                item.height = adView.frame.size.height;
            }
            
            // 刷新对应的 cell
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.collectionViewLayout invalidateLayout];
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
            });
            break;
        }
    }
}

- (void)nativeAd:(HXNativeAd *)nativeAd didFailWithError:(NSError *)error {
    [self updateStatus:[NSString stringWithFormat:@"广告加载失败: %@", error.localizedDescription] color:[UIColor colorWithRed:1.0 green:0.23 blue:0.19 alpha:1.0]];
}

- (void)nativeAdDidExpose:(HXNativeAd *)nativeAd {
    NSLog(@"[Waterfall] 广告已曝光");
}

- (void)nativeAdDidClick:(HXNativeAd *)nativeAd {
    NSLog(@"[Waterfall] 广告被点击");
}

- (void)nativeAdDidClose:(HXNativeAd *)nativeAd {
    // 找到并移除关闭的广告
    for (NSInteger i = 0; i < self.items.count; i++) {
        HXWaterfallItem *item = self.items[i];
        if (item.nativeAd == nativeAd) {
            [self.items removeObjectAtIndex:i];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
            });
            break;
        }
    }
}

- (void)nativeAd:(HXNativeAd *)nativeAd didCalculateRecommendedHeight:(CGFloat)recommendedHeight {
    // 找到对应的 item 并更新高度
    for (NSInteger i = 0; i < self.items.count; i++) {
        HXWaterfallItem *item = self.items[i];
        if (item.nativeAd == nativeAd) {
            item.height = recommendedHeight;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.collectionViewLayout invalidateLayout];
                [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
            });
            break;
        }
    }
}

- (void)dealloc {
    // 清理广告
    for (HXWaterfallItem *item in self.items) {
        if (item.isAd && item.nativeAd) {
            [item.nativeAd close];
        }
    }
}

@end
