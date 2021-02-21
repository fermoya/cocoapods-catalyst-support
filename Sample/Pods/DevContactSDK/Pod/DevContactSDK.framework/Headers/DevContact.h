//
//  DevContact.h
//  HelpSDK
//
//  Created by Umair Hassan Baig on 13/06/2014.
//  Copyright (c) 2014 Pentaloop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DevContact : NSObject


/*Registration*/

/**
 Registers the device to the DevContact Server.
 Call this method in didFinishLaunchingWithOptions in AppDelegate
 Example usage:
 @code
 [DevContact startWithAppID:@"APP_ID_HERE" appKey:@"YOUR_APPKEY_HERE"];
 @endcode
 @param appID
 Application ID generated on web admin.
 @param appKey
 Application key generated on web admin.
 */
+(void)startWithAppID:(NSString *)appID appKey:(NSString *)appKey enableSearch:(BOOL)search;


/*FAQs*/

/*Push Notifications*/

/**
 Enables handling of Push Notifications that are related to DevContact when application is launched
 from a push Notification recieved with relation to DevContact. If no push notifcation is detected
 then does nothing.
 Call this method in didFinishLaunchingWithOptions at the end.
 Example usage:
 @code
 [DevContact showChatScreenForAppLaunchedWithPushNotifications:'App's launch options here'];
 @endcode
 @param launchOptions
 Application launch options.
 */
+(void)showChatScreenForAppLaunchedWithPushNotifications:(NSDictionary *)launchOptions;


/**
 Shows all the sections of FAQs.
 Example usage:
 @code
 [DevContact showSections:yourViewController];
 @endcode
 @param viewController
 UIViewController instance on which it will be presented modally.
 */
+(void)showSections:(UIViewController *)viewController;



/**
 Shows a single section of FAQs identified by sectionID.
 Example usage:
 @code
 [DevContact showFaqsForSectionWithID:@"1" withVC:yourViewController];
 @endcode
 @param sectionID
 SectionID of the section you want to show.
 @param viewController
 UIViewController instance on which it will be presented modally.
 */
+(void)showFaqsForSectionWithID:(NSString *)sectionID withVC:(UIViewController *)viewController;



/**
 Shows a single FAQ detail page identified by the faqID.
 Example usage:
 @code
 [DevContact showSingleFaqWithID:@"12" withVC:yourViewController];
 @endcode
 @param faqID
 FaqID of the FAQ you want to show.
 @param viewController
 UIViewController instance on which it will be presented modally.
 */
+(void)showSingleFaqWithID:(NSString *)faqID withVC:(UIViewController *)viewController;



/**
 Redirects user to the chat screen.
 Example usage:
 @code
 [DevContact showChatScreen:yourViewController onComplete:^{
 }];
 @endcode
 @param viewController
 UIViewController instance on which it will be presented modally.
 */
+(void)showChatScreen:(UIViewController *)viewController onComplete:(void(^)(void))onComplete;



/**
 Enables/Disables contact us button in all screens.
 By Defult Contact us is enabled in app.
 Example usage:
 @code
 [DevContact enableContactUs:NO];
 @endcode
 @param bool
 YES/NO
 */
+(void)enableContactUs:(BOOL)isEnable;


/**
 Enables/Disables mandatory nature of email.
 By Defult value is disabled in app.
 Example usage:
 @code
 [DevContact enableEmailMandatory:NO];
 @endcode
 @param bool
 YES/NO
 */
+(void)enableEmailMandatory:(BOOL)isEnable;

/**
 Prefills name and email fields in the conversation screen with hide/show options
 Example usage:
 @code
 [DevContact setName:@"name" andEmail:@"abc@xyz.com" visible:NO];
 @endcode
 @param NSString "name"
 @param NSString "email"
 @param BOOL "show or hide name and email fields"
 */
+ (void)setName:(NSString*)name andEmail:(NSString*)email;


#pragma mark - Appearance

+(void)showFaqs:(UIViewController *)viewController;

/**
 Sets font name applies to texts for sections list, FAQ list, search results.
 Example usage:
 @code
 [DevContact setFontName:@""Helvetica Neue];
 @endcode
 @param NSString "Font Name"
*/
+ (void)setFontName:(NSString*)fontName;

/**
 Sets bold font name applies to FAQ section headers on support screen
 Example usage:
 @code
 [DevContact setFontNameBold:@""Helvetica Neue];
 @endcode
 @param NSString "Font Name"
 */
+ (void)setFontNameBold:(NSString*)fontName;

/**
 Applies to regions with no UI elements or content. E.g. spaces around table views, FAQ section headers.
 Example usage:
 @code
 [DevContact setBackgroundColor:[UIColor blueColor]];
 @endcode
 @param UIColor "background color"
 */
+ (void)setBackgroundColor:(UIColor*)color;

/**
 Background color for content - table cells, single FAQ screen, conversation screen.
 Example usage:
 @code
 [DevContact setContentBackgroundColor:[UIColor blueColor]];
 @endcode
 @param UIColor "content background color"
 */
+ (void)setContentBackgroundColor:(UIColor*)color;

/**
 Separator color for table views - search results, section & faq lists.
 Example usage:
 @code
 [DevContact setSeparatorLineColor:[UIColor blueColor]];
 @endcode
 @param UIColor "separator line color"
 */
+ (void)setSeparatorLineColor:(UIColor*)color;

/**
Applies to text color for table cells, search results and new conversation screen text.
 Example usage:
 @code
 [DevContact setTextColor:[UIColor blueColor]];
 @endcode
 @param UIColor "text color"
 */
+ (void)setTextColor:(UIColor*)color;

/**
 Applies to “contact us” button below search results.
 Example usage:
 @code
 [DevContact setContactUsButtonColor:[UIColor blueColor]];
 @endcode
 @param UIColor "text color"
 */
+ (void)setContactUsButtonColor:(UIColor*)color;

/**
Applies to tableview cells. Sets the cell selection color.
 Example usage:
 @code
 [DevContact setCellSelectionColor:[UIColor blueColor]];
 @endcode
 @param UIColor "cell selection color"
 */
+ (void)setCellSelectionColor:(UIColor*)color;


#pragma mark - Custom Parameters


/**
 Ads a custom parameter that is displayed in the sidebar of the support agent
 main screen.

 @param key The key that will be displayed on support agent screen.
 @param value The value of the custom param.
 */
+ (void)setCustomParamWithKey:(NSString*)key value:(NSString*)value;


/**
 Ads a custom parameter that is displayed in the sidebar of the support agent
 main screen.

 @param key The key that will be displayed on support agent screen.
 @param value The value of the custom param.
 @param desc Description of the custom param. It shows as tooltip on when support agent hovers mouse over the field.
 */
+ (void)setCustomParamWithKey:(NSString*)key value:(NSString*)value description:(NSString*)desc;


/**
 Ads a custom parameter that is displayed in the sidebar of the support agent screen.
 
 @param key The key that will be displayed on support agent screen.
 @param value The value of the custom param.
 @param desc Description of the custom param. It shows as tooltip on when support agent hovers mouse over the field.
 @param showOnMain Indicates whether the param should be displayed on main screen or on 
 the additional information screen on support agent's screen.
 */
+ (void)setCustomParamWithKey:(NSString*)key value:(NSString*)value description:(NSString*)desc showOnMainScreen:(BOOL)showOnMain;

#pragma mark - Utility

+ (void)clearSavedData;
@end
