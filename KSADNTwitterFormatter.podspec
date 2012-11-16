Pod::Spec.new do |s|
  s.name         = "KSADNTwitterFormatter"
  s.version      = "0.1.0"
  s.summary      = "A simple class for taking ADN posts and reformatting them to fit into Twitter's length restrictions, taking links into account."
  s.homepage     = "https://github.com/Keithbsmiley/KSADNTwitterFormatter"
  s.license      = 'MIT'
  s.author       = { "Keith Smiley" => "keithbsmiley@gmail.com" }
  s.source       = { :git => "https://github.com/Keithbsmiley/KSADNTwitterFormatter.git", :tag => "0.1.0" }
  s.platform     = :osx
  s.source_files = '*.{h,m}'
  s.requires_arc = true
end
