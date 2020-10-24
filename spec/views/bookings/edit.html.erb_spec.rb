require 'rails_helper'

RSpec.describe "bookings/edit", type: :view do
  before(:each) do
    @booking = assign(:booking, Booking.create!(
      passenger: "MyString",
      location: "MyString",
      destination: "MyString",
      timeslot: "MyString"
    ))
  end

  it "renders the edit booking form" do
    render

    assert_select "form[action=?][method=?]", booking_path(@booking), "post" do

      assert_select "input[name=?]", "booking[passenger]"

      assert_select "input[name=?]", "booking[location]"

      assert_select "input[name=?]", "booking[destination]"

      assert_select "input[name=?]", "booking[timeslot]"
    end
  end
end
