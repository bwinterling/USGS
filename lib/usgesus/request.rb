module Usgesus
  class Request

    def self.by_gauge(id, date_range = nil)
      # date range should use Date format
      if date_range
        response = Faraday.get(
        "http://waterservices.usgs.gov/nwis/dv/?format=json&sites=#{id}&startDT=#{date_range.first.to_s}&endDT=#{date_range.last.to_s}"
        )
      else
        response = Faraday.get(
        "http://waterservices.usgs.gov/nwis/dv/?format=json&sites=#{id}"
        )
      end

      time_series = JSON.parse(response.body)["value"]["timeSeries"]

      gauge = Usgesus::Gauge.new

      measurements = []

      time_series.each do |ts|
        gauge.gauge_id = ts["sourceInfo"]["siteCode"].first["value"]
        gauge.site_name =  ts["sourceInfo"]["siteName"]
        gauge.geo_location = ts["sourceInfo"]["geoLocation"]["geogLocation"]
        unit = ts["variable"]["unit"]["unitAbbreviation"]
        values = ts["values"].first["value"]
        values.each do |value|
          measurements << {
            "dateTime" => value["dateTime"],
            "unit" => unit,
            "value" => value["value"]
          }
        end
      end
      gauge.measurements = measurements
      gauge
    end

    def self.by_state(state_abbr)
      response = Faraday.get(
        "http://waterservices.usgs.gov/nwis/dv/?format=json&stateCd=#{state_abbr}"
        )
      time_series = JSON.parse(response.body)["value"]["timeSeries"]

      #for each hash in the time series
        #add the site_id as the key

          #add site_name to that key
          #add geo_location to that key
          #capture unit
          #for each value, add measurement hash to key

      time_series.each do |ts|
        binding.pry
      end
      #return array of gauges objects
    end

  end
end
