#
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
# Run `pod lib lint wallet.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'wallet'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for integrating with Apple Wallet.'
  s.description      = <<-DESC
  A Flutter plugin that allows you to add passes to Apple Wallet.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '13.0' # Updated to iOS 11.0 as the minimum deployment target

  # Flutter.framework does not contain an i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' # Explicitly exclude i386 architecture
  }

  s.swift_version = '5.0' # Ensure Swift 5.0 compatibility
end