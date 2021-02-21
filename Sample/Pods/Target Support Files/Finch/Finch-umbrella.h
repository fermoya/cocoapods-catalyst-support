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

#import "FIError.h"
#import "FISampleBuffer.h"
#import "FISampleDecoder.h"
#import "FISampleFormat.h"
#import "FISound.h"
#import "FISoundContext.h"
#import "FISoundDevice.h"
#import "FISoundEngine.h"
#import "FISoundSource.h"

FOUNDATION_EXPORT double FinchVersionNumber;
FOUNDATION_EXPORT const unsigned char FinchVersionString[];

