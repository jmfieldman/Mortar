Pod::Spec.new do |s|

  s.name         = "Mortar"
  s.version      = "1.6.1"
  s.summary      = "Auto Layout in Swift using concise, powerful, flexible syntax"

  s.description  = <<-DESC
                   Code your Auto Layout constraints in Swift: view1.m_left |=| view2.m_right + 10
                   DESC

  s.homepage     = "https://github.com/jmfieldman/Mortar"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Jason Fieldman" => "jason@fieldman.org" }
  s.social_media_url = 'http://fieldman.org'

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "9.0"
  s.swift_version = '5.0'
  s.swift_versions = ['4.2', '5.0'] if s.respond_to?(:swift_versions) # Cocoapods >=1.7.0

  s.source = { :git => "https://github.com/jmfieldman/Mortar.git", :tag => "#{s.version}" }
  s.source_files = "Mortar/*.swift"

  s.requires_arc = true

  s.default_subspec = 'Core'
  s.subspec 'Core' do |ss|
    ss.source_files = "Mortar/*.swift"
  end

  s.subspec 'MortarVFL' do |ss|
    ss.source_files = "Mortar/MortarVFL/*.swift"
    ss.dependency 'Mortar/Core'
  end

  s.subspec 'Core_NoCreatable' do |ss|
    ss.source_files = "Mortar/*.swift"
    ss.exclude_files = "Mortar/NSObject+Mortar.swift", "Mortar/MortarVFL/**"
  end

  s.subspec 'MortarVFL_NoCreatable' do |ss|
    ss.source_files = "Mortar/MortarVFL/*.swift"
    ss.dependency 'Mortar/Core_NoCreatable'
  end

end
