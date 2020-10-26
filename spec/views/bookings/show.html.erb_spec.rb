# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'bookings/show', type: :view do
  before(:each) do
    @booking = assign(:booking, Booking.create(passenger: 'Devora Nader', location:	'Kganane Road, Vosloorus, South Africa', destination:	'64 Rigger Rd, Spartan, Kempton Park, 1619', timeslot:	'5:00 AM'.to_time))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Devora Nader/)
    expect(rendered).to match(/Kganane Road, Vosloorus, South Africa/)
    expect(rendered).to match(/64 Rigger Rd, Spartan, Kempton Park, 1619/)
    expect(rendered).to match(/05:00 AM/)
  end
end
