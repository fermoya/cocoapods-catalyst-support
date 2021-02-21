//
//  DLPRPage.h
//  DLPDFRenderer
//
//  Created by Vincent Esche on 12/4/13.
//  Copyright (c) 2013 Vincent Esche. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DLPRPageOrientation) {
	DLPRPageOrientationPortrait,
	DLPRPageOrientationLandscape
};

typedef struct {
	CGFloat left;
	CGFloat right;
	CGFloat top;
	CGFloat bottom;
} DLPRPageMargins;

DLPRPageMargins DLPRPageMarginsMakeUniform(CGFloat margin);
DLPRPageMargins DLPRPageMarginsMakeSymmetric(CGFloat horizontal, CGFloat vertical);
DLPRPageMargins DLPRPageMarginsMake(CGFloat left, CGFloat right, CGFloat top, CGFloat bottom);

extern const DLPRPageMargins DLPRPageMarginsZero;

@protocol DLPRPage <NSObject>

@property (readwrite, assign, nonatomic) CGSize paperSize;
@property (readwrite, assign, nonatomic) DLPRPageMargins margins;

@property (readwrite, assign, nonatomic) CGRect mediaBoxRect;
@property (readwrite, assign, nonatomic) CGRect cropBoxRect;
@property (readwrite, assign, nonatomic) CGRect bleedBoxRect;
@property (readwrite, assign, nonatomic) CGRect trimBoxRect;
@property (readwrite, assign, nonatomic) CGRect artBoxRect;

@property (readwrite, assign, nonatomic) BOOL cropsOverflow;

- (void)loadInWebView:(UIWebView *)webview;

- (NSDictionary *)boxInfoAsDictionary;

@end

@interface DLPRAbstractPage : NSObject

@property (readwrite, assign, nonatomic) CGSize paperSize;
@property (readwrite, assign, nonatomic) DLPRPageMargins margins;

@property (readwrite, assign, nonatomic) CGRect mediaBoxRect;
@property (readwrite, assign, nonatomic) CGRect cropBoxRect;
@property (readwrite, assign, nonatomic) CGRect bleedBoxRect;
@property (readwrite, assign, nonatomic) CGRect trimBoxRect;
@property (readwrite, assign, nonatomic) CGRect artBoxRect;

@property (readwrite, assign, nonatomic) BOOL cropsOverflow;

- (id)initWithPaperSize:(CGSize)paperSize;

- (NSDictionary *)boxInfoAsDictionary;

#pragma mark - Default Paper Format

+ (DLPRPageOrientation)defaultOrientation;

+ (CGSize)defaultPaperSizeForLocale:(NSLocale *)locale forOrientation:(DLPRPageOrientation)orientation;

#pragma mark - Paper formats

+ (CGSize)paperSizeForISO216A:(NSUInteger)number forOrientation:(DLPRPageOrientation)orientation;
+ (CGSize)paperSizeForISO216B:(NSUInteger)number forOrientation:(DLPRPageOrientation)orientation;

+ (CGSize)paperSizeForJISB:(NSUInteger)number forOrientation:(DLPRPageOrientation)orientation;

+ (CGSize)paperSizeForUSLetterForOrientation:(DLPRPageOrientation)orientation;
+ (CGSize)paperSizeForTabloidForOrientation:(DLPRPageOrientation)orientation;

#pragma mark - Orientation, Scale & Resolution

+ (DLPRPageOrientation)orientationOfPaperSize:(CGSize)paperSize;
+ (CGSize)rotatePaperSize:(CGSize)paperSize toOrientation:(DLPRPageOrientation)orientation;
+ (CGSize)scalePaperSizeFromCentimetersToInches:(CGSize)paperSize;

+ (CGFloat)resolution;

@end

@interface DLPRURLPage : DLPRAbstractPage <DLPRPage>

@property (readwrite, strong, nonatomic) NSURL *url;

- (id)initWithURL:(NSURL *)url paperSize:(CGSize)paperSize;

- (void)loadInWebView:(UIWebView *)webview;

@end

@interface DLPRSourcePage : DLPRAbstractPage <DLPRPage>

@property (readwrite, copy, nonatomic) NSString *source;
@property (readwrite, strong, nonatomic) NSURL *baseURL;

- (id)initWithSource:(NSString *)source paperSize:(CGSize)paperSize;

- (void)loadInWebView:(UIWebView *)webview;

@end
