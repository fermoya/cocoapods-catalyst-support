# cocoapods-catalyst-support

## Requirements
* [Ruby 2.6.0+](https://www.ruby-lang.org/en/downloads/)

## Installation
```
$ gem install cocoapods-catalyst-support
```

## Usage

These are the steps to follow:
- Identify which pods don't compile for _macOS_ architectures.
- Follow [installation](#installation) instructions.
- Open your terminal and run `pod catalyst init` in your project folder.
- Configure your dependencies. Use `ios` or `macos` to make them available in one platform or the other:
```ruby
catalyst_configuration do
	ios 'Firebase/Analytics' # This dependency will only be available for iOS
	macos 'AppCenter/Analytics' # This dependency will only be available for macOS
end
```
- Run `pod catalyst validate` to validate your configuration
- Run `pod catalyst run` and configure your catalyst dependencies

That's it! Simple as that.

**Note:** Make sure to read the [Disclaimer](#disclaimer) section to understand what this library does and what it doesn't.

## Commands

| **Command** | **Description** |
|---|---|
| `pod catalyst` | Lists available subcommands |
| `pod catalyst init` | Set up your Podfile to use `cocoapods-catalyst-support` |
| `pod catalyst run` | Configure your catalyst dependencies |
| `pod catalyst validate` | Validate your catalyst configuration |

**Note:** Make sure to run this commands in your project folder.

## Disclaimer

### Who is this for?

If you're using _CocoaPods_ and your App supports _macCatalyst_, you might have run into this error:
```
ld: in Pods/Crashlytics/iOS/Crashlytics.framework/Crashlytics(CLSInternalReport.o), building for Mac Catalyst, but linking in object file built for iOS Simulator, file 'Pods/Crashlytics/iOS/Crashlytics.framework/Crashlytics' for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```
or maybe
```
Undefined symbols for architecture x86_64:
    "_OBJC_CLASS_$_UIWebView", referenced from:
    objc-class-ref in BNCDeviceInfo.o
    objc-class-ref in BranchViewHandler.o
ld: symbol(s) not found for architecture x86_64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```
Perhaps the error came from the App Store:
```
ERROR ITMS-90276: "Missing Bundle Identifier. The application bundle contains a tool or framework ${PRODUCT_NAME} [com.myapp.myapp.pkg/Payload/MyApp.app/Contents/Resources/GoogleSignIn.bundle] that is missing the bundle identifier in its Info.plist file."
```

This library is meant to solve this issue so that your project compiles as usual before supporting _macCatalyst_. Thus, you won't need to modify your current project structure.

Additionally, you might be thinking of using some libraries only for _macCatalyst_. This library takes care of that too and lets you configure which libraries will be linked for _macOS_ and which for _iOS_.

### What does this library NOT DO?

It doesn't "magically" fix the pod. If the pod isn't built for `sdk MacOS`, then there's nothing that will make it compile for this architecture but the pod's author supporting _macCatalyst_.

### What does this library DO?

It configures your pods project so that these "unsupported pods" are not linked when building for _macOS_ and will strip those frameworks from the final _Product_. You'll still need to use the precompiler and remove features from your _macCatalyst_ App:
```swift
#if !targetEnvironment(macCatalyst) 
    // code to be excluded at compilation time from your macOS app
#endif
```
The advantage is you still get to use them for _iOS_ and _iPadOS_.

## Example

```ruby
require 'cocoapods-catalyst-support'

platform :ios, '12.0'
use_frameworks!

target 'Sample' do
  pod 'AppCenter/Analytics'
  pod 'Firebase/Analytics'
end

catalyst_configuration do
	verbose!

	ios 'Firebase/Analytics'
	macos 'AppCenter/Analytics'
end

post_install do |installer|
	installer.configure_catalyst
end
```

## Troubleshooting
* Make sure you're using the last version of the script.
* Add `verbose!` to your `catalyst_configuration` and check if the library is being excluded.
* Validate your `catalyst_configuration` by running `pod catalyst validate`.
* Open an issue and provide your:
    * Ruby version
    * Cocoapods version
    * Xcode version
    * Podfile

## Support Open Source

If you love this script, understand all the effort it takes to maintain it and would like to  support me, you can buy me a coffee by following this [link](https://www.buymeacoffee.com/fermoya):

<a href="https://www.buymeacoffee.com/fermoya" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" style="height: 51px !important;width: 217px !important;" ></a>

You can also sponsor me by hitting the [_GitHub Sponsor_](https://github.com/sponsors/fermoya) button. All help is very much appreciated.

## License  

`cocoapods-catalyst-support` is available under the MIT license. See the [LICENSE](/LICENSE) file for more info.
