# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]

  # GET /bookings
  # GET /bookings.json

  def index
    @booking = Booking.new
    @bookings = Booking.all

    @home_location = '64 Rigger Rd, Spartan, Kempton Park, 1619'
    bookings_inbound = @bookings.where('location = ?', @home_location).group_by(&:timeslot)
    bookings_outbound = @bookings.where('destination = ?', @home_location).group_by(&:timeslot)
    # other_bookings = @bookings.where.not('location = ? AND destination = ?', @home_location, @home_location)
    @trips = get_trips(bookings_inbound, true)
    @trips.concat(get_trips(bookings_outbound, false))
    @trips = @trips.sort_by { |trip| trip[0].timeslot }

    respond_to do |format|
      format.json { render json: @trips, status: :ok }
      format.html
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show; end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit; end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(booking_params)

    respond_to do |format|
      if @booking.save
        format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  def csv_create
    Booking.import(params[:booking][:file])
    flash[:notice] = 'Bookings uploaded successfully'
    redirect_to bookings_path
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def booking_params
    params.require(:booking).permit(:passenger, :location, :destination, :timeslot, :file)
  end

  def get_furthest_booking(bookings)
    furthest = 0
    furthest_booking = nil
    bookings.each do |booking|
      distance = booking.loclonlat.distance(booking.deslonlat)
      if distance > furthest
        furthest = distance
        furthest_booking = booking
      end
    end
    furthest_booking
  end

  def get_trips(booking_groups, inbound)
    trips = []
    booking_groups.each do |_time, remaining_bookings|
      ### Loop if more than one booking in timeslot
      while remaining_bookings.count > 1
        ### Check furthest location and extract it
        furthest_booking = get_furthest_booking(remaining_bookings)
        remaining_bookings = remaining_bookings.reject { |booking| booking == furthest_booking }
        ### Find closest location to furthest
        closest = 999_999_999
        next_booking = nil
        remaining_bookings.each do |booking|
          ### Change distance calculation upon direction
          distance = if inbound
                       furthest_booking.deslonlat.distance(booking.deslonlat)
                     else
                       furthest_booking.loclonlat.distance(booking.loclonlat)
                     end

          if distance < closest
            closest = distance
            next_booking = booking
          end
        end
        ### Add single or double bookings to trips
        if closest > 15_000
          trips << [furthest_booking]
        else
          trips << [furthest_booking, next_booking]
          remaining_bookings = remaining_bookings.reject { |booking| booking == next_booking }
        end
      end
      ### Add remaining booking to trip
      trips << remaining_bookings if remaining_bookings.count == 1
    end
    trips
  end
end
