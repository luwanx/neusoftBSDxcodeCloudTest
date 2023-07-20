# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
source 'https://cdn.cocoapods.org/'
use_frameworks!
inhibit_all_warnings!



target 'neusoftBSDxcodeCloudTest' do
  use_frameworks!
  pod 'SwiftLint'

  target 'neusoftBSDxcodeCloudTestTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
#      config.build_settings['VALID_ARCHS'] = 'arm64'
      config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 11.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end
end


