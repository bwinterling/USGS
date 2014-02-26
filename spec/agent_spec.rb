require 'spec_helper'
require './lib/usgesus/request'

describe Usgesus::Request do
  it "should return recent streamflow by gauge id" do
    gauge_id = "09057500"
    site_name = "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    response = Usgesus::Request.measurements_by(gauge_id)
    puts "GaugeOnlyNew: #{response}"

    test_response = Usgesus::Request.by_gauge(gauge_id)
    puts "GaugeOnlyOld: #{test_response.inspect}"

    expect(response.first.site_name).to eq site_name
  end

  it "should return streamflow by gauge id for a specific date" do
    gauge_id = "09057500"
    site_name = "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    date_range = ((Date.today - 2)..Date.today)
    response = Usgesus::Request.measurements_by(gauge_id, date_range).first
    puts "GaugeDateNew: #{response.inspect}"

    test_response = Usgesus::Request.by_gauge(gauge_id, date_range)
    puts "GaugeDateOld: #{test_response.inspect}"

    measurements = response.measurements
    in_date_range = measurements.all? { |msmt| date_range.include?(Date.parse(msmt["dateTime"])) }
    expect(response.site_name).to eq site_name
    expect(in_date_range).to be_true
  end

  xit "should return recent streamflow by state" do
    state = "AK"
    response = Usgesus::Request.measurements_by(state)
    number_of_streams = response.count
    expect(number_of_streams).to eq 534
    expect(response.first.gauge_id).to eq "15008000"
  end

  xit "should return streamflow by state for a specific date" do
    state = "AK"
    date_range = ((Date.today - 2)..Date.today)
    response = Usgesus::Request.measurements_by(state, date_range)
    #site name ends with state code
    expect(response.first.site_name[-3..-1]).to include(state)
    #measurements date is within our date range
    response.first.measurements.each do |m|
      expect(date_range).to include(Date.parse(m["dateTime"]))
    end
  end

  xit "should return Invalid Request if statecode or gauge_id are incorrect" do
    response = Usgesus::Request.measurements_by("BOOM")
    expect(response[:status]).to eq "Invalid Request"
  end

  xit "should make request for either state or gauge_id" do
    gauge_id = "09057500"
    site_name = "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    expect(Usgesus::Request.measurements_by(gauge_id).first.site_name).to eq site_name
  end

end
