#import <AdColony/AdColonyAdSize.h>
#import <Foundation/Foundation.h>

@class AdColonyAdOptions;
@class AdColonyAdRequestError;
@class AdColonyAppOptions;
@class AdColonyInterstitial;
@class AdColonyZone;

@protocol AdColonyAdViewDelegate;
@protocol AdColonyAdViewAdvancedDelegate;
@protocol AdColonyInterstitialDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 The AdColony interface constists of a set of static methods for interacting with the SDK.
 */
@interface AdColony : NSObject

/** @name Starting AdColony */

- (instancetype)init NS_UNAVAILABLE;

/**
 @abstract Configures AdColony specifically for your app; required for usage of the rest of the API.
 @discussion This method returns immediately; any long-running work such as network connections are performed in the background.
 AdColony does not begin preparing ads for display or performing reporting until after it is configured by your app.
 The required appID parameter for this method can be created and retrieved at the [Control Panel](http://clients.adcolony.com).
 If appID is `nil`, app will be unable to play ads and AdColony will only provide limited reporting and install-tracking functionality.
 Please note the completion handler. You should not start requesting ads until it has fired.
 If there is a configuration error, the set of zones passed to the completion handler will be nil.
 @param appID The AdColony app ID for your app.
 @param options (optional) Configuration options for your app.
 @param completion (optional) A block of code to be executed upon completion of the configuration operation. Dispatched on main thread.
 @see AdColonyAppOptions
 @see AdColonyZone
 */
+ (void)configureWithAppID:(NSString *)appID options:(nullable AdColonyAppOptions *)options completion:(nullable void (^)(NSArray<AdColonyZone *> *zones))completion;

/**
 @abstract Configures AdColony specifically for your app; required for usage of the rest of the API.
 @discussion This method returns immediately; any long-running work such as network connections are performed in the background.
 AdColony does not begin preparing ads for display or performing reporting until after it is configured by your app.
 The required appID and zoneIDs parameters for this method can be created and retrieved at the [Control Panel](http://clients.adcolony.com).
 If either of these are `nil`, app will be unable to play ads and AdColony will only provide limited reporting and install-tracking functionality.
 Please note the completion handler. You should not start requesting ads until it has fired.
 If there is a configuration error, the set of zones passed to the completion handler will be nil.
 @param appID The AdColony app ID for your app.
 @param zoneIDs An array of at least one AdColony zone ID string.
 @param options (optional) Configuration options for your app.
 @param completion (optional) A block of code to be executed upon completion of the configuration operation. Dispatched on main thread.
 @see AdColonyAppOptions
 @see AdColonyZone
 @deprecated please use configure without zoneIDs
 */
+ (void)configureWithAppID:(NSString *)appID zoneIDs:(NSArray<NSString *> *)zoneIDs options:(nullable AdColonyAppOptions *)options completion:(nullable void (^)(NSArray<AdColonyZone *> *zones))completion __attribute__((deprecated("Deprecated in v4.8.0")));

/**
 @abstract Requests an AdColonyInterstitial.
 @discussion This method returns immediately, before the ad request completes.
 If the request is successful, an AdColonyInterstitial object will be passed to the success block.
 If the request is unsuccessful, the failure block will be called and an AdColonyAdRequestError will be passed to the handler.
 @param zoneID The AdColony zone identifier string indicating which zone the ad request is for.
 @param options An AdColonyAdOptions object used to set configurable aspects of the ad request.
 @param delegate Interstitial delegate object
 @see AdColonyAdOptions
 @see AdColonyInterstitial
 @see AdColonyInterstitialDelegate
 @see AdColonyAdRequestError
 */
+ (void)requestInterstitialInZone:(NSString *)zoneID options:(nullable AdColonyAdOptions *)options andDelegate:(id<AdColonyInterstitialDelegate> _Nonnull)delegate;

