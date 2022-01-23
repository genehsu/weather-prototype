# frozen_string_literal: true

class WeatherPresenter
  def initialize(weather)
    @weather = weather
  end

  def round(value)
    value.round(1)
  end

  def degrees_f(value)
    "#{value}°F"
  end

  def temp(value)
    degrees_f(round(value))
  end

  def current
    temp(@weather['main']['temp'])
  end

  def high
    temp(@weather['main']['temp_max'])
  end

  def low
    temp(@weather['main']['temp_min'])
  end

  def current_time
    Time.at(@weather['dt'] + @weather['timezone']).to_fs(:daytime)
  end

  def city_name
    @weather['name']
  end
end
