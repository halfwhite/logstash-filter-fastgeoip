Gem::Specification.new do |s|
  s.name          = 'logstash-filter-fastgeoip'
  s.version       = '0.1.0'
  s.licenses      = ['Apache-2.0']
  s.summary       = 'Fast geoip search.'
  s.description   = "This gem is a Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname. This gem is not a stand-alone program"
  s.homepage      = 'http://www.libertyglobal.com'
  s.authors       = ['Igor_Polubelov']
  s.email         = 'halfwhite76@gmail.com'
  s.require_paths = ['lib']
  s.platform      = "java"

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency 'logstash-core-plugin-api', '>= 1.60', '<= 2.99'
  s.requirements << "jar com.libertyglobal.logstash:filter-geoip, 0.1.0"
  s.add_runtime_dependency  "jar-dependencies"
  s.add_development_dependency 'ruby-maven', '~> 3.3'
  s.add_development_dependency 'logstash-devutils'
end
