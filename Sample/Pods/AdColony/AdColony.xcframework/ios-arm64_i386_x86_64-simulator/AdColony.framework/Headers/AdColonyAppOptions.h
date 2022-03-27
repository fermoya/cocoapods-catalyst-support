#import <AdColony/AdColonyOptions.h>
#import <AdColony/AdColonyTypes.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Use the following pre-defined constants to configure mediation network names.
 */

/** AdMob */
FOUNDATION_EXPORT NSString *const ADCAdMob;

/** MoPub */
FOUNDATION_EXPORT NSString *const ADCMoPub;

/** ironSource */
FOUNDATION_EXPORT NSString *const ADCIronSource;

/** Appodeal */
FOUNDATION_EXPORT NSString *const ADCAppodeal;

/** Fuse Powered */
FOUNDATION_EXPORT NSString *const ADCFusePowered;

/** AerServe */
FOUNDATION_EXPORT NSString *const ADCAerServe;

/** AdMarvel */
FOUNDATION_EXPORT NSString *const ADCAdMarvel;

/** Fyber */
FOUNDATION_EXPORT NSString *const ADCFyber;

/** Corona */
FOUNDATION_EXPORT NSString *const ADCCorona;

/**
 * Use the following pre-defined constants to configure plugin names.
 */

/** Unity */
FOUNDATION_EXPORT NSString *const ADCUnity;

/** AdobeAir */
FOUNDATION_EXPORT NSString *const ADCAdobeAir;

/** Cocos2d-x */
FOUNDATION_EXPORT NSString *const ADCCocos2dx;

/**
* Use the following pre-defined constants for type of privacy framework.
*/
FOUNDATION_EXPORT NSString *const ADC_GDPR;
FOUNDATION_EXPORT NSString *const ADC_CCPA;
FOUNDATION_EXPORT NSString *const ADC_COPPA;


/**
 AdColonyAppOptions objects are used to set configurable aspects of SDK state and behavior, such as a custom user identifier.
 The common usage scenario is to instantiate and configure one of these objects and then pass it to `configureWithAppID:zoneIDs:options:completion:`.
 Set the properties below to configure a pre-defined option. Note that you can also pass arbitrary options using the AdColonyOptions API.
 Also note that you can also reset the current options object the SDK is using by passing an updated object to `setAppOptions:`.
 This class in NOT thread safe.
 @see AdColonyOptions
 @see [AdColony setAppOptions:]
 */
@interface AdColonyAppOptions : AdColonyOptions

/** @name Properties */

/**
 @abstract Disables AdColony logging.
 @discussion AdColony logging is enabled by default.
 Set this property before calling `configureWithAppID:zoneIDs:options:completion:` with a corresponding value of `YES` to disable AdColony logging.
 */
@property (nonatomic, assign) BOOL disableLogging;

/**
 @abstract Sets a custom identifier for the current user.
 @discussion Set this property to configure a custom identifier for the current user.
 Corresponding value must be 128 characters or less.
 */
@property (nonatomic, nullable, strong) NSString *userID;

/**
 @abstract Sets the desired ad orientation.
 @discussion Set this property to configure the desired orientation for your ads.
 @see AdColonyOrientation
 */
@property (nonatomic, assign) AdColonyOrientation adOrientation __attribute__((deprecated("Deprecated in v4.2.0")));

/**
 @abstract Enables test ads for your application without changing dashboard settings.
 @discussion Set this property to `YES` to enable test ads for your application without changing dashboard settings.
 */
@property (nonatomic, assign) BOOL testMode;

/**
 @abstract Sets the name of the mediation network you are using AdColony with.
 @discussion Set this property to configure the name of the mediation network you are using AdColony with.
 Corresponding value must be 128 characters or less.
 Note that you should use one of the pre-defined values above if applicable.
 */
@property (nonatomic, nullable, strong) NSString *mediationNetwork;

