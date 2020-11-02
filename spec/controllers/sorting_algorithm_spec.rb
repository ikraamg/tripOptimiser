# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sorting algorithm', type: :request do
  before :each do
    @file = fixture_file_upload('bookings.csv', 'csv')
    Booking.import(@file)
  end

  it 'renders a JSON response with expected bookings sorted correctly into trips' do
    get '/bookings.json'
    expect(response).to have_http_status(:ok)
    ### Some tests for correct passengers in trip
    expect(JSON.parse(response.body)[0]['data'].to_s).to include('Michaela Dooley')
    expect(JSON.parse(response.body)[0]['data'].to_s).to include('Tanna Lind Ret')
    expect(JSON.parse(response.body)[0]['data'].to_s).not_to include('Emory Dickinson')
    expect(JSON.parse(response.body)[1]['data'].to_s).to include('Emory Dickinson')
    expect(JSON.parse(response.body)[1]['data'].to_s).not_to include('Kathrin Shanahan')
    ### Tests for ordering and count of items in each trip
    expect(JSON.parse(response.body)[0]['data'].count).to eq 2
    expect(JSON.parse(response.body)[1]['data'].count).to eq 1
    expect(JSON.parse(response.body)[2]['data'].count).to eq 2
    expect(JSON.parse(response.body)[3]['data'].count).to eq 1
    expect(JSON.parse(response.body)[4]['data'].count).to eq 1
    expect(JSON.parse(response.body)[5]['data'].count).to eq 1
    expect(JSON.parse(response.body)[6]['data'].count).to eq 2
    expect(JSON.parse(response.body)[7]['data'].count).to eq 1
    expect(JSON.parse(response.body)[8]['data'].count).to eq 2
    expect(JSON.parse(response.body)[9]['data'].count).to eq 2
    expect(JSON.parse(response.body)[10]['data'].count).to eq 1
    expect(JSON.parse(response.body)[11]['data'].count).to eq 1
    expect(JSON.parse(response.body)[12]['data'].count).to eq 2
  end
end
