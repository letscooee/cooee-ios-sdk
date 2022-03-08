# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
# For Test Only

workspace 'CooeeSDK.xcworkspace'
project 'CooeeSDK.xcodeproj'

use_frameworks!
target 'Cooee iOS' do
  platform :ios, '13.0'
  #pod 'Firebase/Messaging'
  #pod 'Firebase'
  #pod 'BSON'
  pod 'CooeeSDK', path: '../ios-sdk'
  target 'CooeeSDK' do
    project 'CooeeSDK.xcodeproj'
    inherit! :search_paths
    # https://stackoverflow.com/a/37289688/2405040
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  end

  target 'NotificationService' do
    inherit! :search_paths
  end
end
