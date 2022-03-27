#import <AdColony/AdColonyTypes.h>
#import <AdColony/AdColonyInterstitialDelegate.h>
#import <Foundation/Foundation.h>

@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

/**
 Ad object returned from a request. This is used to show and receive callbacks once the ad is presented.
 */
@interface AdColonyInterstitial : NSObject

/** @name Properties */

/**
 @abstract Interstitial delegate
 @discussion Delegate object that receives interstitial lifecycle notifications.
 */
@property (nonatomic, nullable, weak) id<AdColonyInterstitialDelegate> delegate __attribute__((deprecated("Deprecated in v4.7.0")));

/**
 @abstract Represents the unique zone identifier string from which the interstitial was requested.
 @discussion AdColony zone IDs can be created at the [Control Panel](http://clients.adcolony.com).
 */
@property (nonatomic, strong, readonly) NSString *zoneID;

/**
 @abstract Indicates whether or not the interstitial has been played or if it has met its expiration time.
 @discussion AdColony interstitials become expired as soon as the ad launches or just before they have met their expiration time.
 */
@property (atomic, assign, readonly) BOOL expired;

/**
 @abstract Indicates whether or not the interstitial has audio enabled.
 @discussion Leverage this property to determine if the application's audio should be paused while the ad is playing.
 */
@property (nonatomic, assign, readonly) BOOL audioEnabled;

/**
 @abstract Indicates whether or not the interstitial is configured to trigger IAPs.
 @discussion Leverage this property to determine if the interstitial is configured to trigger IAPs.
 */
@property (nonatomic, assign, readonly) BOOL iapEnabled;



/** @name Ad Playback */

/**
 @abstract Triggers a fullscreen ad experience.
 @param viewController The view controller on which the interstitial will display itself.
 @return Whether the SDK was ready to begin playback.
 */
- (BOOL)showWithPresentingViewController:(UIViewController *)viewController;

/**
 @abstract Cancels the interstitial and returns control back to the application.
 @discussion Call this method to cancel the interstitial.
 Note that canceling interstitials before they finish will diminish publisher revenue.
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
