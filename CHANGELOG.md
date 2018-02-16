# Mortar Changelog

## 1.4.0.2 -- 2/16/18

* Added swift_version to podspec

## 1.4.0 -- 10/28/17

* Swift 4 support
* Added support for UILayoutGuide

## 1.3.0 -- 5/1/17

* Changed default MortarVFL sizing to intrinsic

## 1.2.1 -- 4/13/17

* Added MortarVFL extension

## 1.2.0 -- 3/30/17

* Updates for Xcode 8.3/Swift 3.1 support

## 1.1.0 -- 11/6/16

* Changed default constaint priority to .required

## 1.0.2 -- 11/5/16

* Fixes for macOS support

## 1.0.1 -- 10/13/16

* Addressed podspec issues for cocoapods
* Added ```m_create```

## 1.0.0 -- 9/11/16

* Updated to support Swift 3.0
* Updated ```MortarDefault``` calls to Swift 3.0 syntax.

## 0.11.1 -- 9/11/16

* Official Swift 2.3 support compiled against Xcode 8 GM seed

## 0.11.0 -- 6/17/16 

* Updated release for Swift 2.3

> last version updated for Swift 2.3
> Use ```pod 'Mortar', '~> 0.11'```

## 0.10.4 -- 6/16/16

* Added ```setBase``` to ```MortarDefaults```, allowing you to set the base default for a property.

> last version updated for Swift 2.2
> Use ```pod 'Mortar', '~> 0.10'```

## 0.10.3 -- 4/23/16

* Added MortarDefault enum, which lets you change the default layout priority in a stack-based fashion.

## 0.10.2 -- 4/13/16

* Added an additional operator case to eliminate bridging error on a case like ```[v1, v2].m_size |=| (1, 1)```

## 0.10.1 -- 2/28/16

* Added iOS 7 compatibility

## 0.9.2 -- 2/14/16

* Added support for UIViewController layout guides

## 0.9.1 -- 2/14/16

* Initial Release
