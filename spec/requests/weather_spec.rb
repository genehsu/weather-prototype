# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Weather', type: :request do
  describe 'GET /current' do
    it 'is successful' do
      get '/weather/current'
      expect(flash[:error]).not_to be_present
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:current)
    end

    context "with a zip code that isn't 5 digits" do
      let(:zip) { '12345a' }
      it 'sets a flash error message' do
        get '/weather/current', params: { zip: zip }
        expect(flash[:error]).to be_present
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:current)
      end
    end

    context "with a 5 digit zip code that doesn't exist" do
      let(:zip) { '99999' }
      it 'sets a flash error message' do
        expect(WeatherApi).to receive(:current_by_zip).with(zip).and_return(nil)
        get '/weather/current', params: { zip: zip }
        expect(flash[:error]).to be_present
        expect(response).to have_http_status(:success)
      expect(response).to render_template(:current)
      end
    end

    context "with a 5 digit zip code that returns data" do
      let(:zip) { '12345' }
      let(:weather_data) do
        {
          main: { temp: 40, temp_min: 30, temp_max: 50 },
          dt: Time.current.to_i,
          timezone: -7.hours,
          name: 'Test City',
        }.as_json
      end
      it 'is successful' do
        expect(WeatherApi).to receive(:current_by_zip).with(zip).and_return(weather_data)
        get '/weather/current', params: { zip: zip }
        expect(flash[:error]).not_to be_present
        expect(response).to have_http_status(:success)
        expect(response).to render_template(:current)
      end
    end
  end
end
