# XZSegmentedControl

[![CI Status](https://img.shields.io/badge/Build-pass-brightgreen.svg)](https://cocoapods.org/pods/XZSegmentedControl)
[![Version](https://img.shields.io/cocoapods/v/XZSegmentedControl.svg?style=flat)](https://cocoapods.org/pods/XZSegmentedControl)
[![License](https://img.shields.io/cocoapods/l/XZSegmentedControl.svg?style=flat)](https://cocoapods.org/pods/XZSegmentedControl)
[![Platform](https://img.shields.io/cocoapods/p/XZSegmentedControl.svg?style=flat)](https://cocoapods.org/pods/XZSegmentedControl)

基于 UICollectionView 设计的分段控件，主要用于横向或纵向的菜单视图。

```swift
let control = XZSegmentedControl.init(frame: CGRect(x: 0, y: 0, width: 375, height: 50), direction: .horizontal)
self.view.addSubview(control)

control.titles = ["标题一", "标题二"]
control.titleColor = .black
control.selectedTitleColor = .red

control.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
```

## Example

To run the example project, clone the repo, and run `pod install` from the Pods directory first.

## Requirements

iOS 11.0, Xcode 14.0

## Installation

XZSegmentedControl is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'XZSegmentedControl'
```

## 功能特性

## Author

Xezun, developer@xezun.com

## License

XZSegmentedControl is available under the MIT license. See the LICENSE file for more info.
