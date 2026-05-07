//
//  HXCSJInitManager.h
//  HuanxiaoAdsCSJAdapterSDK
//
//  Created by HuanxiaoAds on 2026/5/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HXCSJInitState) {
    HXCSJInitStateNotStarted = 0,
    HXCSJInitStateInitializing,
    HXCSJInitStateReady,
    HXCSJInitStateFailed,
};

typedef void(^HXCSJInitCompletion)(BOOL success, NSError * _Nullable error);
typedef void(^HXCSJReadyCompletion)(NSError * _Nullable error);

@interface HXCSJInitManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, assign, readonly) HXCSJInitState state;
@property (nonatomic, copy, readonly, nullable) NSString *appID;

- (void)initializeWithAppID:(NSString *)appID
                   testMode:(BOOL)testMode
                 completion:(nullable HXCSJInitCompletion)completion;

- (void)executeWhenReadyWithTimeout:(NSTimeInterval)timeout
                         completion:(HXCSJReadyCompletion)completion;

+ (NSString *)stringFromState:(HXCSJInitState)state;

@end

NS_ASSUME_NONNULL_END
