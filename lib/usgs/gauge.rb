module Usgs
  class Gauge
    attr_reader :provider
    attr_accessor :gauge_id, :site_name, :geo_location, :state, :datetime, :cubic_data, :gauge_data

    CubicFeet = Struct.new(:value, :unit)
    GaugeHeight = Struct.new(:value, :unit)
    def initialize(params={})
      @provider = "usgs"
      @gauge_id = params[:gauge_id] || ""
      @site_name = params[:site_name] || ""
      @state = params[:state] || ""
      @geo_location = params[:geo_location] || {}
      # @measurements = params[:measurements] || []
      parse_measurement_data(params[:measurements])
      @datetime = params[:datetime]
    end

    def parse_measurement_data(measurements)
      measurements.each_with_index do |measurement, index|
        if measurement["unit"].include?("cubic")
          @cubic_data = CubicFeet.new(measurement["value"], measurement["unit"])
        else
          @gauge_data = GaugeHeight.new(measurement["value"], measurement["unit"])
        end
      end
    end
  end
end
