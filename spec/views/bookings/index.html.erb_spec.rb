# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'bookings/index', type: :view do
  before(:each) do
    @home_location = '64 Rigger Rd, Spartan, Kempton Park, 1619'
    @booking = Booking.new
    assign(:bookings, [
             Booking.create(passenger: 'Devora Nader', location:	'Kganane Road, Vosloorus, South Africa', destination:	'64 Rigger Rd, Spartan, Kempton Park, 1619', timeslot:	'5:00 AM'.to_time),
             Booking.create(passenger: 'Devora Nader', location:	'Kganane Road, Vosloorus, South Africa', destination:	'64 Rigger Rd, Spartan, Kempton Park, 1619', timeslot:	'5:00 AM'.to_time)
           ])
    @trips = [Booking.all]
  end

  it 'renders a list of bookings' do
    render
    assert_select 'tr>td', text: 'Devora Nader'.to_s, count: 2
    assert_select 'tr>td', text: 'Kganane Road, Vosloorus, South Africa'.to_s, count: 2
    assert_select 'tr>td', text: '64 Rigger Rd, Spartan, Kempton Park, 1619'.to_s, count: 2
    assert_select 'tr>td', text: '05:00 AM'.to_s, count: 2
  end
end
