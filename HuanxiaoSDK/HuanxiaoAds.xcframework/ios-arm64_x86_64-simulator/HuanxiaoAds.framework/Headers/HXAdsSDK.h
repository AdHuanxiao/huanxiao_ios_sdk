//
//  HXAdsSDK.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  SDK 主入口类
//

#import <Foundation/Foundation.h>
#import <HuanxiaoAds/HXAdsDefines.h>
#import <HuanxiaoAds/HXAdsConfig.h>
#import <HuanxiaoAds/HXPrivacyConfig.h>

NS_ASSUME_NONNULL_BEGIN


@interface HXAdsSDK : NSObject

#pragma mark - 单例

/**
 * @brief 获取 SDK 单例实例
 * @return SDK 单例对象
 */
+ (instancetype)sharedInstance;

/// 禁用默认初始化方法
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#pragma mark - 属性

/**
 * @brief 当前 SDK 配置
 * @discussion 初始化成功后可读取，未初始化时为 nil
 */
@property (nonatomic, strong, readonly, nullable) HXAdsConfig *currentConfig;

/**
 * @brief SDK 初始化状态
 * @see HXAdsInitializationStatus
 */
@property (nonatomic, assign, readonly) HXAdsInitializationStatus initializationStatus;

/**
 * @brief 是否已成功初始化
 * @return YES: 已初始化成功，NO: 未初始化或初始化失败
 */
@property (nonatomic, assign, readonly, getter=isInitialized) BOOL initialized;

#pragma mark - 版本信息

/**
 * @brief 获取 SDK 版本号
 * @return 版本号字符串，如 "1.0.0"
 */
+ (NSString *)sdkVersion;

#pragma mark - 初始化

/**
 * @brief 使用 AppID 初始化 SDK
 *
 * @param appID 应用 ID（必填）
 * @param completion 初始化完成回调（主线程）
 *   - success: 是否成功
 *   - error: 失败时的错误信息
 *
 * @discussion
 * 使用默认配置初始化 SDK，适用于不需要自定义配置的场景。
 * 等同于使用默认 HXAdsConfig 调用 initializeWithConfig:completion:
 */
- (void)initializeWithAppID:(NSString *)appID
                 completion:(nullable HXAdsInitializationCompletionHandler)completion;


/**
 * @brief 初始化 SDK
 *
 * @param config SDK 配置对象，包含 AppID 和隐私设置
 * @param completion 初始化完成回调（主线程）
 *   - success: 是否成功
 *   - error: 失败时的错误信息
 *
 * @discussion
 * - 必须在使用任何广告功能前调用
 * - 建议在应用启动时（如 AppDelegate 的 didFinishLaunching）调用
 * - 重复调用时，如果已初始化成功则直接返回成功
 * - 初始化过程中会进行网络请求，请确保网络可用
 *
 * @warning AppID 为必填项，为空时将返回错误
 */
- (void)initializeWithConfig:(HXAdsConfig *)config
                  completion:(nullable HXAdsInitializationCompletionHandler)completion;


#pragma mark - 隐私设置

/**
 * @brief 设置个性化广告开关
 *
 * @param enabled YES: 允许个性化广告，NO: 禁用
 *
 * @discussion
 * 可在初始化后动态调整。设置为 NO 时，广告将不再基于用户行为进行个性化推荐。
 */
- (void)setPersonalizedAdEnabled:(BOOL)enabled;

/**
 * @brief 设置摇一摇广告交互开关
 *
 * @param enabled YES: 允许摇一摇，NO: 禁用
 *
 * @discussion
 * 可在初始化后动态调整。设置为 NO 时，广告将不支持摇一摇交互。
 */
- (void)setShakeEnabled:(BOOL)enabled;

#pragma mark - IDFA 管理

/**
 * @brief 设置 IDFA
 *
 * @param idfa IDFA 字符串，格式: 00000000-0000-0000-0000-000000000000
 *
 * @discussion
 * 如果您的应用已自行获取了 IDFA（通过 ATTrackingManager），可通过此方法传入。
 * SDK 将使用您提供的 IDFA 进行广告请求。
 *
 * @note 必须在 SDK 初始化成功后调用，否则设置无效
 *
 * @code
 * // 在获取到 IDFA 后设置
 * if (@available(iOS 14, *)) {
 *     [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
 *         if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
 *             NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
 *             [[HXAdsSDK sharedInstance] setIDFA:idfa];
 *         }
 *     }];
 * }
 * @endcode
 */
- (void)setIDFA:(nullable NSString *)idfa;

/**
 * @brief 获取当前设置的 IDFA
 * @return IDFA 字符串，未设置时返回 nil
 */
- (nullable NSString *)idfa;

#pragma mark - 日志控制

/**
 * @brief 设置日志级别
 *
 * @param logLevel 日志级别
 *
 * @discussion
 * 仅在 DEBUG 模式下有效，Release 版本不会输出任何日志。
 *
 * @see HXAdsLogLevel
 */
- (void)setLogLevel:(HXAdsLogLevel)logLevel;

@end

NS_ASSUME_NONNULL_END
