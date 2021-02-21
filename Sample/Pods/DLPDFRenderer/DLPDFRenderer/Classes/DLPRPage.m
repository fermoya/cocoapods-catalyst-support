//
//  DLPRPage.m
//  DLPDFRenderer
//
//  Created by Vincent Esche on 12/4/13.
//  Copyright (c) 2013 Vincent Esche. All rights reserved.
//

#import "DLPRPage.h"

DLPRPageMargins DLPRPageMarginsMakeUniform(CGFloat margin) {
	return (DLPRPageMargins){margin, margin, margin, margin};
}

DLPRPageMargins DLPRPageMarginsMakeSymmetric(CGFloat horizontal, CGFloat vertical) {
	return (DLPRPageMargins){vertical, vertical, horizontal, horizontal};
}

DLPRPageMargins DLPRPageMarginsMake(CGFloat top, CGFloat bottom, CGFloat left, CGFloat right) {
	return (DLPRPageMargins){left, right, top, bottom};
}

const DLPRPageMargins DLPRPageMarginsZero = (DLPRPageMargins){0.0, 0.0, 0.0, 0.0};

@interface DLPRAbstractPage ()

@end

@implementation DLPRAbstractPage

- (id)init {
	self = [super init];
	if (self) {
		self.paperSize = CGSizeZero;
		self.margins = DLPRPageMarginsZero;
		
		self.mediaBoxRect = CGRectZero;
		self.cropBoxRect = CGRectZero;
		self.bleedBoxRect = CGRectZero;
		self.trimBoxRect = CGRectZero;
		self.artBoxRect = CGRectZero;
	}
	return self;
}

- (id)initWithPaperSize:(CGSize)paperSize {
	self = [self init];
	if (self) {
		self.paperSize = paperSize;
	}
	return self;
}

- (NSDictionary *)boxInfoAsDictionary {
	NSMutableDictionary *boxInfo = [NSMutableDictionary dictionary];
	if (!CGRectEqualToRect(self.mediaBoxRect, CGRectZero)) {
		[boxInfo setObject:[NSValue valueWithCGRect:self.mediaBoxRect] forKey:(__bridge NSString *)kCGPDFContextMediaBox];
	}
	if (!CGRectEqualToRect(self.cropBoxRect, CGRectZero)) {
		[boxInfo setObject:[NSValue valueWithCGRect:self.cropBoxRect] forKey:(__bridge NSString *)kCGPDFContextCropBox];
	}
	if (!CGRectEqualToRect(self.bleedBoxRect, CGRectZero)) {
		[boxInfo setObject:[NSValue valueWithCGRect:self.bleedBoxRect] forKey:(__bridge NSString *)kCGPDFContextBleedBox];
	}
	if (!CGRectEqualToRect(self.trimBoxRect, CGRectZero)) {
		[boxInfo setObject:[NSValue valueWithCGRect:self.trimBoxRect] forKey:(__bridge NSString *)kCGPDFContextTrimBox];
	}
	if (!CGRectEqualToRect(self.artBoxRect, CGRectZero)) {
		[boxInfo setObject:[NSValue valueWithCGRect:self.artBoxRect] forKey:(__bridge NSString *)kCGPDFContextArtBox];
	}
	return boxInfo;
}

#pragma mark - Default Paper Format

+ (DLPRPageOrientation)defaultOrientation {
	return DLPRPageOrientationPortrait;
}

+ (CGSize)defaultPaperSizeForLocale:(NSLocale *)locale forOrientation:(DLPRPageOrientation)orientation {
	if ([self localePrefersWeirdUSLetterPaperFormat:locale]) {
		return [self scalePaperSize:[self paperSizeForUSLetterForOrientation:orientation] by:72.0];
	}
	return [self scalePaperSize:[self paperSizeForISO216A:4 forOrientation:orientation] by:72.0];
}

+ (BOOL)localePrefersWeirdUSLetterPaperFormat:(NSLocale *)locale {
	NSDictionary * components = [NSLocale componentsFromLocaleIdentifier:locale.localeIdentifier];
	NSString * country = components[NSLocaleCountryCode];
	NSSet * letterCountries = [NSSet setWithObjects:@"US", @"CA", @"MX", @"CO", @"VE", @"AR", @"CL", @"PH", nil];
	return [letterCountries containsObject:country];
}

#pragma mark - Paper formats

