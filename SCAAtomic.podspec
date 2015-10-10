Pod::Spec.new do |s|
  s.name         = 'SCAAtomic'
  s.version      = '0.0.2'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.summary      = 'A lightweight atomic wrapper in swift and C.'
  s.homepage     = 'https://github.com/seancatkinson/SCAAtomic'
  s.social_media_url = "https://twitter.com/seancatkinson"
  s.authors      = { 'Sean Atkinson' => "seanca.seanca@gmail.com" }
  s.source       = { :git => 'https://github.com/seancatkinson/SCAAtomic.git',
                     :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.source_files = 'Source/*.swift'
  
  s.requires_arc = true
end

