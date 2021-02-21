# RZViewActions

[![Version](https://img.shields.io/cocoapods/v/RZViewActions.svg?style=flat)](http://cocoadocs.org/docsets/RZViewActions)

<p align="center">
<img src="http://cl.ly/image/0y0n2C1B1M1X/rzva.gif"
alt="RZViewActions">
</p>
## Overview
It can be difficult and unwieldy to perform complex animations using `[UIView animateWithDuration...]`, especially when trying to manage several concurrent animations and their completion blocks. Core Animation offers some help with `CAAnimationGroup`, but realistically using Core Animation for such tasks can be wordy and just as cumbersome.
RZViewActions offers a solution.

## Installation
Install using [CocoaPods](http://cocoapods.org) (recommended) by adding the following line to your Podfile:

`pod "RZViewActions"`

## Demo Project
An example project is available in the Example directory. You can quickly check it out with

`pod try RZViewActions`

Or download the zip form github and run it manually.

## Basic Usage
RZViewActions provides additional structure for UIView animations, and allows you to define animations semantically:
```obj-c
RZViewAction *changeBg = [RZViewAction action:^{
        self.view.backgroundColor = [UIColor blueColor];
} withDuration:1.0];

[UIView rz_runAction:changeBg withCompletion:^(BOOL finished) {
  NSLog(@"The view changed background color over 1 second");
}];
```
This simple usage may not be particularly useful on its own, but is the fundamental building block for more complex actions. Note that actions can be stored and reused multiple times. If you do store an action, avoid retain cycles by using weak references within the animation block to any objects that might retain ownership of the action.

## Sequences
Basic actions can be combined in sequences that run each action to completion before running the next in the sequence:
``` obj-c
RZViewAction *rotate = [RZViewAction action:^{
        self.label.transform = CGAffineTransformMakeRotation(M_PI_2);
} withOptions:UIViewAnimationOptionCurveEaseInOut duration:3.0];
    
RZViewAction *wait = [RZViewAction waitForDuration:2.0];

RZViewAction *fade = [RZViewAction action:^{
  self.label.alpha = 0.5f;
} withDuration:1.0];
    
RZViewAction *seq = [RZViewAction sequence:@[rotate, wait, fade]];

[UIView rz_runAction:seq withCompletion:^(BOOL finished) {
  NSLog(@"The label rotated, and then faded out 2 seconds later");
}];
```
It's immediately clear what the intent of the above animation is, because each action is defined separately instead of nested within completion blocks.

## Groups
RZViewActions also provides group animations, which performs several actions at once:
``` obj-c
RZViewAction *group = [RZViewAction group:@[rotate, fade]];

[UIView rz_runAction:group withCompletion:^(BOOL finished) {
  NSLog(@"The label rotated over 3 seconds, and faded out during the first second");
}];
```
Grouping behavior is difficult to accomplish with standard UIView animations, especially when trying to execute a completion block, but RZViewActions makes these tasks clear and simple.

## Endless Possibilities
Sequences can be added to groups and groups can be added to sequences, which means the your view animations can be arbitrarily complex. However, the self documenting nature of RZViewActions means your animations can grow in complexity, but your code remains approachable, debuggable, and explicit in intent.

## Author
Rob Visentin, rob.visentin@raizlabs.com

## License
RZViewActions is available under the MIT license. See the LICENSE file for more info.
