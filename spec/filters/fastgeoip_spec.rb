# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/fastgeoip"

describe LogStash::Filters::Fastgeoip do
  describe "Geting normal ASN" do
    let(:config) do <<-CONFIG
      filter {
        fastgeoip {
          source => "ip"
          asn_v4_data_file => "E:/halfwhite/IdeaProjects/FastGeoip/src/test/resources/GeoIPASNum2.csv"
          asn_v6_data_file => "E:/halfwhite/IdeaProjects/FastGeoip/src/test/resources/GeoIPASNum2v6.csv"
          country_data_dir => "E:/halfwhite/IdeaProjects/FastGeoip/src/test/resources/GeoLite2-Country-CSV_20170207"
          target => "geoip" 
        }
      }
    CONFIG
    end

    sample("ip" => "89.110.53.166") do
      expect(subject).to include("ip")
      expect(subject.get('[geoip][asn]')).to eq(8997)
    end

    sample("ip" => "127.0.0.1") do
      expect(subject).to include("ip")
      expect(subject.get('[tags]')).to eq(["_geoip_lookup_failure"])
    end
  end
end
