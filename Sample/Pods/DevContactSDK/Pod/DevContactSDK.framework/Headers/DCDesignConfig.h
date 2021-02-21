//
//  DCDesignConfig.h
//  HelpSDK
//
//  Created by Umair Ali on 30/06/2015.
//  Copyright (c) 2015 Pentaloop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DCDesignConfig : NSObject

// Navigation Bar Configs
+ (void)setNavBarTitleFontName:(NSString*)fontName;
+ (void)setNavBarTitleFontSize:(CGFloat)fontSize;
+ (void)setNavBarTitleColor:(UIColor*)color;
+ (void)setNavBArButtonTextColor:(UIColor*)color;
+ (void)setNavBarBGColor:(UIColor*)color;

// Search Bar Configs
+ (void)setSearchBarColor:(UIColor*)color;

// Table Section Header Configs
+ (void)setTableSectionHeaderFontName:(NSString*)fontName;
+ (void)setTableSectionHeaderTextColor:(UIColor*)color;
+ (void)setTableSectionHeaderTextSize:(CGFloat)size;

// Faq and Chat Design Configs
+ (void)setChatSendButtonColor:(UIColor*)color;
+ (void)setFaqYesButtonColor: (UIColor*)color;
+ (void)setFaqNoButtonColor: (UIColor*)color;
+ (void)setScreenshotTutorialButtonColor:(UIColor*)color;
+ (void)setscreenshotAttachButtonColor:(UIColor*)color;

// Conversation Resolution Screen BG Color
+ (void)setResolveConversationBgColor:(UIColor*)color;
+ (void)setResolveConversationTextColor:(UIColor*)color;
+ (void)setNewConversationButtonColor:(UIColor*)color;
+ (void)setResolveConversationYesButtonColor:(UIColor*)color;
+ (void)setResolveConversationNoButtonColor:(UIColor*)color;

+ (NSDictionary*)navBarTitleConfigurations;
+ (void)applyNavBarConfigurationsOnScreen:(UIViewController*)screen;

@end
