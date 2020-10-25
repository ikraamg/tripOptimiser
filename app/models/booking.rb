# frozen_string_literal: true

require 'csv'

class Booking < ApplicationRecord
  before_save :geocode_addresses
  # validates :loclonlat, :deslonlat, presence: true

  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)

  def geocode_addresses
    if location_changed? || !loclonlat
      try = 0
      while try < 3
        geocoded = Geocoder.search(location).first
        if geocoded
          try = 3
          self.loclonlat = GEO_FACTORY.point(geocoded.latitude, geocoded.longitude)
        end
      end
    end
    if destination_changed? || !deslonlat
      try = 0
      while try < 3
        geocoded = Geocoder.search(destination).first
        if geocoded
          try = 3
          self.deslonlat = GEO_FACTORY.point(geocoded.latitude, geocoded.longitude)
        end
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      booking_hash = Booking.new
      booking_hash.passenger = row[0]
      booking_hash.location = row[1]
      booking_hash.destination = row[2]
      booking_hash.timeslot = row[3].to_time
      booking_hash.save
    end
  end
end
