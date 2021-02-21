#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Crayola.h"
#import "EDColor.h"
#import "UIColor+CIELAB.h"
#import "UIColor+Crayola.h"
#import "UIColor+Hex.h"
#import "UIColor+HSB.h"
#import "UIColor+HSL.h"
#import "UIColor+iOS7.h"

FOUNDATION_EXPORT double EDColorVersionNumber;
FOUNDATION_EXPORT const unsigned char EDColorVersionString[];

