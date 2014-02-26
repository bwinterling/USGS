# Usgesus

Usegus is a wrapper gem for the waterservices.usgs.gov api. It allows 
you to query the api for a particular streams details .

## Installation

Add this line to your application's Gemfile:

    gem 'usgesus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install usgesus

## Usage

The information you can get with this gem are listed below:

* **by_gauge** - This method requires a 8 digit string to be used as the id
```ruby
    Usegesus::Request.by_gauge("09057500")
```
* This is the returned gauge object containing all the recent streamflow data
```ruby
    #<Usgesus::Gauge:0x007f875d878ac0
        @gauge_id="09057500",
        @geo_location=
        {"srs"=>"EPSG:4326", "latitude"=>39.88026354, "longitude"=>-106.3339175},
        @measurements=
        [{"dateTime"=>"1999-09-30T00:00:00.000-04:00",
        "unit"=>"deg C",
        "value"=>"13.3"},
        {"dateTime"=>"1999-09-30T00:00:00.000-04:00",
        "unit"=>"deg C",
        "value"=>"12.7"},
        {"dateTime"=>"2014-02-25T00:00:00.000-05:00",
        "unit"=>"ft3/s",
        "value"=>"393"},
        {"dateTime"=>"1999-09-30T00:00:00.000-04:00",
        "unit"=>"uS/cm @25C",
        "value"=>"185"}],
        @provider="usgs",
        @site_name="BLUE RIVER BELOW GREEN MOUNTAIN RESERVOIR, CO"
    >
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/duolingo/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
