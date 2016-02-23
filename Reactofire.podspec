Pod::Spec.new do |s|
 s.name = 'Reactofire'
 s.version = '0.2.0'
 s.license = { :type => "MIT", :file => "LICENSE" }
 s.summary = 'Reactofire is a protocol oriented networking library in swift'
 s.description = 'Reactofire is a protocol oriented networking library in swift that is built on top of Alamofire, Gloss and ReactiveCocoa to use services in a declartive way'
 s.homepage = 'https://github.com/RahulKatariya/Reactofire'
 s.social_media_url = 'https://twitter.com/rahulkatariya91'
 s.authors = { "Rahul Katariya" => "rahulkatariya@me.com" }
 s.source = { :git => "https://github.com/RahulKatariya/RKParallaxEffect.git", :tag => "v"+s.version.to_s }
 s.platforms     = { :ios => "8.0", :osx => "10.9", :tvos => "9.0", :watchos => "2.0" }
 s.requires_arc = true
 s.source_files = 'Sources/*.swift'
 s.dependency 'ReactiveCocoa', '~> 4.0'
 s.dependency 'Alamofire', '~> 3.0'
 s.dependency 'Gloss', '~> 0.7'
end