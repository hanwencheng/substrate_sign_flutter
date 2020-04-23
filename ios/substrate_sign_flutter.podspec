#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint substrate_sign_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'substrate_sign_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Substrate signing bindings in flutter'
  s.description      = <<-DESC
Substrate signing bindings in flutter
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Hanwen Cheng' => 'heawen.cheng@gmail.com' }
  s.source           = { :path => '.' }
  s.public_header_files = 'Classes**/*.h'
  s.static_framework = true
  s.vendored_libraries = "**/*.a"
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
