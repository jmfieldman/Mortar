Pod::Spec.new do |s|

  s.name         = "Mortar"
  s.version      = "0.10.3"
  s.summary      = "Auto Layout in Swift using concise, powerful, flexible syntax"

  s.description  = <<-DESC
                   Code your Auto Layout constraints in Swift: view1.m_left |=| view2.m_right + 10
                   DESC

  s.homepage     = "https://github.com/jmfieldman/Mortar"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Jason Fieldman" => "jason@fieldman.org" }
  s.social_media_url = 'http://fieldman.org'

  s.ios.deployment_target = "8.0"
  #s.osx.deployment_target = "10.10"
  #s.tvos.deployment_target = "9.0"

  s.source = { :git => "https://github.com/jmfieldman/Mortar.git", :tag => "#{s.version}" }
  s.source_files = "Mortar/*.swift"

  s.requires_arc = true

end