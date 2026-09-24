#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 已加载广告的不可变素材快照。缺失字符串为空字符串，缺失图片列表为空数组。
/// 查询不会加载、展示广告或触发统计；关闭、过期后仍可读取已成功加载的快照。
@interface HXAdMaterialInfo : NSObject <NSCopying>
/// 本次加载成功广告对应的响应请求标识。
@property (nonatomic, copy, readonly) NSString *requestID;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSArray<NSString *> *imageURLs;
@property (nonatomic, copy, readonly) NSString *videoURL;
@property (nonatomic, copy, readonly) NSString *packageName;
@property (nonatomic, copy, readonly) NSString *landingPageURL;
@property (nonatomic, copy, readonly) NSString *deeplinkURL;

/// 固定键：requestId、title、img_url、image_urls、video_url、package_name、landingpage_url、deeplink_url。
/// img_url 为第一张非空图片地址；没有图片时为空字符串。返回值可直接进行 JSON 序列化。
- (NSDictionary<NSString *, id> *)dictionaryRepresentation;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
