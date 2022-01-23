# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherApi do
  describe '.current_by_zip' do
    subject { described_class.current_by_zip zip }

    shared_examples 'cache hit is false' do
      context '.cache_hit' do
        it 'is false' do
          described_class.instance_variable_set('@cache', nil)
          subject
          expect(described_class.cache_hit).to be false
        end
      end
    end

    context 'with a valid zip' do
      before do
        stub_request(:get, 'api.openweathermap.org/data/2.5/weather')
          .with(query: hash_including(zip: "#{zip},us"))
          .to_return(body: fake_body, status: 200)
      end
      let(:zip) { 12_345 }
      let(:expected_temps) { %w[temp temp_min temp_max] }
      let(:expected_keys) { %w[dt main name timezone] }
      let(:fake_body) do
        {
          main: { temp: 50, temp_min: 40, temp_max: 50 },
          name: 'Test City',
          dt: Time.current,
          timezone: -7.hours
        }.to_json
      end

      it { is_expected.to include(*expected_keys) }
      it { expect(subject['main']).to include(*expected_temps) }
      include_examples 'cache hit is false'

      context 'on second method call within cache timeout' do
        it '.cache_hit is true' do
          described_class.instance_variable_set('@cache', nil)
          described_class.current_by_zip zip
          expect(described_class.cache_hit).to be false
          subject
          expect(described_class.cache_hit).to be true
        end
      end

      context 'on second method call after cache timeout' do
        it '.cache_hit is false' do
          described_class.instance_variable_set('@cache', nil)
          described_class.current_by_zip zip
          expect(described_class.cache_hit).to be false
          described_class.current_by_zip zip
          expect(described_class.cache_hit).to be true
          Timecop.freeze(described_class.timeout.from_now + 1) do
            subject
            expect(described_class.cache_hit).to be false
          end
        end
      end
    end

    context 'when zip is not 5 digits' do
      let(:zip) { '1234534' }
      it { is_expected.to be nil }
    end

    context "when zip doesn't exist" do
      let(:zip) { 99_999 }
      before do
        stub_request(:get, 'api.openweathermap.org/data/2.5/weather')
          .with(query: hash_including(zip: "#{zip},us"))
          .to_return(body: '', status: 404)
      end
      it { is_expected.to be nil }
      include_examples 'cache hit is false'
    end
  end
end
