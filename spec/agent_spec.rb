require 'spec_helper'
require './lib/usgesus/request'

describe Usgesus::Request do
  it "should return recent streamflow by gauge id" do
    gauge_id = "09057500"
    site_name = "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    expect(Usgesus::Request.by_gauge(gauge_id).site_name).to eq site_name
  end

  it "should return streamflow by gauge id for a specific date" do
    gauge_id = "09057500"
    site_name = "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    date_range = ((Date.today - 2)..Date.today)

    response = Usgesus::Request.by_gauge(gauge_id, date_range)
    measurements = response.measurements
    in_date_range = measurements.all? { |msmt| date_range.include?(Date.parse(msmt["dateTime"])) }

    expect(response.site_name).to eq site_name
    expect(in_date_range).to be_true
  end

  it "should return recent streamflow by state" do
    state = "AK"
    streams = Usgesus::Request.by_state(state)
    number_of_streams = streams.count
    expect(number_of_streams).to eq 534
    expect(streams.first.gauge_id).to eq "15008000"
  end

  it "should return streamflow by state for a specific date" do
    state = "AK"
    date_range = ((Date.today - 2)..Date.today)
    streams = Usgesus::Request.by_state(state, date_range)
    #site name ends with state code
    expect(streams.first.site_name[-3..-1]).to include(state)
    #measurements date is within our date range
   streams.first.measurements.each do |m|
     expect(date_range).to include(Date.parse(m["dateTime"]))
   end
  end
end
