# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

# Lints
pod 'SwiftLint' , '0.25.1'

target 'YATodo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # use_modular_headers!

  # DI
  pod 'Swinject', '2.4.0'

  $Rx = '4.1.2'
  pod 'RxSwift', $Rx
  pod 'RxCocoa', $Rx

  # Network
  $Moya = '11.0.2'
  pod 'Moya', $Moya
  pod 'Moya/RxSwift', $Moya
  
  # DB
  pod 'RxGRDB', '0.10.0'

  # Custom Views
  pod 'Reusable', '4.0.2'
  
  # UI
  $MaterialComponents = '54.2.0'
  pod 'MaterialComponents/AppBar', $MaterialComponents
  pod 'MaterialComponents/AppBar+Extensions/ColorThemer', $MaterialComponents
  pod 'MaterialComponents/Buttons', $MaterialComponents
  pod 'MaterialComponents/Buttons+Extensions/ColorThemer', $MaterialComponents
  pod 'MaterialComponents/Themes', $MaterialComponents
  pod 'MaterialComponents/Collections', $MaterialComponents
  pod 'MaterialComponents/TextFields', $MaterialComponents
  pod 'MaterialComponents/TextFields+Extensions/ColorThemer', $MaterialComponents
  pod 'MaterialComponents/ActivityIndicator', $MaterialComponents
  pod 'MaterialComponents/ActivityIndicator+Extensions', $MaterialComponents
  
  # Colors
  pod 'Hue', '3.0.1'
  
  # Icons
  pod 'MaterialDesignSymbol', '2.2.2'
  
  # URLs
  pod 'URLPatterns', '0.2.0'

  target 'YATodoTests' do
    inherit! :search_paths
    
    pod 'RxBlocking', $Rx
    pod 'Quick', '1.2.0'
    pod 'Nimble', '7.1.0'
    pod 'Nimble-Snapshots', '6.6.0'
    pod 'OHHTTPStubs/Swift', '6.1.0'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
