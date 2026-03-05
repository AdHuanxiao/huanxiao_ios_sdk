//
//  HXHMAdapterHelper.h
//  HuanxiaoAdsHMAdapterSDK
//

#import <Foundation/Foundation.h>
#import <MSaas/MSaas.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXHMAdapterHelper : NSObject

+ (NSString * _Nullable)slotIdFromModel:(SFAdSourcesModel *)model;
+ (void)initializeSDKIfNeededWithModel:(SFAdSourcesModel *)model completion:(void(^)(BOOL success, NSError * _Nullable error))completion;
+ (void)fillBidFloorIfNeeded:(SFAdSourcesModel *)model ecpm:(NSUInteger)ecpm;

@end

NS_ASSUME_NONNULL_END
