module Usgs
  class Request

    def self.measurements_by(input, date_range = nil)
      response = make_api_request(input, date_range)
      return response if response[:status] == "Invalid Request"
      time_series = response["value"]["timeSeries"]
      # create a hash using gauge_id as the key
      # this accounts for the USGS api response where multiple timeSeries
      # objects exist for the same gauge_id
      streams = Hash.new
      time_series.each do |ts|
        site_id = ts["sourceInfo"]["siteCode"].first["value"]
        state_property = ts["sourceInfo"]["siteProperty"].find { |p| p["name"] == "stateCd" }
        state = state_lookup[state_property["value"]]
        values =  ts["values"].first["value"]
        unit = ts["variable"]["variableDescription"]
        measurements = []

        unless streams.key?(site_id)
          streams[site_id] = {}
          streams[site_id][:sitename] = ts["sourceInfo"]["siteName"]
          streams[site_id][:state] = state
          streams[site_id][:geolocation] =  ts["sourceInfo"]["geoLocation"]["geogLocation"]
          streams[site_id][:measurements] = measurements
        end

        values.each do |value|
          streams[site_id][:measurements] << {
            "unit" => unit,
            "value" => value["value"]
          }
          streams[site_id][:dateTime] = value["dateTime"]
        end
      end

      # convert the hash to individual gauge objects
      streams.map do |gauge_id, data|
        Usgs::Gauge.new(
          gauge_id:  gauge_id,
          site_name: data[:sitename],
          state: data[:state],
          geo_location:  data[:geolocation],
          measurements: data[:measurements],
          datetime: data[:dateTime]
        )
      end
    end

    private

    def self.make_api_request(input, date_range=nil)
      base_url = "https://waterservices.usgs.gov/nwis/iv/?format=json"
      if input.length == 2 && date_range
        request_params = "&stateCd=#{input}&startDT=#{date_range.first.to_s}&endDT=#{date_range.last.to_s}"
      elsif input.length == 2
        request_params = "&stateCd=#{input}"
      elsif input.length >= 8 && date_range
        request_params = "&sites=#{input}&startDT=#{date_range.first.to_s}&endDT=#{date_range.last.to_s}"
      elsif input.length >= 8
        request_params = "&sites=#{input}"
      else
        return {:status => "Invalid Request"}
      end

      response = Faraday.get(base_url + request_params)
      JSON.parse(response.body)
    end

    def self.state_lookup
      {
        "01"=>"AL","02"=>"AK","04"=>"AZ","05"=>"AR","06"=>"CA","08"=>"CO",
        "09"=>"CT","10"=>"DE","11"=>"DC","12"=>"FL","13"=>"GA","15"=>"HI",
        "16"=>"ID","17"=>"IL","18"=>"IN","19"=>"IA","20"=>"KS","21"=>"KY",
        "22"=>"LA","23"=>"ME","24"=>"MD","25"=>"MA","26"=>"MI","27"=>"MN",
        "28"=>"MS","29"=>"MO","30"=>"MT","31"=>"NE","32"=>"NV","33"=>"NH",
        "34"=>"NJ","35"=>"NM","36"=>"NY","37"=>"NC","38"=>"ND","39"=>"OH",
        "40"=>"OK","41"=>"OR","42"=>"PA","44"=>"RI","45"=>"SC","46"=>"SD",
        "47"=>"TN","48"=>"TX","49"=>"UT","50"=>"VT","51"=>"VA","53"=>"WA",
        "54"=>"WV","55"=>"WI","56"=>"WY"
      }
    end

  end
end
