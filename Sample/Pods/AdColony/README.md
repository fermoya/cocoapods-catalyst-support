# AdColony iOS SDK
* Modified: March 10th, 2022
* SDK Version: 4.8.0

## Overview

AdColony delivers zero-buffering,
[full-screen Instant-Play™ HD video](https://www.adcolony.com/technology/instant-play/),
[interactive Aurora™ Video](https://www.adcolony.com/technology/auroravideo),
and Aurora™ Playable ads that can be displayed anywhere within your
application. Our advertising SDK is trusted by the world’s top gaming
and non-gaming publishers, delivering them the highest monetization
opportunities from brand and performance advertisers. AdColony’s SDK
can monetize a wide range of ad formats including in-stream/pre-roll,
out-stream/interstitial and V4VC™, a secure system for rewarding users
of your app with virtual currency upon the completion of video and
playable ads.

## Release Notes

### 4.8.0

* Changed configure interface, deprecated old one
* Allow banner ad request to be made without UIViewController at the time of request
* Updated OM SDK to v1.3.30 (fix javascript crash)
* Fixed SDK overwriting app audio session category
* Fixed ad freeze due to untimely setting of audio session
* Fixed app freeze if user manages to close the ad while store view is being loaded
* Fixed NSInvalidArgumentException '[__NSPlaceholderDictionary initWithObjects:forKeys:count]: attempt to insert nil'

Here is the link to the
[release notes](https://github.com/AdColony/AdColony-iOS-SDK/blob/master/CHANGELOG.md)
for all the previous SDK versions.

## Getting Started

To get started, here is the link to
[iOS SDK integration documentation](https://github.com/AdColony/AdColony-iOS-SDK/wiki).


* Tested and verified on iOS 14.5+, 15.0
* Xcode 12.5 and up
* Works on iOS 9 and above.
* Not backwards compatible with any AdColony 2.0 integrations due to major API changes.

## Upgrading

#### SDK 2.X

Please note that updating from our 2.x SDK is not a drag and drop
update, but rather includes breaking API and process changes. In order
to take advantage of the 3.x SDK, a complete re-integration is
necessary. Please review our
[documentation](https://github.com/AdColony/AdColony-iOS-SDK/wiki)
to get a better idea on what changes will be necessary in your app.

For detailed information about the AdColony SDK, see our
[iOS SDK documentation](https://github.com/AdColony/AdColony-iOS-SDK/wiki).

#### SDK 3.X

Updating from 3.x SDK is still drag and drop update although you'll see deprecation warnings on interstitial API.
3.x interstitial API is still fully functional and will remain fully functional at least until iOS 14 release.
Just drag and drop the framework into your Xcode project. If you are
using Cocoapods, sync with the latest by running `pod update`.

For detailed information about the AdColony SDK, see our
[iOS SDK documentation](https://github.com/AdColony/AdColony-iOS-SDK/wiki).



## Legal Requirements

By downloading the AdColony SDK, you are granted a limited,
non-commercial license to use and review the SDK solely for evaluation
purposes.  If you wish to integrate the SDK into any commercial
applications, you must register an account with AdColony and accept
the terms and conditions on the AdColony website.

Note that U.S. based companies will need to complete the W-9 form and
send it to us before publisher payments can be issued.

## Contact Us

For more information, please visit AdColony.com. For questions or
assistance, please email us at support@adcolony.com.
