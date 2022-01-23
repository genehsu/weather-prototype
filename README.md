# README

This is a quick weather prototype app that uses the OpenWeather API to get the current weather.

This was developed with ruby 3.1, rails 7.0.1, using tailwindcss, basic erb templating, and rspec for testing.

The cache layer is implemented using the default ActiveSupport in-memory cache.

Without the need for much state, I went without database access. With more state or more processes, I'd use an external store to cache the data, either using memcached or redis.

Here's the simplistic UI. I'm not very good at the UI, so I just threw together something fairly basic.

![UI not using cache](https://github.com/genehsu/weather-prototype/blob/main/public/Screenshot%202022-01-22%20221540.png "No Cache Use")

Here's the same UI when it's accessing cache.

![UI using cache](https://github.com/genehsu/weather-prototype/blob/main/public/Screenshot%202022-01-22%20221604.png "Cache Use")
