//
//  HXAdsConfig.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  SDK 配置类
//

#import <Foundation/Foundation.h>
#import <HuanxiaoAds/HXAdsDefines.h>
#import <HuanxiaoAds/HXPrivacyConfig.h>

NS_ASSUME_NONNULL_BEGIN


@interface HXAdsConfig : NSObject <NSCopying>

#pragma mark - 必填参数

/**
 * @brief 应用 ID（必填）
 *
 * @discussion
 * 在 HuanxiaoAds 开发者后台创建应用后获取。
 * 每个应用对应唯一的 AppID，用于标识您的应用。
 */
@property (nonatomic, copy, readonly) NSString *appID;

#pragma mark - 可选配置

/**
 * @brief 隐私配置
 *
 * @discussion
 * 用于配置个性化广告、摇一摇、IDFA 等隐私相关设置。
 * 默认使用 `[HXPrivacyConfig defaultConfig]` 创建。
 *
 * @see HXPrivacyConfig
 */
@property (nonatomic, strong) HXPrivacyConfig *privacyConfig;

/**
 * @brief 测试模式开关
 *
 * @discussion
 * 开启后会输出详细的调试日志，便于开发调试。
 *
 * @warning 请在上线前关闭此选项，避免在生产环境输出日志。
 *
 * @default NO
 */
@property (nonatomic, assign) BOOL testMode;

/**
 * @brief 日志级别
 *
 * @discussion
 * 控制日志输出的详细程度。仅在 DEBUG 模式下有效。
 *
 * @default HXAdsLogLevelWarning
 *
 * @see HXAdsLogLevel
 */
@property (nonatomic, assign) HXAdsLogLevel logLevel;

#pragma mark - 初始化

/**
 * @brief 初始化配置对象
 *
 * @param appID 应用 ID（必填，不能为空）
 *
 * @return 配置对象实例，如果 appID 为空则返回 nil
 *
 * @code
 * HXAdsConfig *config = [[HXAdsConfig alloc] initWithAppID:@"YOUR_APP_ID"];
 * @endcode
 */
- (nullable instancetype)initWithAppID:(NSString *)appID;

/// 禁用默认初始化方法
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
