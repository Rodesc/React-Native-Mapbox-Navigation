
Pod::Spec.new do |s|



  s.name         = "Polyline"
  s.version      = "4.2.1"
  s.summary      = "Polyline encoder / decoder in swift"
  s.description  = <<-DESC
                   A Google Polyline encoder / decoder in swift
                   * Encodes Polyline from [CLLocation] or from [CLLocationCoordinate2D]
                   * Decodes Polyline to [CLLocation] or to [CLLocationCoordinate2D]
                   * Encodes/Decodes associated levels
                   DESC
  s.homepage     = "https://github.com/raphaelmor/Polyline"
  s.license      = { :type => "MIT", :file => "LICENSE.txt" }
  s.author             = { "Raphaël Mor" => "raphael.mor@gmail.com" }
  s.social_media_url   = "http://twitter.com/raphaelmor"
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/raphaelmor/Polyline.git", :tag => "v#{s.version.to_s}" }
  s.source_files  = "Sources/Polyline"
  s.swift_version = '4.0'
  s.requires_arc = true
end