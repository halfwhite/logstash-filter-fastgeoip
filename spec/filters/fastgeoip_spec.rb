# encoding: utf-8
require_relative '../spec_helper'
require "logstash/filters/fastgeoip"

describe LogStash::Filters::Fastgeoip do
  describe "Geting normal ASN" do
    let(:config) do <<-CONFIG
      filter {
        fastgeoip {
          source => "ip"
          database => "E:/halfwhite/IdeaProjects/FastGeoip/src/test/resources/GeoIPASNum2.csv"
        }
      }
    CONFIG
    end

    sample("ip" => "89.110.53.166") do
      expect(subject).to include("ip")
      expect(subject.get('target')).to eq('AS8997 PJSC Rostelecom')
    end
  end
end
