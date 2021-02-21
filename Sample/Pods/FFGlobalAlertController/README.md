# FFGlobalAlertController

[![CI Status](http://img.shields.io/travis/Eric Larson/FFGlobalAlertController.svg?style=flat)](https://travis-ci.org/Eric Larson/FFGlobalAlertController)
[![Version](https://img.shields.io/cocoapods/v/FFGlobalAlertController.svg?style=flat)](http://cocoapods.org/pods/FFGlobalAlertController)
[![License](https://img.shields.io/cocoapods/l/FFGlobalAlertController.svg?style=flat)](http://cocoapods.org/pods/FFGlobalAlertController)
[![Platform](https://img.shields.io/cocoapods/p/FFGlobalAlertController.svg?style=flat)](http://cocoapods.org/pods/FFGlobalAlertController)

## Background

We had an existing app that we replaced all the UIAlertView with the new UIAlertController in iOS 8. The key difference being you have to specify the UIViewController to present it from. When your data model or networking code or some other singleton needs to display an alert this poses a problem because they typically have no idea about the current UIViewController. Our first solution was to get the rootViewController from the app delegate and go from there. But there were too many edge cases where this didn't work. 

I took the opportunity at WWDC 2015 to ask an Apple engineer the best practice in this situation and he recommended displaying the UIAlertController in a UIWindow with a empty transparent ViewController. I didn't want to sublcass it because then I would have to change all my code to use the subclass. So I created this category on UIAlertController. 

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

To display a basic UIAlertController:
```objc
    #import "UIAlertController+Window.h"

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Global Alert" message:@"The message" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [alert show];
```

To display a UIAlertController with a text field, you must use a local variable to reference the UITextField in the action handler, instead of referencing via the alert. Otherwise a retain cycle will be created and the UIWindow will not be dealloc and will stay on screen blocking touches.
```objc
    __block UITextField *localTextField;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Global Alert" message:@"Enter some text" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"do something with text:%@", localTextField.text);
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        localTextField = textField;
    }];
    [alert show];
```

## Requirements

iOS 8 obviously since this is for UIAlertController that was introduced in iOS 8.

## Installation

FFGlobalAlertController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FFGlobalAlertController"
```

```objc
#import "UIAlertController+Window.h"
```

## Author

Eric Larson, eric@agilityvision.com

## License

FFGlobalAlertController is available under the MIT license. See the LICENSE file for more info.