/**
 @abstract Sets the version of the mediation network you are using AdColony with.
 @discussion Set this property to configure the version of the mediation network you are using AdColony with.
 Corresponding value must be 128 characters or less.
 */
@property (nonatomic, nullable, strong) NSString *mediationNetworkVersion;

/**
 @abstract Sets the name of the plugin you are using AdColony with.
 @discussion Set this property to configure the name of the plugin you are using AdColony with.
 Corresponding value must be 128 characters or less.
 Note that you should use one of the pre-defined values above if applicable.
 */
@property (nonatomic, nullable, strong) NSString *plugin;

/**
 @abstract Sets the version of the plugin version you are using AdColony with.
 @discussion Set this property to configure the version of the plugin you are using AdColony with.
 Corresponding value must be 128 characters or less.
 */
@property (nonatomic, nullable, strong) NSString *pluginVersion;

/**
 @abstract This is to inform the AdColony service if GDPR should be considered for the user based on if they are they EU citizens or from EU territories. Default is FALSE.
 @discussion This is for GDPR compliance, see https://www.adcolony.com/gdpr/
 */
@property (nonatomic, assign) BOOL gdprRequired __attribute__((deprecated("Deprecated in v4.2.0, use setPrivacyFrameworkOfType:isRequired: instead")));

/**
 @abstract Defines end user's consent for information collected from the user.
 @discussion The IAB Europe Transparency and Consent framework defines standard APIs and formats for communicating between Consent Management Platforms (CMPs) collecting consents from end users and vendors embedded on a website or in a mobile application. It provides a unified interface for a seamless integration where CMPs and vendors do not have to integrate manually with hundreds of partners. This is for GDPR compliance through IAB, see https://github.com/InteractiveAdvertisingBureau/GDPR-Transparency-and-Consent-Framework/blob/master/v1.1%20Implementation%20Guidelines.md#vendors
 */
@property (nonatomic, nullable, strong) NSString *gdprConsentString __attribute__((deprecated("Deprecated in v4.2.0, use setPrivacyConsentString:forType: instead")));

/**
@abstract Set privacy framework required key in the app options.
@discussion Use this API to provide AdColony with whether or not following the specified privacy framework is required for the user.
@param type one of the constants defined in this class ADC_GDPR, ADC_CCPA, ADC_COPPA.
@param required whether or not we need to consider the privacy framework of the specified type for this user.
@return updated app options.
*/
- (AdColonyAppOptions *)setPrivacyFrameworkOfType:(NSString *)type isRequired:(BOOL)required;

/**
@abstract Set consent string for privacy framework in the app options.
@discussion Use this API to provide AdColony with the user's consent string of the specified type if applicable.
@param consentString the user's consent string of the specified type.
                    For GDPR, this should either be "0" or "1" (representing do not consent, or consent), or the IAB standard consent String.
                    For CCPA, this should either be "0", or "1" (representing do not sell = true, or do not sell = false), or the IAB standard consent String.
@param type one of the constants defined in this class ADC_GDPR, ADC_CCPA.
@return updated app options.
*/
- (AdColonyAppOptions *)setPrivacyConsentString:(NSString *)consentString forType:(NSString *)type;

/**
@abstract Get privacy framework required key set in the app options.
@discussion Use this API to retrieve the specified privacy framework required key set in the app options.
@param type one of the constants defined in this class ADC_GDPR, ADC_CCPA, ADC_COPPA.
@return the value for the consent requirement of the specified type has been set, or NO if it has not.
*/
- (BOOL)getPrivacyFrameworkRequiredForType:(NSString *)type;

/**
@abstract Get privacy framework consent string set in the app options.
@discussion Use this API to retrieve the specified privacy consent string set in the app options.
@param type one of the constants defined in this class ADC_GDPR, ADC_CCPA.
@return the value for the specified consent string or nil value if it has not been set.
*/
- (NSString *)getPrivacyConsentStringForType:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
