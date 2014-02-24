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

      measurments = []

      time_series.each do |ts|
        gauge.gauge_id = ts["sourceInfo"]["siteCode"].first["value"]
        gauge.site_name =  ts["sourceInfo"]["siteName"]
        gauge.geo_location = ts["sourceInfo"]["geoLocation"]["geoLocation"]
        #create measurements array
      end

      gauge.measurments = measurments

      #for first item in time series array
        #update gauge id
        #update site_name
        #update geo_location
      #for each item in time series array
        #iterate over the returned values

    end

    def self.gauge_response
      {
        "provider" => "usgs",
        "gauge_id" => "",
        "site_name" => "",
        "geo_location" => [],
        "measurments" => [{
            "date" => "",
            "unit" => "",
            "value" => ""
          }]
      }
    end

  end
end
