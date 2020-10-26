# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'bookings/index', type: :view do
  before(:each) do
    @home_location = '64 Rigger Rd, Spartan, Kempton Park, 1619'
    @booking = Booking.new
    @trips = []
  end

  it 'renders the page successfully' do
    render
    assert_select 'h1', text: 'Bookings'.to_s, count: 1
  end
end
