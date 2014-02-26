module Usgesus
  class Request

    def self.by_gauge(id, date_range = nil)
      response = site(id, "sites", date_range)
      time_series = JSON.parse(response.body)["value"]["timeSeries"]

      gauge = Usgesus::Gauge.new
      measurements = []

      time_series.each do |ts|
        gauge.gauge_id = ts["sourceInfo"]["siteCode"].first["value"]
        gauge.site_name =  ts["sourceInfo"]["siteName"]
        gauge.geo_location = ts["sourceInfo"]["geoLocation"]["geogLocation"]
        values = ts["values"].first["value"]

        save_measurements(values, measurements)
      end

      gauge.measurements = measurements
      gauge
    end


    def self.by_state(state_abbr, date_range=nil)
      response = site(state_abbr, "stateCD", date_range)
      time_series = JSON.parse(response.body)["value"]["timeSeries"]
      streams = Hash.new

      time_series.each do |ts|
        site_id = ts["sourceInfo"]["siteCode"].first["value"]
        values =  ts["values"].first["value"]
        measurements = []

        unless streams.key?(site_id) 
          streams[site_id] = {}
          streams[site_id][:sitename] = ts["sourceInfo"]["siteName"]
          streams[site_id][:geolocation] =  ts["sourceInfo"]["geoLocation"]["geogLocation"]
          streams[site_id][:measurements] = measurements
        end

        save_measurements(values, measurements)
      end
      save_state_gauges(streams)
    end

    private

    def self.save_state_gauges(streams)
      streams.map do |gauge_id, data|
        Usgesus::Gauge.new(
          gauge_id:  gauge_id,
          site_name: data[:sitename],
          geo_location:  data[:geolocation],
          measurements: data[:measurements]
        )
      end
    end

    def self.site(input, type, date_range=nil)
      if type == "sites" && date_range
        Faraday.get(
          "http://waterservices.usgs.gov/nwis/dv/?format=json&#{type}=#{input}&startDT=#{date_range.first.to_s}&endDT=#{date_range.last.to_s}"
        )
      elsif type == "stateCD" && date_range
        Faraday.get(
          "http://waterservices.usgs.gov/nwis/dv/?format=json&#{type}=#{input}&startDT=#{date_range.first.to_s}&endDT=#{date_range.last.to_s}"
        )
      elsif type == 'sites'
        Faraday.get(
          "http://waterservices.usgs.gov/nwis/dv/?format=json&#{type}=#{input}"
        )
      elsif type == 'stateCD'
        Faraday.get("http://waterservices.usgs.gov/nwis/dv/?format=json&#{type}=#{input}")
      end
    end

    def self.save_measurements(values, measurements)
      values.each do |value|
        measurements << {
          "dateTime" => value["dateTime"],
          "unit" => value["unit"],
          "value" => value["value"]
        }
      end
    end

  end
end
