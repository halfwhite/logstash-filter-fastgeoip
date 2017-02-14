# encoding: utf-8
require "logstash/filters/base"
require "logstash/namespace"

require 'java'
require "logstash-filter-fastgeoip_jars"

java_import "com.libertyglobal.Geoip"

module JavaIO
  include_package "java.io"
end

# This  filter will replace the contents of the default 
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an .
class LogStash::Filters::Fastgeoip < LogStash::Filters::Base

  # Setting the config_name here is required. This is how you
  # configure this filter from your Logstash config.
  #
  # filter {
  #    {
  #     message => "My message..."
  #   }
  # }
  #

  config :database, :validate => :path, :required => true

  config_name "fastgeoip"
  
  # Replace the message with this value.
  config :source, :validate => :string, :required => true
  

  public
  def register
      if @database.nil?
        if @database.nil? || !File.exists?(@database)
          raise "You must specify 'database => ...' in your geoip filter (I looked for '#{@database}')"
        end
      end

      @logger.info("Using geoip database", :path => @database)

#      db_file = JavaIO::File.new(@database)
      begin
        @geoip = Geoip.new(@database);
      rescue JavaIO::IOException => e
        @logger.error("The GeoLite2 MMDB database provided is invalid or corrupted.", :exception => e, :field => @source)
        raise e
      end

  end # def register

  public
  def filter(event)

    ip = event.get(@source)

    event.set("target", @geoip.getAsnForIp(ip))

    # filter_matched should go in the last line of our successful code
    filter_matched(event)
  end # def filter
end # class LogStash::Filters::Fastgeoip
