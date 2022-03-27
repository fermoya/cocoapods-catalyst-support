#import <AdColony/AdColonyTypes.h>

/**
 Typed error for AdColony ad requests.
 */
@interface AdColonyAdRequestError : NSError

- (nonnull instancetype)init NS_UNAVAILABLE;

- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder NS_UNAVAILABLE;

- (nonnull instancetype)initWithDomain:(nonnull NSErrorDomain)domain code:(NSInteger)code userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict NS_UNAVAILABLE;

/**
@abstract Zone ID
@discussion ID of the zone that was requested
*/
@property (nonatomic, nonnull, strong, readonly) NSString *zoneId;

@end
