Pod::Spec.new do |s|
 s.name = 'Restofire'
 s.version = '5.0.0-alpha.4'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'Restofire is a protocol oriented networking client for Alamofire.'
 s.description = 'Restofire is a protocol oriented networking client for Alamofire.'
 s.homepage = 'https://github.com/Restofire/Restofire'
 s.social_media_url = 'https://twitter.com/rahulkatariya91'
 s.authors = { "Rahul Katariya" => "rahulkatariya@me.com" }
 s.source = { :git => "https://github.com/Restofire/Restofire.git", :tag => "v"+s.version.to_s }
 s.platforms = { :ios => "10.0", :osx => "10.12", :tvos => "10.0", :watchos => "3.0" }
 s.requires_arc = true

 s.default_subspec = "Core"
 s.subspec "Core" do |ss|
     ss.source_files  = "Sources/**/*.swift"
     ss.dependency "Alamofire", "~> 5.0.0-beta.3"
     ss.framework  = "Foundation"
 end

end
