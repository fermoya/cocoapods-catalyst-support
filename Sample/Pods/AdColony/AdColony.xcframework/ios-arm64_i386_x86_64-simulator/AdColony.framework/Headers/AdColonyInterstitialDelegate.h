#import <AdColony/AdColonyTypes.h>
#import <Foundation/Foundation.h>

 
@class AdColonyInterstitial;

/**
 * The delegate of an AdColonyInterstitial object. This delegate receives interstitial lifecycle notifications.
 */
@protocol AdColonyInterstitialDelegate <NSObject>

@required

/**
 @abstract Did load notification
 @discussion Notifies you when interstitial has been created, received an ad and is ready to use. Call is dispatched on main thread.
 @param interstitial Loaded interstitial
 */
- (void)adColonyInterstitialDidLoad:(AdColonyInterstitial * _Nonnull)interstitial;

/**
 @abstract No ad notification
 @discussion Notifies you when SDK was not able to load an ad for requested zone. Call is dispatched on main thread.
 @param error Error with failure explanation
 */
- (void)adColonyInterstitialDidFailToLoad:(AdColonyAdRequestError * _Nonnull)error;

@optional

/**
 @abstract Open notification
 @discussion Notifies you when interstitial is going to show fullscreen content. Call is dispatched on main thread.
 @param interstitial interstitial ad object
 */
- (void)adColonyInterstitialWillOpen:(AdColonyInterstitial * _Nonnull)interstitial;

/**
 @abstract Close notification
 @discussion Notifies you when interstitial dismissed fullscreen content. Call is dispatched on main thread.
 @param interstitial interstitial ad object
 */
- (void)adColonyInterstitialDidClose:(AdColonyInterstitial * _Nonnull)interstitial;

/**
 @abstract Expire notification
 @discussion Notifies you when an interstitial expires and is no longer valid for playback. This does not get triggered when the expired flag is set because it has been viewed. It's recommended to request a new ad within this callback. Call is dispatched on main thread.
 @param interstitial interstitial ad object
 */
- (void)adColonyInterstitialExpired:(AdColonyInterstitial * _Nonnull)interstitial;

/**
 @abstract Will leave application notification
 @discussion Notifies you when an ad action cause the user to leave application. Call is dispatched on main thread.
 @param interstitial interstitial ad object
 */
- (void)adColonyInterstitialWillLeaveApplication:(AdColonyInterstitial * _Nonnull)interstitial;

/**
 @abstract Click notification
 @discussion Notifies you when the user taps on the interstitial causing the action to be taken. Call is dispatched on main thread.
 @param interstitial interstitial ad object
 */
- (void)adColonyInterstitialDidReceiveClick:(AdColonyInterstitial * _Nonnull)interstitial;

/** @name Videos For Purchase (V4P) */

/**
 @abstract IAP opportunity notification
 @discussion Notifies you when the ad triggers an IAP opportunity.
 @param interstitial interstitial ad object
 @param iapProductID IAP product id
 @param engagement engagement type
 */
- (void)adColonyInterstitial:(AdColonyInterstitial * _Nonnull)interstitial iapOpportunityWithProductId:(NSString * _Nonnull)iapProductID andEngagement:(AdColonyIAPEngagement)engagement;





@end
