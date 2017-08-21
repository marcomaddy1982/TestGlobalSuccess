source 'https://github.com/CocoaPods/Specs.git'
platform :ios, ‘9.0’
inhibit_all_warnings!
use_frameworks!

def default_pods
    pod 'Firebase/Storage'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'JSQMessagesViewController'
    pod 'ReachabilitySwift', '~> 3'
end

target ‘Chat' do
    default_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
