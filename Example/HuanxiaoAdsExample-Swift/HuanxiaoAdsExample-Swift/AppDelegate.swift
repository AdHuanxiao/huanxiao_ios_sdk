//
//  AppDelegate.swift
//  HuanxiaoAdsExample-Swift
//
//  HuanxiaoAds SDK Swift 官方示例
//
//  Copyright © 2026 Huanxiao Technology Co., Ltd. All rights reserved.
//

import UIKit
import HuanxiaoAds
import CoreLocation

private let kAppID = "101"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private var locationManager: CLLocationManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 初始化 Window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootVC = ViewController()
        let navController = UINavigationController(rootViewController: rootVC)
        
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        // 初始化定位（异步检查）
        setupLocationManager()
        
        // 初始化 SDK
        initializeAdsSDK()
        
        return true
    }
    
    // MARK: - SDK 初始化
    
    private func initializeAdsSDK() {
        guard let config = HXAdsConfig(appID: kAppID) else { return }
        
        // 隐私配置
        config.privacyConfig.personalizedAdEnabled = true
        config.privacyConfig.idfaEnabled = true
        config.privacyConfig.locationEnabled = true
        
        #if DEBUG
        config.testMode = true
        config.logLevel = .debug
        #else
        config.testMode = false
        config.logLevel = .warning
        #endif
        HXAdsSDK.sharedInstance().initialize(with: config) { success, error in
            if success {
                NotificationCenter.default.post(name: NSNotification.Name("HXAdsSDKDidInitializeNotification"), object: nil)
                // IDFA 说明：
                // 当 idfaEnabled = true 时，SDK 内部会在 applicationDidBecomeActive 后
                // 自动延迟请求 ATT 授权，无需手动调用。
                // 此时机可避免与网络授权、定位授权等系统弹窗冲突。
                //
                // 如需手动控制 IDFA，可设置 idfaEnabled = false，然后自行请求 ATT 后调用：
                // HXAdsSDK.sharedInstance().setIDFA(idfa)
            }
        }
    }
    
    // MARK: - Location
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
    }
}

// MARK: - CLLocationManagerDelegate

extension AppDelegate: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 忽略位置错误
    }
}
