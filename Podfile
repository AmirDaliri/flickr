platform :ios, 10.0
use_frameworks!

def shared_pods
  pod 'Alamofire'
  pod 'XMLMapper/Requests'
  pod 'Kingfisher'
  pod 'ACProgressHUD-Swift'
end

target 'AppcentTest' do
  shared_pods
end

post_install do |installer|
  puts 'Patching SVGKit to compile with the ios 7 SDK'
  %x(patch Pods/path/to/file.m < localpods/patches/fix.patch)
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
