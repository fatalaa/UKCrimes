# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

# Comment this line if you're not using Swift and don't want to use dynamic frameworks
use_frameworks!

target 'CleanMap' do
  pod 'AlamofireObjectMapper', '~> 4.0'
  pod 'RxCocoa', '~> 3.0'
  pod 'RxSwift', '~> 3.0'
end

target 'CleanMapTests' do
  pod 'RxBlocking', '~> 3.0'
  pod 'RxTest', '~> 3.0'
end

post_install do |installer| 
  installer.pods_project.targets.each  do |target| 
      target.build_configurations.each  do |config| 
	config.build_settings['SWIFT_VERSION'] = '3.0' 
      end 
   end 
end
