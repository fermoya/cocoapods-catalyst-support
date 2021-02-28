---
name: Bug report
about: Create a report to help us improve
title: "[BUG]"
labels: ''
assignees: ''

---

<!-- PLEASE READ CAREFULLY
Before opening an issue, please make sure of the following:
* You've read the documentation (README.md) and understood how the script works, what the result is and how it is configured
* Your machine matches the requirements
* You're using the defined DSL correctly as specified in the documentation
* The same key (pod name) use to install the pod is used in `catalyst_configuration`
* You're using `#if !targetEnvironment(macCatalyst)` macro
-->
**Describe the bug**
A clear and concise description of what the bug is.

**Podfile**
Please provide your `Podfile` here.

**Environment**
* `cocoapods-catalyst-support` => <run `gem list | grep cocoapods-catalyst-support`>
* _Ruby_ version [e.g 2.6.0] => <run `ruby --version`>
* _Cocoapods_ version [e.g 1.10.0] => <run `pod --version`>
* _Xcode_ version [e.g 12.2] => <run `xcodebuild -version`>

**Additional context**
Add any other context about the problem here.
