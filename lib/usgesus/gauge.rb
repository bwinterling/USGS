module Usgesus
  class Gauge
    attr_reader :provider
    attr_accessor :gauge_id, :site_name, :geo_location, :measurments

    def initialize
      @provider = "usgs"
    end

  end
end