/**
 @abstract Request an AdColonyAdView.
 @discussion This method returns immediately, before the ad request completes.
 If the request is successful, an AdColonyAdView object will be passed to the success block.
 If the request is unsuccessful, an AdColonyAdRequestError object will be passed to the failure block.
 @param zoneID The AdColony zone identifier string indicating which zone the ad request is for.
 @param size The desired size of the banner ad view.
 @param viewController Host view controller
 @param delegate ad view delegate
 @see AdColonyAdOptions
 @see AdColonyAdView
 @see AdColonyAdRequestError
 */
+ (void)requestAdViewInZone:(NSString *)zoneID withSize:(AdColonyAdSize)size viewController:(UIViewController *)viewController andDelegate:(id<AdColonyAdViewDelegate>)delegate;

/**
 @abstract Request an AdColonyAdView.
 @discussion This method returns immediately, before the ad request completes.
 If the request is successful, an AdColonyAdView object will be passed to the success block.
 If the request is unsuccessful, an AdColonyAdRequestError object will be passed to the failure block.
 @param zoneID The AdColony zone identifier string indicating which zone the ad request is for.
 @param size The desired size of the banner ad view.
 @param options An AdColonyAdOptions object used to set configurable aspects of the ad request.
 @param viewController Host view controller
 @param delegate ad view delegate
 @see AdColonyAdOptions
 @see AdColonyAdView
 @see AdColonyAdRequestError
 */
+ (void)requestAdViewInZone:(NSString *)zoneID withSize:(AdColonyAdSize)size andOptions:(nullable AdColonyAdOptions *)options viewController:(UIViewController *)viewController andDelegate:(id<AdColonyAdViewDelegate>)delegate;

/**
 @abstract Request an AdColonyAdView.
 @discussion This method returns immediately, before the ad request completes.
 If the request is successful, an AdColonyAdView object will be passed to the delegate adColonyAdViewDidLoad: method.
 If the request is unsuccessful, an AdColonyAdRequestError object will be passed to the delegate adColonyAdViewDidFailToLoad method.
 @param zoneID The AdColony zone identifier string indicating which zone the ad request is for.
 @param size The desired size of the banner ad view.
 @param options An AdColonyAdOptions object used to set configurable aspects of the ad request.
 @param delegate ad view advanced delegate
 @see AdColonyAdOptions
 @see AdColonyAdView
 @see AdColonyAdRequestError
 */
+ (void)requestAdViewInZone:(NSString *)zoneID withSize:(AdColonyAdSize)size options:(nullable AdColonyAdOptions *)options andDelegate:(id<AdColonyAdViewAdvancedDelegate>)delegate;

/** @name Zone */

/**
 @abstract Retrieves an AdColonyZone object.
 @discussion AdColonyZone objects aggregate informative data about unique AdColony zones such as their identifiers, whether or not they are configured for rewards, etc.
 AdColony zone IDs can be created and retrieved at the [Control Panel](http://clients.adcolony.com).
 @param zoneID The AdColony zone identifier string indicating which zone to return.
 @return An AdColonyZone object. Returns `nil` if an invalid zone ID is passed.
 @see AdColonyZone
 */
+ (nullable AdColonyZone *)zoneForID:(NSString *)zoneID;

/** @name Device Identifiers */

/**
 @abstract Retrieves the device's current advertising identifier.
 @discussion The identifier is an alphanumeric string unique to each device, used by systems to facilitate ad serving.
 Note that this method can be called before `configureWithAppID:zoneIDs:options:completion`.
 @return The device's current advertising identifier.
 */
+ (NSString *)getAdvertisingID;

/**
 @abstract Retrieves a custom identifier for the current user if it has been set.
 @discussion This is an arbitrary, application-specific identifier string for the current user.
 To configure this identifier, use the `setOption:withStringValue` method of the AdColonyAppOptions object you pass to `configureWithAppID:zoneIDs:options:completion`.
 Note that if this method is called before `configureWithAppID:zoneIDs:options:completion`, it will return an empty string.
 @return The identifier for the current user.
 @see AdColonyAppOptions
 */
