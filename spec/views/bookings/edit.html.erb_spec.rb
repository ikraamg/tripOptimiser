# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'bookings/edit', type: :view do
  before(:each) do
    @booking = assign(:booking, Booking.create!(passenger: 'Devora Nader', location:	'Kganane Road, Vosloorus, South Africa', destination:	'64 Rigger Rd, Spartan, Kempton Park, 1619', timeslot:	'5:00 AM'.to_time))
  end

  it 'renders the edit booking form' do
    render

    assert_select 'form[action=?][method=?]', booking_path(@booking), 'post' do
      assert_select 'input[name=?]', 'booking[passenger]'

      assert_select 'input[name=?]', 'booking[location]'

      assert_select 'input[name=?]', 'booking[destination]'

      assert_select 'input[name=?]', 'booking[timeslot(1i)]'
    end
  end
end
