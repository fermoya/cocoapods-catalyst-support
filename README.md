# CatalystPodSupport
## Who's this for?
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

This script are meant to solve this issue so that your project compiles as usual before supporting _macCatalyst_.

## What does this script NOT DO?
It doesn't "magically" fix the pod. If the pod isn't compiled for _x86_64_, then there's nothing that will make it compile for this architecture but the pod's author supporting _macCatalyst_.

## What does this script DO?
It configures your pods project so that these "unsupported pods" are not linked or compiled when building for _macOS_. You'll still need to use the precompiler and remove features from your _macCatalyst_ App:
```swift
#if !targetEnvironment(macCatalyst) 
    // code to be excluded at compilation time from your macOS app
#endif
```
The advantage is you still get to use them for _iOS_ and _iPadOS_.

## How can I use it?
These are the steps to follow:

- Identify which pods don't compile for _macOS_ architectures
- Download this [ruby file](/remove_ios_only_frameworks.rb) and place it in the same folder as your _Podfile_.
- Modify your _Podfile_ like:

```ruby
# Inside your Podfile

# 1. Load the file
load 'remove_ios_only_frameworks.rb'

######  YOUR TARGETS  ######

target 'My target' do   
  use_frameworks!   
  # Install your pods   
  pod 'FBSDKCoreKit'
  pod 'Crashlytics' 
  ...
end

# 2. Define which libraries should be configured
def catalyst_unsupported_pods
  [
    "Crashlytics", "Fabric", "Firebase/Analytics"
    "Branch", "FBSDKCoreKit", "ZendeskChatSDK",
    ... # more libraries
  ]
end

post_install do |installer|   
  installer.configure_support_catalyst
end
```

**NOTE**: You should use the name `catalyst_unsupported_pods` as the script expects this keyword.

## Customization

### Select build configurations to process for Store upload
By default, the script will uninstall resources and frameworks not compiled for _x86_64_ in all build configurations that have `DEBUG=1` in the preprocessor macros, a.k.a. _GCC_PREPROCESSOR_DEFINITIONS_. This will prevent errors from the App Store. It basically skips embedding resources and frameworks that shouldn't be included in the final archive.

If you use any configuration to debug that doesn't have this macro `DEBUG=1` you might run into issues when debugging in simulators. If so, please add this to your _Podfile_:

```ruby
def release_build_configurations
  ['Release-Store']
end
```

This will define the name of those configurations that required this extra process in order to be uploaded to the App Store.

### Logs
If you want to see some logging to understand what's happening, add in your _Podfile_:
```ruby
def debug
  true
end
```


