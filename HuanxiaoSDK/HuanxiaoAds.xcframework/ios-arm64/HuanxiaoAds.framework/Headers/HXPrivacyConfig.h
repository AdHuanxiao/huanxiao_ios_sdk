//
//  HXPrivacyConfig.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  隐私配置类
//

#import <Foundation/Foundation.h>
#import <HuanxiaoAds/HXAdsDefines.h>

NS_ASSUME_NONNULL_BEGIN


@interface HXPrivacyConfig : NSObject <NSCopying>

#pragma mark - 隐私开关

/**
 * @brief 是否允许个性化广告
 *
 * @discussion
 * 开启后，SDK 会根据用户行为数据进行广告精准推荐，提高广告转化效果。
 * 关闭后，将展示通用广告，可能影响广告收益。
 *
 * @note 建议在用户同意隐私政策后开启此选项
 *
 * @default YES
 */
@property (nonatomic, assign) BOOL personalizedAdEnabled;

/**
 * @brief 是否允许获取 IDFA
 *
 * @discussion
 * IDFA (Identifier for Advertisers) 是 iOS 设备的广告标识符。
 * - iOS 14.5 之前：可直接获取
 * - iOS 14.5 及之后：需要通过 ATTrackingManager 请求用户授权
 *
 * 设置为 NO 时，SDK 不会检查 ATT 状态、请求 ATT 权限或读取系统 IDFA。
 * 媒体通过 HXAdsSDK 的 setIDFA: 手动传入的值不受此开关影响。
 *
 * @note 建议在请求 ATT 授权后，根据用户选择设置此项
 *
 * @default NO（默认关闭，保护用户隐私）
 */
@property (nonatomic, assign) BOOL idfaEnabled;

/**
 * @brief 是否允许自动获取 IDFV
 *
 * @discussion
 * IDFV (Identifier for Vendor) 是 iOS 为同一开发者应用提供的设备标识符。
 * 设置为 YES 时，SDK 会在初始化成功后读取一次系统 IDFV 并用于广告请求。
 * 设置为 NO 时，SDK 不会访问 identifierForVendor。
 * 媒体通过 HXAdsSDK 的 setIDFV: 手动传入的值不受此开关影响。
 *
 * @note 建议仅在用户同意隐私政策后开启此选项
 *
 * @default NO（默认关闭，保护用户隐私）
 */
@property (nonatomic, assign) BOOL idfvEnabled;

/**
 * @brief 是否允许获取地理位置
 *
 * @discussion
 * 开启后，SDK 会尝试获取用户的地理位置信息用于广告精准投放。
 * SDK 不会主动请求定位权限，仅在以下条件都满足时才获取位置：
 * - 此开关设置为 YES
 * - 用户已授权定位权限（Always 或 WhenInUse）
 * - 定位服务已开启
 *
 * 关闭后，SDK 不会获取地理位置信息。
 *
 * @note
 * - SDK 不会触发定位权限弹窗，权限请求由宿主 App 自行处理
 * - 仅获取缓存的位置信息，不会持续定位或消耗额外电量
 * - 建议在用户同意隐私政策并授权定位后开启
 *
 * @default NO（默认关闭，保护用户隐私）
 */
@property (nonatomic, assign) BOOL locationEnabled;

#pragma mark - 便捷方法

/**
 * @brief 创建默认配置
 *
 * @return 默认配置实例
 *
 * @discussion
 * 默认配置：
 * - personalizedAdEnabled = YES
 * - idfaEnabled = NO（默认关闭，保护用户隐私）
 * - idfvEnabled = NO（默认关闭，保护用户隐私）
 * - locationEnabled = NO（默认关闭，保护用户隐私）
 */
+ (instancetype)defaultConfig;

@end

NS_ASSUME_NONNULL_END
