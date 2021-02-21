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

#import "NSCondition+WEPopover.h"
#import "UIBarButtonItem+WEPopover.h"
#import "UIView+WEPopover.h"
#import "WEBlockingGestureRecognizer.h"
#import "WEPopoverContainerView.h"
#import "WEPopoverContainerViewProperties.h"
#import "WEPopoverController.h"
#import "WEPopoverParentView.h"
#import "WETouchableView.h"
#import "WEWeakReference.h"

FOUNDATION_EXPORT double WEPopoverVersionNumber;
FOUNDATION_EXPORT const unsigned char WEPopoverVersionString[];

