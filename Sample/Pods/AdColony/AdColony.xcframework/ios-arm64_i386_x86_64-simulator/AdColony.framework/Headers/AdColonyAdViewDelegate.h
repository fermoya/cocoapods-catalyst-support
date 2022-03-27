//
//  AdColonyAdViewDelegate.h
//  adc-ios-sdk
//
//  Copyright © 2018 AdColony. All rights reserved.
//

@class AdColonyAdView;
@class AdColonyAdRequestError;

/**
 * The delegate of an AdColonyAdView object. This delegate receives ad view lifecycle notifications.
 */
@protocol AdColonyAdViewDelegate <NSObject>

@required
/**
 @abstract Did load notification
 @discussion Notifies you when ad view has been created, received the ad and is ready to use. Call is dispatched on main thread.
 @param adView Loaded ad view
 */
- (void)adColonyAdViewDidLoad:(AdColonyAdView * _Nonnull)adView;

/**
 @abstract No ad notification
 @discussion Notifies you when SDK was not able to load the ad for requested zone. Call is dispatched on main thread.
 @param error Error with failure explanation
 */
- (void)adColonyAdViewDidFailToLoad:(AdColonyAdRequestError * _Nonnull)error;

@optional
/**
 @abstract Application leave notification
 @discussion Notifies you when ad view is going to redirect user to content outside of the application.
 @param adView The ad view which caused the user to leave the application.
 */
- (void)adColonyAdViewWillLeaveApplication:(AdColonyAdView * _Nonnull)adView;

/**
 @abstract Open fullscreen content notification
 @discussion Notifies you when ad view is going to display fullscreen content. Call is dispatched on worker thread.
 @param adView Ad view that is going to display fullscreen content.
 */
- (void)adColonyAdViewWillOpen:(AdColonyAdView * _Nonnull)adView;

/**
 @abstract Did close fullscreen content notification
 @discussion Notifies you when ad view stopped displaying fullscreen content
 @param adView Ad view that stopped displaying fullscreen content
 */
- (void)adColonyAdViewDidClose:(AdColonyAdView * _Nonnull)adView;

/**
 @abstract Received a click notification
 @discussion Notifies you when adView receives a click
 @param adView Ad view that received a click
 */
- (void)adColonyAdViewDidReceiveClick:(AdColonyAdView * _Nonnull)adView;

@end

@protocol AdColonyAdViewAdvancedDelegate <AdColonyAdViewDelegate>

@required

/**
 @abstract Host view controller request
 @discussion Requests hosting view controller when needed if it wasn't provided during ad request.
 @param adView The ad view which requests host view controller.
 @return view controller that hosts given ad view
 */
- (UIViewController * _Nonnull)adColonyAdViewHostViewController:(AdColonyAdView * _Nonnull)adView;

@end
