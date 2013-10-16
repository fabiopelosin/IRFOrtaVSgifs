#
# Be sure to run `pod spec lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about the attributes see http://docs.cocoapods.org/specification.html
#
Pod::Spec.new do |s|
  s.name         = "IRFOrtaVSgifs"
  s.version      = "0.1.0"
  s.summary      = "A short description of IRFOrtaVSgifs."
  s.description  = <<-DESC
                    An optional longer description of IRFOrtaVSgifs

                    * Markdown format.
                    * Don't worry about the indent, we strip it!
                   DESC
  s.homepage     = "http://EXAMPLE/NAME"
  s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license      = 'MIT'
  s.author       = { "Fabio Pelosin" => "fabiopelosin@gmail.com" }
  s.source       = { :git => "http://EXAMPLE/NAME.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files = 'Classes'
  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.dependency 'AFNetworking', '~> 1.0'
end
