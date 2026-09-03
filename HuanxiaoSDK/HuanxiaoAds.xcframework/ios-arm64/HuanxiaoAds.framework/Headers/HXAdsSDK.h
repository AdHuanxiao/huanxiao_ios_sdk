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
 * @discussion 初始化成功后可读取，未初始化时为 nil。SDK 在初始化开始时复制配置，
 * 后续修改调用方原始 HXAdsConfig 对象不会改变 SDK 内部配置。
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
 * @return 版本号字符串，如 "1.5.0"
 */
+ (NSString *)sdkVersion;

#pragma mark - 同步初始化

/**
 * @brief 使用 AppID 同步初始化 SDK
 *
 * @param appID 应用 ID（必填）
 *
 * @discussion
 * 方法会在当前线程等待初始化网络请求完成后返回，可直接在主线程调用。
 * 使用默认配置，等同于使用默认 HXAdsConfig 调用 initializeWithConfig:
 * 方法返回后可通过 @c isInitialized 判断是否成功。
 * 内部逻辑（网络重试等）与异步版本完全一致。
 * iOS 12 上会立即安全返回，@c isInitialized 保持为 NO，不会启动 SDK 业务流程。
 */
- (void)initializeWithAppID:(NSString *)appID;

/**
 * @brief 同步初始化 SDK
 *
 * @param config SDK 配置对象，包含 AppID 和隐私设置
 *
 * @discussion
 * 方法会在当前线程等待初始化网络请求完成后返回，可直接在主线程调用。
 * 方法返回后可通过 @c isInitialized 判断是否成功。
 * 初始化成功后的后续流程（崩溃监控、IDFA 获取等）与异步版本完全一致。
 * 网络失败时仍会注册自动重试，后续网络恢复后会在后台自动重新初始化。
 *
 * @warning AppID 为必填项，为空时初始化将失败并记录错误日志
 */
- (void)initializeWithConfig:(HXAdsConfig *)config;

#pragma mark - 异步初始化

/**
 * @brief 使用 AppID 异步初始化 SDK
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
 * @brief 异步初始化 SDK
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
 * - iOS 12 上会立即回调失败，错误码为 @c HXAdsErrorCodeUnsupportedOS，不会启动 SDK 业务流程
 *
 * @warning AppID 为必填项，为空时将返回错误
 */
- (void)initializeWithConfig:(HXAdsConfig *)config
                  completion:(nullable HXAdsInitializationCompletionHandler)completion;


#pragma mark - 就绪队列

/**
 * @brief 在 SDK 初始化就绪后执行任务
 *
 * @param block   就绪后执行的回调（主线程），error 非空表示等待超时或初始化永久失败
 * @param timeout 最大等待时间（秒），超时后回调 error 并放弃等待
 *
 * @discussion
 * 根据当前 SDK 状态有三种行为：
 * - @c HXAdsInitializationStatusReady：立即在主线程执行 block(nil)
 * - @c HXAdsInitializationStatusPending / @c HXAdsInitializationStatusInitializing：
 *   任务入队等待，初始化成功后按入队顺序执行；超时则回调 error
 * - @c HXAdsInitializationStatusFailed / @c HXAdsInitializationStatusNotStarted：
 *   立即回调 error（不可恢复的失败状态，或未调用初始化）
 *
 * @note SDK 内部各广告类型在 loadAd 时自动使用此队列，媒体开发者一般无需直接调用。
 */
- (void)executeWhenReady:(void(^)(NSError * _Nullable error))block
                 timeout:(NSTimeInterval)timeout;

#pragma mark - 音频设置

/**
 * @brief 是否使用 SDK 默认音频会话设置
 *
 * @param enabled YES: 使用 SDK 默认设置，NO: 由媒体自行管理 AVAudioSession
 *
 * @discussion
 * 默认值为 YES。设置为 NO 后，SDK 在广告播放时不主动修改 AVAudioSession。
 * 如需完全接管音频会话，可在展示广告前关闭该开关。
 */
+ (void)enableDefaultAudioSessionSetting:(BOOL)enabled;

/**
 * @brief 当前是否使用 SDK 默认音频会话设置
 */
+ (BOOL)isDefaultAudioSessionSettingEnabled;

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
 * @param idfa IDFA UUID 字符串；传入 nil 或空字符串时清空当前值
 *
 * @discussion
 * 如果您的应用已自行获取了 IDFA（通过 ATTrackingManager），可通过此方法传入。
 * SDK 将使用您提供的 IDFA 进行广告请求。
 * 非 UUID 或全零 UUID 会被忽略，且不会覆盖当前有效值。
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

#pragma mark - IDFV 管理

/**
 * @brief 设置 IDFV
 *
 * @param idfv IDFV UUID 字符串；传入 nil 或空字符串时清空当前值
 *
 * @discussion
 * 如果媒体已自行获取 IDFV，可通过此方法传入。媒体手动传入的值优先于
 * SDK 自动获取的值，并且不受 HXPrivacyConfig.idfvEnabled 开关影响。
 * 非 UUID 或全零 UUID 会被忽略，且不会覆盖当前有效值。
 *
 * @note 必须在 SDK 初始化成功后调用，否则设置无效
 */
- (void)setIDFV:(nullable NSString *)idfv;

/**
 * @brief 获取当前有效的 IDFV
 * @return IDFV 字符串，未设置或不允许使用自动值时返回 nil
 */
- (nullable NSString *)idfv;

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
