require 'spec_helper'
require './lib/usgs/request'

describe Usgs::Request do
  it "should return recent streamflow by gauge id" do
    gauge_id = "09057500"
    site_name = "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    response = Usgs::Request.measurements_by(gauge_id)
    expect(response.first.site_name).to eq site_name
  end

  it "should return streamflow by gauge id for a specific date" do
    gauge_id = "09057500"
    site_name = "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    date_range = ((Date.today - 2)..Date.today)
    response = Usgs::Request.measurements_by(gauge_id, date_range).first
    in_date_range = date_range.include?(Date.parse(response.datetime))
    expect(response.site_name).to eq site_name
    expect(in_date_range).to be true
  end

  it "should return recent streamflow by state" do
    state = "AK"
    response = Usgs::Request.measurements_by(state)
    number_of_streams = response.count
    expect(number_of_streams).to eq 136
    expect(response.first.gauge_id).to eq "15008000"
  end

  it "should return streamflow by state for a specific date" do
    state = "AK"
    date_range = ((Date.today - 2)..Date.today)
    response = Usgs::Request.measurements_by(state, date_range)
    #site name ends with state code
    expect(response.first.site_name[-3..-1]).to include(state)
    #measurements date is within our date range
    expect(date_range).to include(Date.parse(response.first.datetime))
  end

  it "should return Invalid Request if statecode or gauge_id are incorrect" do
    response = Usgs::Request.measurements_by("BOOM")
    expect(response[:status]).to eq "Invalid Request"
  end

end
