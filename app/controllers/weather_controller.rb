# frozen_string_literal: true

class WeatherController < ApplicationController
  def current
    if zip
      @weather = weather_result
    elsif @zip.present?
      flash[:error] = 'This app only supports 5 digit US Zip Codes'
    end
  end

  protected

  def weather_params
    params.permit(:zip)
  end

  def weather_result
    weather = WeatherApi.current_by_zip(zip)
    if weather
      @cache_hit = WeatherApi.cache_hit
      WeatherPresenter.new(weather)
    else
      flash[:error] = "Cannot find weather for #{zip}, does the zip code exist?"
      @cache_hit = false
    end
  end

  def zip
    @zip ||= weather_params[:zip]
    @zip if @zip =~ /\A\d{5}\z/
  end
end
