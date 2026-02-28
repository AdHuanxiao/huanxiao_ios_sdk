//
//  AppDelegate.m
//  HuanxiaoAdsExample
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <HuanxiaoAds/HuanxiaoAds.h>
#import <CoreLocation/CoreLocation.h>

static NSString * const kAppID = @"101";

@interface AppDelegate () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 初始化 Window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    ViewController *rootVC = [[ViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    // 初始化定位（异步检查）
    [self setupLocationManager];
    
    // 初始化 SDK
    [self initializeAdsSDK];
    
    return YES;
}

#pragma mark - SDK 初始化

- (void)initializeAdsSDK {
    HXAdsConfig *config = [[HXAdsConfig alloc] initWithAppID:kAppID];
    if (!config) return;
    
    // 隐私配置
    config.privacyConfig.personalizedAdEnabled = YES;
    config.privacyConfig.idfaEnabled = YES;
    config.privacyConfig.locationEnabled = YES;
    
#ifdef DEBUG
    config.testMode = YES;
    config.logLevel = HXAdsLogLevelDebug;
#else
    config.testMode = NO;
    config.logLevel = HXAdsLogLevelWarning;
#endif
    
    [[HXAdsSDK sharedInstance] initializeWithConfig:config completion:^(BOOL success, NSError *error) {
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HXAdsSDKDidInitializeNotification" object:nil];
            // IDFA 说明：
            // 当 idfaEnabled = YES 时，SDK 内部会在 applicationDidBecomeActive 后
            //
            // 如需手动控制 IDFA，可设置 idfaEnabled = NO，然后自行请求 ATT 后调用：
            // [[HXAdsSDK sharedInstance] setIDFA:idfa];
        }
    }];
}

#pragma mark - Location

- (void)setupLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
}

- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager {
    CLAuthorizationStatus status;
    if (@available(iOS 14.0, *)) {
        status = manager.authorizationStatus;
    } else {
        status = [CLLocationManager authorizationStatus];
    }
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||
               status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager requestLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // 忽略位置错误
}

@end
