require 'rails_helper'

RSpec.describe "bookings/index", type: :view do
  before(:each) do
    assign(:bookings, [
      Booking.create!(
        passenger: "Passenger",
        location: "Location",
        destination: "Destination",
        timeslot: "Timeslot"
      ),
      Booking.create!(
        passenger: "Passenger",
        location: "Location",
        destination: "Destination",
        timeslot: "Timeslot"
      )
    ])
  end

  it "renders a list of bookings" do
    render
    assert_select "tr>td", text: "Passenger".to_s, count: 2
    assert_select "tr>td", text: "Location".to_s, count: 2
    assert_select "tr>td", text: "Destination".to_s, count: 2
    assert_select "tr>td", text: "Timeslot".to_s, count: 2
  end
end
