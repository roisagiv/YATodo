# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'YATodo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  $Rx = '4.1.2'
  pod 'RxSwift', $Rx
  pod 'RxCocoa', $Rx

  # Network
  $Moya = '11.0.1'
  pod 'Moya', $Moya
  pod 'Moya/RxSwift', $Moya
  
  $MaterialComponents = '48.0.0'
  pod 'MaterialComponents/AppBar', $MaterialComponents
  pod 'MaterialComponents/AppBar+Extensions/ColorThemer', $MaterialComponents
  pod 'MaterialComponents/Buttons', $MaterialComponents
  pod 'MaterialComponents/Buttons+Extensions/ColorThemer', $MaterialComponents
  pod 'MaterialComponents/Themes', $MaterialComponents
  pod 'MaterialComponents/Collections', $MaterialComponents
  pod 'MaterialComponents/TextFields', $MaterialComponents
  pod 'MaterialComponents/TextFields+Extensions/ColorThemer', $MaterialComponents
  
  target 'YATodoTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
