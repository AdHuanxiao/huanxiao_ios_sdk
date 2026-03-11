//
//  HXResourceLoader.h
//  HuanxiaoAds
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//
//  ⚠️ 内部类 - 请勿直接使用
//  SDK 内置资源加载器
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * @class HXResourceLoader
 * @brief SDK 内置资源加载工具类
 */
@interface HXResourceLoader : NSObject

/**
 * @brief 加载 SDK 内置图片资源
 * @param imageName 图片名称（不含扩展名）
 * @return 图片对象，加载失败返回 nil
 */
+ (nullable UIImage *)imageNamed:(NSString *)imageName;



/**
 * @brief 从 HXAdsImages.bundle 加载图片
 * @param imageName 图片名称（不含扩展名）
 * @return 图片对象，加载失败返回 nil
 */
+ (nullable UIImage *)imageFromBundle:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
