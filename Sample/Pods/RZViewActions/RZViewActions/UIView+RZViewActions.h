//
//  UIView+RZViewActions.h
//
//  Created by Rob Visentin on 10/16/14.
//

// Copyright 2014 Raizlabs and other contributors
// http://raizlabs.com/
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#if __has_feature(modules)
@import UIKit;
#else
#import <UIKit/UIKit.h>
#endif

@class RZViewAction;

typedef void (^RZViewActionBlock)();
typedef void (^RZViewActionCompletion)(BOOL finished);

@interface UIView (RZViewActions)

/**
 *  Runs an action using UIView animations.
 *
 *  @param action The action to run.
 */
+ (void)rz_runAction:(RZViewAction *)action;

/**
 *  Runs an action using UIView animations and calls a completion block when finished.
 *
 *  @param action     The action to run.
 *  @param completion Called when the action finishes. The finished parameter will be YES if the action completed successfully, and NO if it was cancelled.
 *
 *  @note The completion block is used as a UIView animation completion block, so will avoid retain cycles.
 */
+ (void)rz_runAction:(RZViewAction *)action withCompletion:(RZViewActionCompletion)completion;

@end


/**
 *  An object that encapsulates standard UIView animation blocks and allows them to be run in more interesting ways, namely in 
 *  arbitrary groups and sequences.
 */
@interface RZViewAction : NSObject

/**
 *  The duration of the action in seconds.
 */
@property (assign, nonatomic, readonly) NSTimeInterval duration;

/**
 *  Returns a new action with the given duration. 
 *  The action block is used as a UIView animation block, and therefore must not be nil.
 *  If the duration is 0, the action block will be executed immediately without animation.
 *
 *  @note Unlike UIView animation blocks, the action block is copied, so be wary of retain cycles.
 *  @see UIView(UIViewAnimationWithBlocks)
 */
+ (RZViewAction *)action:(RZViewActionBlock)action withDuration:(NSTimeInterval)duration;

/**
 *  Returns a new action with the given animation options and duration. 
 *  The action block is used as a UIView animation block, and therefore must not be nil.
 *
 *  @note The action block is copied, so make sure to use weak references to objects that may retain ownership of the action.
 *  @see UIView(UIViewAnimationWithBlocks)
 */
+ (RZViewAction *)action:(RZViewActionBlock)action withOptions:(UIViewAnimationOptions)options duration:(NSTimeInterval)duration;

/**
 *  Returns a new springy action. The dampingRatio and velocity are passed as parameters to the standard UIView
 *  animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:... method.
 *  The action block is used as a UIView animation block, and therefore must not be nil.
 *
 *  @note The action block is copied, so make sure to use weak references to objects that may retain ownership of the action.
 *  @see UIView(UIViewAnimationWithBlocks)
 */
+ (RZViewAction *)springAction:(RZViewActionBlock)action withDamping:(CGFloat)dampingRatio initialVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options duration:(NSTimeInterval)duration;

/**
 *  Returns a new action that waits for a given duration. Useful in RZViewAction sequences.
 */
+ (RZViewAction *)waitForDuration:(NSTimeInterval)duration;

/**
 *  Returns a new sequence action. Sequence actions behave like a queue in that actions are executed serially.
 *  Completion blocks for sequence actions are not invoked until after all actions in the sequence have finished.
 *
 *  @param actionSequence An array of RZViewActions to run serially.
 *
 *  @note Each element in the actionGroup array may be any type of RZViewAction. 
 *  This means that you can comebine sequence and group actions in any way you see fit.
 */
+ (RZViewAction *)sequence:(NSArray *)actionSequence;

/**
 *  Returns a new group action. Group actions run all actions in the group together, and do not wait for an action to finish
 *  before executing the next one.
 *  Completion blocks for group actions are not invoked until after all actions in the group have finished.
 *
 *  @param actionSequence An array of RZViewActions to run in tandem.
 *
 *  @note Each element in the actionGroup array may be any type of RZViewAction. 
 *  This means that you can comebine group and sequence actions in any way you see fit.
 */
+ (RZViewAction *)group:(NSArray *)actionGroup;

@end
