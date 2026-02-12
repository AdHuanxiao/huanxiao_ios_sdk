//
//  HuanxiaoAds.h
//  HuanxiaoAds SDK
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.


#import <Foundation/Foundation.h>

//! SDK 版本号 (数值)
FOUNDATION_EXPORT double HuanxiaoAdsVersionNumber;

//! SDK 版本号 (字符串)
FOUNDATION_EXPORT const unsigned char HuanxiaoAdsVersionString[];

#pragma mark - 核心模块

/// SDK 常量定义（错误码、状态码、日志级别）
#import <HuanxiaoAds/HXAdsDefines.h>

/// 隐私配置类
#import <HuanxiaoAds/HXPrivacyConfig.h>

/// SDK 配置类
#import <HuanxiaoAds/HXAdsConfig.h>

/// SDK 主类
#import <HuanxiaoAds/HXAdsSDK.h>

#pragma mark - 广告模块

// 开屏广告
#import <HuanxiaoAds/HXSplashAdDelegate.h>
#import <HuanxiaoAds/HXSplashAd.h>
#import <HuanxiaoAds/HXSplashAd+Internal.h>

// 插屏广告
#import <HuanxiaoAds/HXInterstitialAdDelegate.h>
#import <HuanxiaoAds/HXInterstitialAd.h>
#import <HuanxiaoAds/HXInterstitialAd+Internal.h>

// 信息流广告
#import <HuanxiaoAds/HXNativeAdDelegate.h>
#import <HuanxiaoAds/HXNativeAd.h>
#import <HuanxiaoAds/HXNativeAd+Internal.h>
#import <HuanxiaoAds/HXNativeAdRenderData.h>
#import <HuanxiaoAds/HXNativeAdCustomViews.h>
// 激励视频广告
#import <HuanxiaoAds/HXRewardVideoAdDelegate.h>
#import <HuanxiaoAds/HXRewardVideoAd.h>
#import <HuanxiaoAds/HXRewardVideoAd+Internal.h>
