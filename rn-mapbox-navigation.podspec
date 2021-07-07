require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "rn-mapbox-navigation"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  Smart Mapbox turn-by-turn routing based on real-time traffic for React Native.
                   DESC
  s.homepage     = "https://github.com/Developmenteam30/React-Native-Mapbox-Navigation"
  s.license    = { :type => "Apache-2.0", :file => "LICENSE" }
  s.authors      = { "Curve Infotech" => "infotechcurve@gmail.com" }
  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/Developmenteam30/React-Native-Mapbox-Navigation.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true
  s.swift_version = '5.0'
  s.dependency "React"
  s.dependency "MapboxNavigation", "~> 1.3.0"
end

