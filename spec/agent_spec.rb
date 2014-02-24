require 'spec_helper'
require './lib/usgesus/request'

describe Usgesus::Request do
  it "should return recent streamflow by gauge id" do
    gauge_id = "09057500"
    site_name = "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    expect(Usgesus::Request.by_gauge(gauge_id)["site_name"]).to eq site_name
  end
  xit "should return streamflow by gauge id for a specific date" do
    gauge_id = "09057500"
    site_name = "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    date_range = ((Date.today - 2)..Date.today)
    response = Usgesus::Request.by_gauge(gauge_id, date_range)
    measurements = response["measurements"]
    in_date_range = measurements.all? { |msmt| date_range.include?(Date.parse(msmt["date"])) }
    expect(response["site_name"]).to eq site_name
    #test measurements.each { |msmt| msmt["date"] is within date_range }
    expect(in_date_range).to be_true
  end
  it "should return recent streamflow by state"
  it "should return streamflow by state for a specific date"
end
