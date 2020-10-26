# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Booking, type: :model do
  it { should validate_presence_of(:passenger) }
  it { should validate_presence_of(:location) }
  it { should validate_presence_of(:destination) }
  it { should validate_presence_of(:timeslot) }

  it 'geocodes addresses correctly into an ST point type from RGeo' do
    test_booking = Booking.create(passenger: 'Devora Nader', location:	'Kganane Road, Vosloorus, South Africa', destination:	'64 Rigger Rd, Spartan, Kempton Park, 1619', timeslot:	'5:00 AM'.to_time)

    expect(test_booking.loclonlat.geometry_type).to eql RGeo::Feature::Point
  end
end
