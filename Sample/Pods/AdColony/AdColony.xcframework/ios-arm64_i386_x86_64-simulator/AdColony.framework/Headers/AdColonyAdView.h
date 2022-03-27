

#import <UIKit/UIKit.h>
#import <AdColony/AdColonyAdViewDelegate.h>

NS_ASSUME_NONNULL_BEGIN

/**
 AdColonyAdViews is used to display AdColony Banner ads.
 */
@interface AdColonyAdView : UIView

/** @name Zone */

/**
 @abstract Represents the unique zone identifier string from which the AdColonyAdView was requested.
 @discussion AdColony zone IDs can be created at the [Control Panel](http://clients.adcolony.com).
 */
@property (nonatomic, strong, readonly) NSString *zoneID;

/**
 @abstract Indicates that the AdColonyAdView has been removed from the view hierarchy and should be destroyed.
 @discussion The AdColony SDK maintains internal resources when the ad is being displayed.
 When this method is called, all internal resources are destroyed and the associated memory is freed.
 */
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
