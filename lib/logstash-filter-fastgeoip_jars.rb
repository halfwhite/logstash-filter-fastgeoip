# this is a generated file, to avoid over-writing it just delete this comment
begin
  require 'jar_dependencies'
rescue LoadError
  require 'com/libertyglobal/logstash/filter-geoip/0.1.0/filter-geoip-0.1.0.jar'
  require 'junit/junit/4.11/junit-4.11.jar'
  require 'org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar'
  require 'org/apache/commons/commons-csv/1.2/commons-csv-1.2.jar'
end

if defined? Jars
  require_jar( 'com.libertyglobal.logstash', 'filter-geoip', '0.1.0' )
  require_jar( 'junit', 'junit', '4.11' )
  require_jar( 'org.hamcrest', 'hamcrest-core', '1.3' )
  require_jar( 'org.apache.commons', 'commons-csv', '1.2' )
end
