# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/bookings', type: :request do
  describe 'requests' do
    # Booking. As you add validations to Booking, be sure to
    # adjust the attributes here as well.
    let(:valid_attributes) do
      { passenger: 'Devora Nader', location:	'Kganane Road, Vosloorus, South Africa', destination:	'64 Rigger Rd, Spartan, Kempton Park, 1619', timeslot:	'5:00 AM'.to_time }
    end

    let(:invalid_attributes) do
      { passenger: '', location:	'Kganane Road, Vosloorus, South Africa', destination:	'64 Rigger Rd, Spartan, Kempton Park, 1619', timeslot:	'5:00 AM' }
    end

    describe 'GET /index' do
      it 'renders a successful response' do
        Booking.create! valid_attributes
        get bookings_url
        expect(response).to be_successful
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        booking = Booking.create! valid_attributes
        get booking_url(booking)
        expect(response).to be_successful
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_booking_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a successful response' do
        booking = Booking.create! valid_attributes
        get edit_booking_url(booking)
        expect(response).to be_successful
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Booking' do
          expect do
            post bookings_url, params: { booking: valid_attributes }
          end.to change(Booking, :count).by(1)
        end

        it 'redirects to the created booking' do
          post bookings_url, params: { booking: valid_attributes }
          expect(response).to redirect_to(booking_url(Booking.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Booking' do
          expect do
            post bookings_url, params: { booking: invalid_attributes }
          end.to change(Booking, :count).by(0)
        end

        it "renders a successful response (i.e. to display the 'new' template)" do
          post bookings_url, params: { booking: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          { passenger: 'Happy', location:	'South Africa', destination:	'64 Rigger Rd, Spartan, Kempton Park, 1619', timeslot:	'8:00 AM'.to_time }
        end

        it 'updates the requested booking' do
          booking = Booking.create! valid_attributes
          patch booking_url(booking), params: { booking: new_attributes }
          booking.reload
          expect(booking.passenger).to eq('Happy')
          expect(booking.passenger).not_to eq('Devora Nader')
        end

        it 'redirects to the booking' do
          booking = Booking.create! valid_attributes
          patch booking_url(booking), params: { booking: new_attributes }
          booking.reload
          expect(response).to redirect_to(booking_url(booking))
        end
      end

      context 'with invalid parameters' do
        it "renders a successful response (i.e. to display the 'edit' template)" do
          booking = Booking.create! valid_attributes
          patch booking_url(booking), params: { booking: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested booking' do
        booking = Booking.create! valid_attributes
        expect do
          delete booking_url(booking)
        end.to change(Booking, :count).by(-1)
      end

      it 'redirects to the bookings list' do
        booking = Booking.create! valid_attributes
        delete booking_url(booking)
        expect(response).to redirect_to(bookings_url)
      end
    end
  end
end
