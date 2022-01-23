# frozen_string_literal: true

require 'open-uri'

module WeatherApi
  BASE_URI = 'http://api.openweathermap.org/data/2.5/'

  def self.timeout
    30.minutes
  end

  def self.cache
    @cache ||= ActiveSupport::Cache.lookup_store(:memory_store, expires_in: timeout)
  end

  def self.cache_hit
    @cache_hit
  end

  def self.api_key
    ENV['OPENWEATHER_API_KEY']
  end

  def self.current_by_zip(zip)
    @cache_hit = false
    return unless zip.to_s =~ /\A\d{5}\z/

    @cache_hit = true
    cache.fetch(zip.to_s) do
      @cache_hit = false
      current("zip=#{zip},us")
    end
  end

  def self.current(extra_params)
    uri = URI.join(BASE_URI, "weather?appid=#{api_key}&units=imperial&#{extra_params}")
    uri.open do |f|
      return JSON.parse(f.read)
    end
  rescue OpenURI::HTTPError
    nil
  end
end
