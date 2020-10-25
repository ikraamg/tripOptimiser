# frozen_string_literal: true

class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.string :passenger
      t.string :location
      t.string :destination
      t.string :timeslot

      t.st_point :loclonlat, geographic: true
      t.st_point :deslonlat, geographic: true

      t.index :loclonlat, using: :gist
      t.index :deslonlat, using: :gist
      t.index :timeslot
      t.timestamps
    end
  end
end
