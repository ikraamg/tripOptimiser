class Booking < ApplicationRecord
  before_save :geocode_addresses

  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)

  def geocode_addresses
    if location_changed?
      geocoded = Geocoder.search(location).first
      if geocoded
        self.loclonlat = GEO_FACTORY.point(geocoded.latitude, geocoded.longitude)
      end
    end
    if destination_changed?
      geocoded = Geocoder.search(destination).first
      if geocoded
        self.deslonlat = GEO_FACTORY.point(geocoded.latitude, geocoded.longitude)
      end
    end
  end
end
