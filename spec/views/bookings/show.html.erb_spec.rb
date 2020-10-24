require 'rails_helper'

RSpec.describe "bookings/show", type: :view do
  before(:each) do
    @booking = assign(:booking, Booking.create!(
      passenger: "Passenger",
      location: "Location",
      destination: "Destination",
      timeslot: "Timeslot"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Passenger/)
    expect(rendered).to match(/Location/)
    expect(rendered).to match(/Destination/)
    expect(rendered).to match(/Timeslot/)
  end
end
