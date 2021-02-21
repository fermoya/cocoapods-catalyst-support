//
//  UIView+RZViewActions.m
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

#import "UIView+RZViewActions.h"

#pragma mark - RZViewAction private interfaces

@interface RZViewAction ()

@property (copy, nonatomic) RZViewActionBlock block;
@property (assign, nonatomic) UIViewAnimationOptions options;
@property (assign, nonatomic, readwrite) NSTimeInterval duration;

- (void)rz_runWithCompletion:(RZViewActionCompletion)completion;

@end

@interface RZViewWaitAction : RZViewAction
@end

@interface RZViewSequenceAction : RZViewAction
@property (copy, nonatomic) NSArray *actions;
@end

@interface RZViewSpringAction : RZViewAction
@property (assign, nonatomic) CGFloat damping;
@property (assign, nonatomic) CGFloat initialVelocity;
@end

@interface RZViewGroupAction : RZViewAction
@property (copy, nonatomic) NSArray *actions;
@end

#pragma mark - RZViewActions implementation

@implementation UIView (RZViewActions)

+ (void)rz_runAction:(RZViewAction *)action
{
    [self rz_runAction:action withCompletion:nil];
}

+ (void)rz_runAction:(RZViewAction *)action withCompletion:(RZViewActionCompletion)completion
{
    [action rz_runWithCompletion:completion];
}

@end

#pragma mark - RZViewAction implemenetation

@implementation RZViewAction

#pragma mark - public methods

+ (RZViewAction *)action:(RZViewActionBlock)action withDuration:(NSTimeInterval)duration
{
    return [self action:action withOptions:kNilOptions duration:duration];
}

+ (RZViewAction *)action:(RZViewActionBlock)action withOptions:(UIViewAnimationOptions)options duration:(NSTimeInterval)duration
{
    return [[RZViewAction alloc] initWithBlock:action options:options duration:duration];
}

+ (RZViewAction *)springAction:(RZViewActionBlock)action withDamping:(CGFloat)dampingRatio initialVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options duration:(NSTimeInterval)duration
{
    RZViewSpringAction *springAction = [[RZViewSpringAction alloc] initWithBlock:action options:options duration:duration];
    springAction.damping = dampingRatio;
    springAction.initialVelocity = velocity;
    
    return springAction;
}

+ (RZViewAction *)waitForDuration:(NSTimeInterval)duration
{
    NSAssert(duration >= 0.0, @"%@ wait duration must be non-negative.", NSStringFromClass([RZViewAction class]));
    
    RZViewAction *waitAction = [[RZViewWaitAction alloc] init];
    waitAction.duration = duration;
    
    return waitAction;
}

+ (RZViewAction *)sequence:(NSArray *)actionSequence
{
    RZViewSequenceAction *sequence = [[RZViewSequenceAction alloc] init];
    sequence.actions = actionSequence;
    
    return sequence;
}

+ (RZViewAction *)group:(NSArray *)actionGroup
{
    RZViewGroupAction *group = [[RZViewGroupAction alloc] init];
    group.actions = actionGroup;
    
    return group;
}

#pragma mark - private methods

- (instancetype)initWithBlock:(RZViewActionBlock)block options:(UIViewAnimationOptions)options duration:(NSTimeInterval)duration
{
    NSParameterAssert(block);
    
    self = [super init];
    if ( self ) {
        _block = block;
        _options = options;
        _duration = duration;
    }
    return self;
}

- (void)rz_runWithCompletion:(RZViewActionCompletion)completion
{
    [UIView animateWithDuration:self.duration delay:0.0 options:self.options animations:self.block completion:completion];
}

@end

#pragma mark - RZViewSpringAction

@implementation RZViewSpringAction

- (void)rz_runWithCompletion:(RZViewActionCompletion)completion
{
    [UIView animateWithDuration:self.duration delay:0.0 usingSpringWithDamping:self.damping initialSpringVelocity:self.initialVelocity options:self.options animations:self.block completion:completion];
}

@end

#pragma mark - RZViewWaitAction implemenetation

@implementation RZViewWaitAction

- (void)rz_runWithCompletion:(RZViewActionCompletion)completion
{
    if ( completion != nil ) {
        if ( self.duration > 0.0 ) {
            [self performSelector:@selector(rz_finishedWithCompletion:) withObject:completion afterDelay:self.duration inModes:@[NSRunLoopCommonModes]];
        }
        else {
            [self rz_finishedWithCompletion:completion];
        }
    }
}

- (void)rz_finishedWithCompletion:(RZViewActionCompletion)completion
{
    completion(YES);
}

@end

#pragma mark - RZViewSequenceAction implementation

@implementation RZViewSequenceAction

- (void)setActions:(NSArray *)actions
{
    _actions = [actions copy];
    
    self.duration = [[actions valueForKeyPath:@"@sum.duration"] doubleValue];
}

- (void)rz_runWithCompletion:(RZViewActionCompletion)completion
{
    [self rz_runActionAtIndex:0 withCompletion:completion];
}

- (void)rz_runActionAtIndex:(NSUInteger)index withCompletion:(RZViewActionCompletion)completion
{
    if ( index < [self.actions count] ) {
        [self.actions[index] rz_runWithCompletion:^(BOOL finished) {
            [self rz_runActionAtIndex:index+1 withCompletion:completion];
        }];
    }
    else if ( completion != nil ) {
        completion(YES);
    }
}

@end

#pragma mark - RZViewGroupAction implementation

@implementation RZViewGroupAction

- (void)setActions:(NSArray *)actions
{
    _actions = [actions copy];
    
    self.duration = [[actions valueForKeyPath:@"@max.duration"] doubleValue];
}

- (void)rz_runWithCompletion:(RZViewActionCompletion)completion
{
    dispatch_group_t actionGroup = dispatch_group_create();
    
    [self.actions enumerateObjectsUsingBlock:^(RZViewAction *action, NSUInteger idx, BOOL *stop) {
        dispatch_group_enter(actionGroup);
        
        [action rz_runWithCompletion:^(BOOL finished) {
            dispatch_group_leave(actionGroup);
        }];
    }];
    
    if ( completion != nil ) {
        dispatch_group_notify(actionGroup, dispatch_get_main_queue(), ^{
            completion(YES);
        });
    }
}

@end
