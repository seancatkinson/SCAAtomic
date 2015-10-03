# SCAAtomic

A lightweight atomic wrapper in swift and C

## Features
- [x] Atomic - Wrapper class with option to inject your own lock
- [x] PerformOnce Example using Atomic instead of dispatch_once

### Usage

```swift
let atomicBool = Atomic(false)
atomicBool.value = true
let originalValue = atomicBool.performAndReplace { current in 
    return true 
}
// originalValue = false
// atomicBool.value = true
```


## Requirements
- iOS 7.0+ / Mac OS X 10.9+
- Xcode 7

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks.**
>
> To use SCAAtomic with a project targeting iOS 7 or to include it manually, you must include the swift files located inside the `Source` directory directly in your project

### CocoaPods

To integrate SCAAtomic into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'SCAAtomic', :git => 'https://github.com/seancatkinson/SCAAtomic.git'
```

## License

SCAAtomic is released under the MIT license. See LICENSE for details.
