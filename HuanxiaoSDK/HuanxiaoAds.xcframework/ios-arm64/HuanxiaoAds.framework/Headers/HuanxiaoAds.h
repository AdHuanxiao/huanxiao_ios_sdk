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

#import <HuanxiaoAds/HXAdMaterialInfo.h>

// 竞价结果通知协议
#import <HuanxiaoAds/HXBidNotifiable.h>

#import <HuanxiaoAds/HXFullscreenAdRenderData.h>

// 开屏广告
#import <HuanxiaoAds/HXSplashAdDelegate.h>
#import <HuanxiaoAds/HXSplashAd.h>

// 插屏广告
#import <HuanxiaoAds/HXInterstitialAdDelegate.h>
#import <HuanxiaoAds/HXInterstitialAd.h>

// 信息流广告
#import <HuanxiaoAds/HXNativeAdDelegate.h>
#import <HuanxiaoAds/HXNativeAd.h>
#import <HuanxiaoAds/HXNativeAdRenderData.h>
#import <HuanxiaoAds/HXInteractionContainerView.h>
#import <HuanxiaoAds/HXMediaView.h>
// 激励视频广告
#import <HuanxiaoAds/HXRewardVideoAdDelegate.h>
#import <HuanxiaoAds/HXRewardVideoAd.h>

