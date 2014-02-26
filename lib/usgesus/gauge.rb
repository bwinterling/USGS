module Usgesus
  class Gauge
    attr_reader :provider
    attr_accessor :gauge_id, :site_name, :geo_location, :measurements

    def initialize(params={})
      @provider = "usgs"
      @gauge_id = params[:gauge_id] || ""
      @site_name = params[:site_name] || ""
      @geo_location = params[:geo_location] || {}
      @measurements = params[:measurements] || []
    end

  end
end
