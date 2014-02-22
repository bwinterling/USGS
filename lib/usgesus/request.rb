module Usgesus
  class Request

    def self.by_gauge(id)
      response = Faraday.get("http://waterservices.usgs.gov/nwis/dv/?format=json&sites=09057500")
      time_series = JSON.parse(response.body)["value"]["timeSeries"]

      {
        "gauge_id" => "09057500",
        "site_name" => "BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO",
        "geo_location" => [],
        "measurments" => [{
            "date" => "",
            "unit" => "",
            "value" => ""
          }],
      }
    end

  end
end