+ (NSString *)getUserID;

/** @name App Options */

/**
 @abstract Sets the current, global set of AdColonyAppOptions.
 @discussion Use the object's option-setting methods to configure currently-supported options.
 @param options The AdColonyAppOptions object to be used for configuring global options such as a custom user identifier.
 @see AdColonyAppOptions
 */
+ (void)setAppOptions:(AdColonyAppOptions *)options;

/**
 @abstract Returns the current, global set of AdColonyAppOptions.
 @discussion Use this method to obtain the current set of app options used to configure SDK behavior.
 If no options object has been set, this method will return `nil`.
 @return The current AdColonyAppOptions object being used by the SDK.
 @see AdColonyAppOptions
 */
+ (nullable AdColonyAppOptions *)getAppOptions;

/** @name Custom Messages */

/**
 @abstract Sends a custom message to the AdColony SDK.
 @discussion Use this method to send custom messages to the AdColony SDK.
 @param type The type of the custom message. Must be 128 characters or less.
 @param content The content of the custom message. Must be 1024 characters or less.
 @param reply A block of code to be executed when a reply is sent to the custom message. Will be dispatched on main thread.
 */
+ (void)sendCustomMessageOfType:(NSString *)type withContent:(nullable NSString *)content reply:(nullable void (^)(_Nullable id reply))reply;

/** @name In-app purchase (IAP) Tracking */

/**
 @abstract Reports IAPs within your application.
 @discussion Note that this API can be used to report standard IAPs as well as those triggered by AdColony’s IAP Promo (IAPP) advertisements.
 Leveraging this API will improve overall ad targeting for your application.
 @param transactionID An NSString representing the unique SKPaymentTransaction identifier for the IAP. Must be 128 chars or less.
 @param productID An NSString identifying the purchased product. Must be 128 chars or less.
 @param price (optional) An NSNumber indicating the total price of the items purchased.
 @param currencyCode (optional) An NSString indicating the real-world, three-letter ISO 4217 (e.g. USD) currency code of the transaction.
 */
+ (void)iapCompleteWithTransactionID:(NSString *)transactionID productID:(NSString *)productID price:(nullable NSNumber *)price currencyCode:(nullable NSString *)currencyCode;

/** @name SDK Version */

/**
 @abstract Retrieve a string-based representation of the SDK version.
 @discussion The returned string will be in the form of "<Major Version>.<Minor Version>.<External Revision>.<Internal Revision>"
 @return The current AdColony SDK version string.
 */
+ (NSString *)getSDKVersion;

/**
@abstract Gathers AdColony specific information to be passed into OpenRTB bid request.
@discussion Gathers AdColony specific information to be passed into OpenRTB bid requests from a mediation setting.
@return The String to be passed into OpenRTB bid requests, or an empty String if AdColony has not yet been configured.
@deprecated please use asynchronous version
*/
+ (NSString *)collectSignals __attribute__((deprecated("Deprecated in v4.5.0")));

/**
@abstract Gathers AdColony specific information to be passed into OpenRTB bid request.
@discussion Gathers AdColony specific information to be passed into OpenRTB bid requests from a mediation setting.
@param completion A block of code to be executed when collection finishes, with result or error, on calling thread or main thread if unable to schedule on calling thread.
*/
+ (void)collectSignals:(nonnull void (^)(NSString * _Nullable signals, NSError * _Nullable error))completion;

/**
@abstract Gathers AdColony specific information to be passed into OpenRTB bid request.
@discussion Gathers AdColony specific information to be passed into OpenRTB bid requests from a mediation setting.
@param completion A block of code to be executed when collection finishes, with result or error, on target dispatch. If nil dispatch is provided, this method behaves like collectSignals:.
*/
+ (void)collectSignals:(nonnull void (^)(NSString * _Nullable signals, NSError * _Nullable error))completion targetDispatch:(nullable dispatch_queue_t)dispatch;

@end

NS_ASSUME_NONNULL_END