+ (CGSize)paperSizeForISO216:(NSUInteger)number withBaseAreaInSquareMeters:(CGFloat)baseAreaInSquareMeters forOrientation:(DLPRPageOrientation)orientation {
	CGFloat squareRootOfTwo = sqrt(2.0);
	CGFloat heightOfBaseInCentimeters = 100.0 * baseAreaInSquareMeters * sqrt(squareRootOfTwo);

  CGFloat heightInCentimeters = heightOfBaseInCentimeters;
	heightInCentimeters /= powf(squareRootOfTwo, number);

	CGFloat widthInCentimeters = heightInCentimeters / squareRootOfTwo;
	CGSize paperSizeInCentimeters = CGSizeMake(widthInCentimeters, heightInCentimeters);
	CGSize paperSizeInInches = [self scalePaperSizeFromCentimetersToInches:paperSizeInCentimeters];
	CGSize paperSizeInPixels = [self scalePaperSize:paperSizeInInches by:72.0];
	return [self rotatePaperSize:paperSizeInPixels toOrientation:orientation];
}

+ (CGSize)paperSizeForISO216A:(NSUInteger)number forOrientation:(DLPRPageOrientation)orientation {
	return [self paperSizeForISO216:number withBaseAreaInSquareMeters:1.0 forOrientation:orientation];
}

+ (CGSize)paperSizeForISO216B:(NSUInteger)number forOrientation:(DLPRPageOrientation)orientation {
	return [self paperSizeForISO216:number withBaseAreaInSquareMeters:sqrt(2.0) forOrientation:orientation];
}

+ (CGSize)paperSizeForJISB:(NSUInteger)number forOrientation:(DLPRPageOrientation)orientation {
	return [self paperSizeForISO216:number withBaseAreaInSquareMeters:1.5 forOrientation:orientation];
}

+ (CGSize)paperSizeForUSLetterForOrientation:(DLPRPageOrientation)orientation {
	CGSize paperSizeInInches = CGSizeMake(8.0, 11.0);
	CGSize paperSizeInPixels = [self scalePaperSize:paperSizeInInches by:72.0];
	return [self rotatePaperSize:paperSizeInPixels toOrientation:orientation];
}

+ (CGSize)paperSizeForTabloidForOrientation:(DLPRPageOrientation)orientation {
	CGSize paperSizeInInches = CGSizeMake(11.0, 17.0);
	CGSize paperSizeInPixels = [self scalePaperSize:paperSizeInInches by:72.0];
	return [self rotatePaperSize:paperSizeInPixels toOrientation:orientation];
}

#pragma mark - Orientation, Scale & Resolution

+ (DLPRPageOrientation)orientationOfPaperSize:(CGSize)paperSize {
	if (paperSize.width <= paperSize.height) {
		return DLPRPageOrientationPortrait;
	}
	return DLPRPageOrientationLandscape;
}

+ (CGSize)rotatePaperSize:(CGSize)paperSize toOrientation:(DLPRPageOrientation)orientation {
	DLPRPageOrientation currentOrientation = [self orientationOfPaperSize:paperSize];
	if (currentOrientation == orientation) {
		return paperSize;
	}
	return CGSizeMake(paperSize.height, paperSize.width);
}

+ (CGSize)scalePaperSize:(CGSize)paperSize by:(CGFloat)scaleFactor {
	return CGSizeMake(paperSize.width * scaleFactor,
					  paperSize.height * scaleFactor);
}

+ (CGSize)scalePaperSizeFromCentimetersToInches:(CGSize)paperSize {
	return [self scalePaperSize:paperSize by:0.3937];
}

+ (CGFloat)resolution {
	return 72.0;
}

@end

@implementation DLPRURLPage

- (id)initWithURL:(NSURL *)url paperSize:(CGSize)paperSize {
	NSAssert(url, @"Method argument 'url' must not be nil.");
	self = [self initWithPaperSize:paperSize];
	if (self) {
		self.url = url;
	}
	return self;
}

- (void)loadInWebView:(UIWebView *)webview {
	if (!self.url) {
		[NSException raise:[NSStringFromClass([self class]) stringByAppendingString:@"MissingURLException"]
					format:@"Page's url must not be nil."];
	}
	[webview loadRequest:[NSURLRequest requestWithURL:self.url]];
}

@end

@implementation DLPRSourcePage

- (id)initWithSource:(NSString *)source paperSize:(CGSize)paperSize {
	NSAssert(source, @"Method argument 'source' must not be nil.");
	self = [self initWithPaperSize:paperSize];
	if (self) {
		self.source = source;
	}
	return self;
}

- (void)loadInWebView:(UIWebView *)webview {
	if (!self.source) {
		[NSException raise:[NSStringFromClass([self class]) stringByAppendingString:@"MissingSourceException"]
					format:@"Page's source must not be nil."];
	}
	[webview loadHTMLString:self.source baseURL:self.baseURL];
}

@end
