# encoding: utf-8
require 'logstash/filters/base'
require 'logstash/namespace'

require 'java'
require "logstash-filter-fastgeoip_jars"

java_import 'com.libertyglobal.GeoipFacade'

module JavaIO
  include_package "java.io"
end

# This  filter will replace the contents of the default 
# message field with whatever you specify in the configuration.
#
# It is only intended to be used as an .
class LogStash::Filters::Fastgeoip < LogStash::Filters::Base
  config_name "fastgeoip"

  config :asn_v4_data_file, :validate => :path, :default => nil

  config :asn_v6_data_file, :validate => :path, :default => nil

  config :country_data_dir, :validate => :path, :default => nil

  config :source, :validate => :string, :required => true

  config :fields, :validate => :array, :default => ['asn', 'as_name', 'continent_code',
                                                    'continent_name', 'country_code', 'country_name']

  config :target, :validate => :string, :default => 'geoip'

  config :tag_on_failure, :validate => :array, :default => ["_geoip_lookup_failure"]

  public
  def register
    @logger.info("Using asn database for ip v4", :path => @asn_v4_data_file)
    @logger.info("Using asn database for ip v6", :path => @asn_v6_data_file)
    @logger.info("Using country database", :path => @country_data_dir)

    begin
      @geoip_facade = GeoipFacade.new(@asn_v4_data_file, @asn_v6_data_file, @country_data_dir);
    rescue java.lang.Exception => e
      @logger.error("Geoip database loading error.", :exception => e, :field => @source)
      raise e
    end
  end

  public
  def filter(event)
    begin
      ip = event.get(@source)
      asn_assets = @geoip_facade.findAsnForIp(ip)

      if !asn_assets.nil?
        country = asn_assets.getCountry
        country = @geoip_facade.findCountryForIp(ip) if country.nil?
      else
        country = nil
      end

      if asn_assets.nil? && country.nil?
        tag_unsuccessful_lookup(event)
      else
        populate_geo_data(event, asn_assets, country)
      end

      filter_matched(event)
    rescue java.lang.Exception => e
      @logger.error("Unknown error while looking up GeoIP data", :exception => e, :field => @source, :ip => ip, :event => event)
      tag_unsuccessful_lookup(event)
    end
  end

  def populate_geo_data(event, asn_assets, country)
    return if asn_assets.nil? && country.nil?

    event.set(@target, {}) if event.get(@target).nil?

    @fields.each do |field|
      case field
        when "asn"
          event.set("[#{@target}][asn]", asn_assets.getAsn) unless asn_assets.nil?
        when "as_name"
          event.set("[#{@target}][as_name]", asn_assets.getCompany) unless asn_assets.nil?
        when "continent_code"
          event.set("[#{@target}][continent_code]", country.getContinentCode) unless country.nil?
        when "continent_name"
          event.set("[#{@target}][continent_name]", country.getContinentName) unless country.nil?
        when "country_code"
          event.set("[#{@target}][country_code]", country.getIsoCode) unless country.nil?
        when "country_name"
          event.set("[#{@target}][country_name]", country.getName) unless country.nil?
        else
          raise Exception.new("[#{field}] is not a supported field option.")
      end
    end
  end

  def tag_unsuccessful_lookup(event)
    @tag_on_failure.each { |tag| event.tag(tag) }
  end

end