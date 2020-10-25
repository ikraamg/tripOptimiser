# frozen_string_literal: true

json.extract! booking, :id, :passenger, :location, :destination, :timeslot, :created_at, :updated_at
json.url booking_url(booking, format: :json)
