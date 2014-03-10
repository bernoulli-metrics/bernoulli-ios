Pod::Spec.new do |spec|
  spec.name         = 'Bernoulli'
  spec.version      = '0.0.2'
  spec.license      =  'MIT'
  spec.homepage     = 'https://github.com/bernoulli-metrics/bernoulli-ios'
  spec.authors      =  { 'Joe Gasiorek' => 'joe.gasiorek@gmail.com' }
  spec.summary      = 'An iOS SDK for the Bernoulli multivariate testing service.'
  spec.source       =  { :git => 'https://github.com/bernoulli-metrics/bernoulli-ios.git', :tag => '0.0.2' }
  spec.public_header_files = 'Bernoulli/Bernoulli.h'
  spec.source_files = 'Bernoulli/Bernoulli.h'
  spec.framework    = 'SystemConfiguration,CFNetwork,CoreGraphics'
  spec.requires_arc = true
  spec.ios.deployment_target = '7.0'
  spec.dependency 'AFNetworking'
end
