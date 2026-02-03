//
//  HXAdsDefines.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  SDK 常量定义
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#pragma mark - 版本信息
/**
 * @brief SDK 版本号
 * @discussion 格式: 主版本.次版本.修订版本
 */
static NSString * const HXAdsSDKVersion = @"1.0.0";

/**
 * @brief SDK 错误域
 * @discussion 用于标识 SDK 产生的 NSError
 */
static NSString * const HXAdsErrorDomain = @"com.huanxiao.ads.error";


#pragma mark - 错误码
/**
 * @enum HXAdsErrorCode
 * @brief SDK 错误码定义
 *
 * @discussion
 * 错误码规则：
 * - 0: 成功
 * - 1xxx: 初始化相关错误
 * - 2xxx: 网络相关错误
 * - 3xxx: 广告相关错误
 */
typedef NS_ENUM(NSInteger, HXAdsErrorCode) {
    
    /// 成功（无错误）
    HXAdsErrorCodeSuccess = 0,
    
    // ======================== 1xxx 初始化错误 ========================
    
    /**
     * @brief SDK 未初始化
     * @discussion 调用广告接口前需要先初始化 SDK
     */
    HXAdsErrorCodeSDKNotInitialized = 1001,
    
    /**
     * @brief AppID 为空
     * @discussion 初始化时未传入 AppID 或传入空字符串
     */
    HXAdsErrorCodeAppIDEmpty = 1002,
    
    /**
     * @brief AppID 无效
     * @discussion 服务端校验 AppID 格式或签名失败
     */
    HXAdsErrorCodeAppIDInvalid = 1003,
    
    /**
     * @brief AppID 不存在
     * @discussion 该 AppID 在服务端未注册，请检查后台配置
     */
    HXAdsErrorCodeAppIDNotExist = 1004,
    
    /**
     * @brief 初始化失败（通用）
     * @discussion 其他初始化错误
     */
    HXAdsErrorCodeInitFailed = 1099,
    
    // ======================== 2xxx 网络错误 ========================
    
    /**
     * @brief 网络请求失败
     * @discussion 网络连接异常或请求被拒绝
     */
    HXAdsErrorCodeNetworkError = 2001,
    
    /**
     * @brief 网络超时
     * @discussion 请求超时，请检查网络连接
     */
    HXAdsErrorCodeNetworkTimeout = 2002,
    
    /**
     * @brief 服务器错误
     * @discussion 服务端返回错误状态码（如 5xx）
     */
    HXAdsErrorCodeServerError = 2003,
    
    /**
     * @brief 响应解析失败
     * @discussion 服务端返回的数据格式异常
     */
    HXAdsErrorCodeParseError = 2004,
    
    // ======================== 3xxx 广告错误 ========================
    
    /**
     * @brief 广告加载失败
     * @discussion 广告请求失败或返回数据异常
     */
    HXAdsErrorCodeAdLoadFailed = 3001,
    
    /**
     * @brief 无广告填充
     * @discussion 当前无可用广告，请稍后重试
     */
    HXAdsErrorCodeNoAdFill = 3002,
    
    /**
     * @brief 广告已过期
     * @discussion 广告缓存已过期，请重新请求
     */
    HXAdsErrorCodeAdExpired = 3003,
    
    /**
     * @brief 广告展示失败
     * @discussion 广告展示时发生错误（如视图问题）
     */
    HXAdsErrorCodeAdShowFailed = 3004,
    
    /**
     * @brief 广告位 ID 为空
     * @discussion 请求广告时未传入广告位 ID
     */
    HXAdsErrorCodeAdSpotIDEmpty = 3005,
    
    /**
     * @brief 展示窗口为空
     * @discussion 展示广告时传入的 window 为 nil
     */
    HXAdsErrorCodeWindowEmpty = 3006,
    
    /**
     * @brief 展示视图控制器为空
     * @discussion 展示广告时传入的 viewController 为 nil
     */
    HXAdsErrorCodeViewControllerEmpty = 3013,
    
    /**
     * @brief 广告数据无效
     * @discussion 广告数据解析失败或数据不完整
     */
    HXAdsErrorCodeAdDataInvalid = 3007,
    
    /**
     * @brief 广告加载超时
     * @discussion 广告加载超过设定的超时时间
     */
    HXAdsErrorCodeAdLoadTimeout = 3008,
    
    /**
     * @brief 模板不支持
     * @discussion 当前广告模板类型不被支持（如视频模板暂未实现）
     */
    HXAdsErrorCodeTemplateNotSupported = 3009,
    
    /**
     * @brief 内部错误
     * @discussion SDK 内部异常
     */
    HXAdsErrorCodeInternalError = 3099,
};
#pragma mark - 初始化状态
/**
 * @enum HXAdsInitializationStatus
 * @brief SDK 初始化状态
 *
 * @discussion
 * 通过 `[HXAdsSDK sharedInstance].initializationStatus` 获取当前状态
 */
typedef NS_ENUM(NSInteger, HXAdsInitializationStatus) {
    
    /**
     * @brief 未开始初始化
     * @discussion SDK 尚未调用初始化方法
     */
    HXAdsInitializationStatusNotStarted = 0,
    
    /**
     * @brief 初始化中
     * @discussion SDK 正在进行初始化，请等待完成
     */
    HXAdsInitializationStatusInitializing = 1,
    
    /**
     * @brief 初始化成功
     * @discussion SDK 已就绪，可以请求广告
     */
    HXAdsInitializationStatusReady = 2,
    
    /**
     * @brief 初始化失败
     * @discussion SDK 初始化失败，请检查错误信息后重试
     */
    HXAdsInitializationStatusFailed = 3,
};


#pragma mark - 广告类型
/**
 * @enum HXAdType
 * @brief 广告类型
 */
typedef NS_ENUM(NSInteger, HXAdType) {
    HXAdTypeNative = 1,         /// 原生（信息流）广告
    HXAdTypeSplash = 2,         /// 开屏广告
    HXAdTypeInterstitial = 3,   /// 插屏广告
    HXAdTypeRewardVideo = 4,    /// 激励视频广告
};

#pragma mark - 日志级别
/**
 * @enum HXAdsLogLevel
 * @brief 日志级别
 *
 * @discussion
 * 控制 SDK 日志输出的详细程度。仅在 DEBUG 模式下有效。
 */
typedef NS_ENUM(NSInteger, HXAdsLogLevel) {
    
    /// 不输出日志
    HXAdsLogLevelNone = 0,
    
    /// 仅输出错误日志
    HXAdsLogLevelError = 1,
    
    /// 输出警告及错误日志
    HXAdsLogLevelWarning = 2,
    
    /// 输出信息、警告及错误日志
    HXAdsLogLevelInfo = 3,
    
    /// 输出全部日志（包括调试信息）
    HXAdsLogLevelDebug = 4,
};


#pragma mark - 回调定义
/**
 * @typedef HXAdsInitializationCompletionHandler
 * @brief 初始化完成回调
 *
 * @param success 是否成功
 * @param error 失败时的错误信息，成功时为 nil
 *
 * @discussion 回调始终在主线程执行
 */
typedef void(^HXAdsInitializationCompletionHandler)(BOOL success, NSError * _Nullable error);

NS_ASSUME_NONNULL_END
