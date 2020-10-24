class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.string :passenger
      t.string :location
      t.string :destination
      t.string :timeslot

      t.timestamps
    end
  end
end
