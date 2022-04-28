# Release iOS SDK

## Pre-release for iOS SDK

1. XCode commandline tools must be installed. It gets installed with Xcode itself.
2. Cocoapods must be installed. Check [guid](https://guides.cocoapods.org/using/getting-started.html). for installation.
3. CocoaPods must be configured (It must be login). Check [guid](https://guides.cocoapods.org/making/getting-setup-with-trunk.html)
   to login.

## Step-by-step guide to Release iOS SDK

1. Add `CHANGELOG` you want.
2. run `node publish.js patch|minor|major|version`

## node publish.js command

#### node publish.js patch | minor | major | version

1. `node publish.js` runs script which will publish iOS SDK.
2. It requires one parameter.
   
   1. `patch`: It will publish iOS SDK with `patch` version.
   2. `minor`: It will publish iOS SDK with `minor` version.
   3. `major`: It will publish iOS SDK with `major` version.
   4. `version`: It will publish iOS SDK with `version` version. 
      <br/>Version should be in valid format i.e. `1.0.0`
3. Script will check for valid number and update version in `CooeeSDK.podspec` & `Constant.swift`.
4. Then script will push code to main repository and will also push tag.
5. At last script will push code to cocoapods repository.
