# Release iOS SDK

## Pre-release for iOS SDK

1. `git` command line is required.
2. Write access to `main` branch on `Github` && `Gitlab` repository is required.
3. `Github` && `Gitlab` should be accessible via `SSH`.
4. Node.js should be installed (requires to run publish script). 
5. XCode commandline tools must be installed. It gets installed with Xcode itself.
6. Cocoapods must be installed. Check [guid](https://guides.cocoapods.org/using/getting-started.html). for installation.
7. CocoaPods must be configured (It must be login). Check [guid](https://guides.cocoapods.org/making/getting-setup-with-trunk.html)
   to login.

## Step-by-step guide to Release iOS SDK

1. Add `CHANGELOG` you want (no need to commit; Step 2 will commit it by itself).
2. Run `node publish.js patch|minor|major|<version>`.
3. Done publishing iOS SDK is started.

## node publish.js command

`node publish.js patch | minor | major | \<version\>`

1. `node publish.js` runs script which will publish iOS SDK.
2. It requires one argument.
   
   1. `patch`: It will publish iOS SDK with `patch` version.
   2. `minor`: It will publish iOS SDK with `minor` version.
   3. `major`: It will publish iOS SDK with `major` version.
   4. `<version>`: It will publish iOS SDK with `version` version. 
      <br/>Version should be in valid format i.e. `1.0.0`
3. Script will check for valid number and update version in `CooeeSDK.podspec` & `Constant.swift`.
4. Then script will push code to main repository and will also push tag.
5. At last script will push code to cocoapods repository.
