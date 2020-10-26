# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'bookings/new', type: :view do
  before(:each) do
    assign(:booking, Booking.new(
                       passenger: 'MyString',
                       location: 'MyString',
                       destination: 'MyString',
                       timeslot: 'MyString'
                     ))
  end

  it 'renders new booking form' do
    render

    assert_select 'form[action=?][method=?]', bookings_path, 'post' do
      assert_select 'input[name=?]', 'booking[passenger]'

      assert_select 'input[name=?]', 'booking[location]'

      assert_select 'input[name=?]', 'booking[destination]'

      assert_select 'input[name=?]', 'booking[timeslot(1i)]'
    end
  end
end
