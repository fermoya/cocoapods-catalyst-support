

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @struct AdColonyAdSize 
 @abstract Size for banner ads
 */
struct AdColonyAdSize {
    CGFloat width;
    CGFloat height;
};

/** AdColony ad size */
typedef struct AdColonyAdSize AdColonyAdSize;

/**
 @function AdColonyAdSizeMake
 @abstract Get a custom AdColonyAdSize
 @discussion Use this method if you want to display non-standard ad size banner. Otherwise, use one of the standard size constants.
 @param width height for a banner ad.
 @param height width for a banner ad.
 */
extern AdColonyAdSize AdColonyAdSizeMake(CGFloat width, CGFloat height);

/**
 @function AdColonyAdSizeFromCGSize
 @abstract Get a custom AdColonyAdSize from CGSize.
 @discussion Use this method if you want to display non-standard ad size banner. Otherwise, use one of the standard size constants.
 @param size The size for a banner ad.
 */
extern AdColonyAdSize AdColonyAdSizeFromCGSize(CGSize size);

/**
 @const kAdColonyAdSizeBanner
 @abstract 320 x 50
 @discussion The constant for a banner with 320 in width and 50 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeBanner;

/**
 @const kAdColonyAdSizeMediumRectangle
 @abstract 300 x 250
 @discussion The constant for a banner with 300 in width and 250 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeMediumRectangle;

/**
 @const kAdColonyAdSizeLeaderboard
 @abstract 728 x 90
 @discussion The constant for a banner with 728 in width and 90 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeLeaderboard;

/**
 @const kAdColonyAdSizeSkyscraper
 @abstract 160 x 600
 @discussion The constant for a banner with 160 in width and 600 in height.
 */
extern AdColonyAdSize const kAdColonyAdSizeSkyscraper;


NS_ASSUME_NONNULL_END
