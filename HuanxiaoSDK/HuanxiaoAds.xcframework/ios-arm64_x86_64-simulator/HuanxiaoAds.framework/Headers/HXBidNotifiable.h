//
//  HXBidNotifiable.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  竞价结果通知协议
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 竞价失败原因

/**
 * @enum HXBidLossReason
 * @brief 竞价失败原因码
 *
 * @constant HXBidLossReasonPriceFilter       1001 底价过滤
 * @constant HXBidLossReasonLowBid            1002 bid 价格低于最高价
 * @constant HXBidLossReasonBlacklistFilter   1003 素材黑名单过滤
 * @constant HXBidLossReasonCompeteFilter     1004 竞品过滤
 * @constant HXBidLossReasonTimeout           1005 超时过滤
 * @constant HXBidLossReasonOther             1006 其它
 */
typedef NS_ENUM(NSInteger, HXBidLossReason) {
    HXBidLossReasonPriceFilter     = 1001,
    HXBidLossReasonLowBid          = 1002,
    HXBidLossReasonBlacklistFilter = 1003,
    HXBidLossReasonCompeteFilter   = 1004,
    HXBidLossReasonTimeout         = 1005,
    HXBidLossReasonOther           = 1006,
};

#pragma mark - 竞价胜出者

/**
 * @brief 竞价胜出者标识
 *
 * CSJ      穿山甲/头条
 * GDT      优量汇/广点通
 * KUAISHOU 快手
 * BAIDU    百青藤/百度
 * SIGMOB   Sigmob
 * OPPO     OPPO
 * VIVO     vivo
 * HUAWEI   华为
 * XIAOMI   小米
 * TAKU     Taku
 * JD       京东
 * OTHER    其他
 */
extern NSString *const kHXWinBidderCSJ;
extern NSString *const kHXWinBidderGDT;
extern NSString *const kHXWinBidderKUAISHOU;
extern NSString *const kHXWinBidderBAIDU;
extern NSString *const kHXWinBidderSIGMOB;
extern NSString *const kHXWinBidderOPPO;
extern NSString *const kHXWinBidderVIVO;
extern NSString *const kHXWinBidderHUAWEI;
extern NSString *const kHXWinBidderXIAOMI;
extern NSString *const kHXWinBidderTAKU;
extern NSString *const kHXWinBidderJD;
extern NSString *const kHXWinBidderOTHER;

#pragma mark - 竞价结果通知协议

/**
 * @protocol HXBidNotifiable
 * @brief 竞价结果通知协议
 *
 * @discussion
 * 聚合平台会回调竞价结果（胜出/失败）。
 * 媒体应调用此协议方法通知 SDK。
 *
 * 支持的广告类型：开屏、信息流、插屏、激励视频。
 */
@protocol HXBidNotifiable <NSObject>

/**
 * @brief 通知 SDK 竞价胜出
 *
 * @param price       结算价格（分/CPM）
 * @param secondPrice 二次出价（分/CPM），无则传 0
 */
- (void)sendWinNotificationWithPrice:(NSUInteger)price
                         secondPrice:(NSUInteger)secondPrice;

/**
 * @brief 通知 SDK 竞价失败
 *
 * @param lossReason   失败原因码，参见 @c HXBidLossReason
 * @param winnerBidder 胜出方标识，参见 @c kHXWinBidder* 常量，未知可传 nil
 * @param winnerPrice  胜出方出价（分/CPM），未知传 0
 */
- (void)sendLossNotificationWithLossReason:(HXBidLossReason)lossReason
                               winnerBidder:(nullable NSString *)winnerBidder
                               winnerPrice:(NSUInteger)winnerPrice;

@end

NS_ASSUME_NONNULL_END
