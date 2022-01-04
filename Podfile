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
  pod 'CooeeSDK', path: '../CooeeSDK'
  target 'CooeeSDK' do
    project 'CooeeSDK.xcodeproj'
        inherit! :search_paths
   end
end
