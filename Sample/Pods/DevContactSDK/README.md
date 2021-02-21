# DevContactSDK


## Installation

DevContactSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DevContactSDK"
```

## Author
DevContact, info@pentaloop.com

## Release Notes

### v1.2.8
- Bugfixes: Crash on Faqs screen fixed.

### v1.2.7
- Bugfixes: Crash on chat screen textView fixed.

### v1.2.6
- Dark Mode support added for iOS 13.0 or later.

### v1.2.5
- Bugfixes: Crash on search fixed by migrating to UISearchController.

### v1.2.4
- Bugfixes: Keyboard overlapping textfield on chat screen fixed.

### v1.2.3
- Bugfixes: Crash on search FAQs screen due to iOS 13. Username and Email of user is now mandatory (configurable) for filing any ticket.

### v1.2.2
- Bugfixes: incorporate changes from 1.1.9 in chat screen. Navigation workflow from profile screen fixed

### v1.2.1
- Bugfixes: Searchbar on FAQ screen is now programmatically controlled through exposed property enableSearch

### v1.2.0
- Bugfixes, incorporate changes from 1.1.9 in FAQs screen.

### v1.1.9
- Ability to make username and password mandatory and optional based on settings value.

### v1.1.3
- Fixed problem where multiple copies of the same chat message were displayed in chat window.

### v1.1.2
- Fixed crash related to SKStoreReviewController ios 10.3 and older iOS versions.

### v1.1.1
- When support agent requests review of the app and a review URL is not provided then system rating dialog is displayed. (iOS 11+)

### v1.1
- Now user user is no longer required to created ticket for chat.
- Username and email are optional. An anonumous user name is assigned to user at the start of chat.
- Updated UI appearance for chat bubbles and buttons.
- Icons added in navigation bars to replace text buttons.
- Updated for for FAQs and documentation.



