require 'spec_helper'
require './lib/usgesus/request'

describe Usgesus::Request do
  it "should return recent streamflow by gauge id" do
    gauge_id = "09057500"
    site_name = "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    expect(Usgesus::Request.by_gauge(gauge_id)["site_name"]).to eq site_name
  end
  it "should return streamflow by gauge id for a specific date"
  it "should return recent streamflow by state"
  it "should return streamflow by state for a specific date"
end
