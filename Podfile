# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'JukeJam' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for JukeJam
pod 'WCLShineButton'
pod 'Spartan'
pod 'Alamofire'
pod 'MarqueeLabel/Swift'
pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
pod 'SPStorkController'
pod 'SCLAlertView'
pod 'NVActivityIndicatorView'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod "GSMessages"
pod 'SwiftIconFont'
pod 'ShadowView'
pod 'Firebase/Core'
pod 'FacebookCore'
pod 'FBSDKLoginKit'
pod 'FBSDKCoreKit'
pod 'FacebookLogin'
pod 'GoogleSignIn'
pod 'SwiftyOnboard'
pod 'FontAwesome.swift'
pod 'SkyFloatingLabelTextField', '~> 3.0'
  target 'JukeJamTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'JukeJamUITests' do
    inherit! :search_paths
    # Pods for testing
  end
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings.delete('CODE_SIGNING_ALLOWED')
    config.build_settings.delete('CODE_SIGNING_REQUIRED')
  end
end
end
