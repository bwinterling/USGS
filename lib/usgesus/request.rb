module Usgesus
  class Request

    def self.measurements_by(input, date_range = nil)
      response = make_api_request(input, date_range)
      return response if response[:status] == "Invalid Request"
      time_series = response["value"]["timeSeries"]

      streams = Hash.new

      time_series.each do |ts|
        site_id = ts["sourceInfo"]["siteCode"].first["value"]
        values =  ts["values"].first["value"]
        unit = ts["variable"]["unit"]["unitAbbreviation"]
        measurements = []

        unless streams.key?(site_id)
          streams[site_id] = {}
          streams[site_id][:sitename] = ts["sourceInfo"]["siteName"]
          streams[site_id][:geolocation] =  ts["sourceInfo"]["geoLocation"]["geogLocation"]
          streams[site_id][:measurements] = measurements
        end

        values.each do |value|
          streams[site_id][:measurements] << {
            "dateTime" => value["dateTime"],
            "unit" => unit,
            "value" => value["value"]
          }
        end

      end


      streams.map do |gauge_id, data|
        Usgesus::Gauge.new(
          gauge_id:  gauge_id,
          site_name: data[:sitename],
          geo_location:  data[:geolocation],
          measurements: data[:measurements]
        )
      end

    end

    def self.by_gauge(id, date_range = nil)
      response = make_api_request(id, date_range)
      return response if response[:status] == "Invalid Request"
      time_series = response["value"]["timeSeries"]

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


    def self.by_state(state_abbr, date_range=nil)
      response = make_api_request(state_abbr, date_range)
      time_series = response["value"]["timeSeries"]

      streams = Hash.new

      time_series.each do |ts|
        site_id = ts["sourceInfo"]["siteCode"].first["value"]
        values =  ts["values"].first["value"]
        unit = ts["variable"]["unit"]["unitAbbreviation"]
        measurements = []

        unless streams.key?(site_id)
          streams[site_id] = {}
          streams[site_id][:sitename] = ts["sourceInfo"]["siteName"]
          streams[site_id][:geolocation] =  ts["sourceInfo"]["geoLocation"]["geogLocation"]
          streams[site_id][:measurements] = measurements
        end

        save_measurements(values, unit, measurements)
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

    def self.make_api_request(input, date_range=nil)
      base_url = "http://waterservices.usgs.gov/nwis/dv/?format=json"
      # testing if State Code or Gauge Id was passed as input
      if input.length == 2 && date_range
        request_params = "&stateCD=#{input}&startDT=#{date_range.first.to_s}&endDT=#{date_range.last.to_s}"
      elsif input.length == 2
        request_params = "&stateCD=#{input}"
      elsif input.length == 8 && date_range
        request_params = "&sites=#{input}&startDT=#{date_range.first.to_s}&endDT=#{date_range.last.to_s}"
      elsif input.length == 8
        request_params = "&sites=#{input}"
      else
        return {:status => "Invalid Request"}
      end

      response = Faraday.get(base_url + request_params)
      JSON.parse(response.body)
    end

    def self.save_measurements(values, unit, measurements)
      values.each do |value|
        measurements << {
          "dateTime" => value["dateTime"],
          "unit" => unit,
          "value" => value["value"]
        }
      end
    end

  end
end
