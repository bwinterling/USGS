module Usgs
  class Gauge
    attr_reader :provider
    attr_accessor :gauge_id, :site_name, :geo_location, :measurements, :state

    def initialize(params={})
      @provider = "usgs"
      @gauge_id = params.fetch(:gauge_id, "")
      @gauge_id = params.fetch(:gauge_id, "")
      @site_name = params.fetch(:site_name, "")
      @state = params.fetch(:state, "")
      @geo_location = params.fetch(:geo_location, {})
      @measurements = params.fetch(:measurements, [])
    end
  end
end
