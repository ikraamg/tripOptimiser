# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/bookings').to route_to('bookings#index')
    end

    it 'routes to #new' do
      expect(get: '/bookings/new').to route_to('bookings#new')
    end

    it 'routes to #show' do
      expect(get: '/bookings/1').to route_to('bookings#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/bookings/1/edit').to route_to('bookings#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/bookings').to route_to('bookings#create')
    end

    it 'routes to #csv_create' do
      expect(post: 'bookings/upload').to route_to('bookings#csv_create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/bookings/1').to route_to('bookings#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/bookings/1').to route_to('bookings#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/bookings/1').to route_to('bookings#destroy', id: '1')
    end
  end
end
