# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    @booking = Booking.new
    @bookings = Booking.all

    @home_location = '64 Rigger Rd, Spartan, Kempton Park, 1619'
    bookings_inbound = @bookings.location(@home_location).group_by(&:timeslot)
    bookings_outbound = @bookings.destination(@home_location).group_by(&:timeslot)
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
  def show; end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit; end

  # POST /bookings
  def create
    @booking = Booking.new(booking_params)
    if @booking.save
      redirect_to @booking, notice: 'Booking was successfully created.'
    else
      render :new
    end
  end

  def csv_create
    Booking.import(params[:booking][:file])
    flash[:notice] = 'Bookings uploaded successfully'
    redirect_to bookings_path
  end

  # PATCH/PUT /bookings/1
  def update
    if @booking.update(booking_params)
      redirect_to @booking, notice: 'Booking was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking.destroy
    redirect_to bookings_url, notice: 'Booking was successfully destroyed.'
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

  def get_trips(booking_groups, inbound)
    trips = []
    booking_groups.each do |_time, bookings|
      ### Loop if more than one booking in timeslot
      while bookings.count > 1

        ### Check furthest location and remove from list
        furthest = bookings.max_by do |booking|
          next unless booking.deslonlat && booking.loclonlat

          booking.loclonlat.distance(booking.deslonlat)
        end
        bookings = bookings.reject { |booking| booking == furthest }

        ### Find closest location to furthest
        closest = bookings.min_by do |a|
          next unless a.deslonlat && a.loclonlat

          inbound ? furthest.deslonlat.distance(a.deslonlat) : furthest.loclonlat.distance(a.loclonlat)
        end

        ### Calculate the distance between furthest and next
        distance = inbound ? furthest.deslonlat.distance(closest.deslonlat) : furthest.loclonlat.distance(closest.loclonlat)

        ### Add single or double bookings to trips and remove from list
        if distance > 15_000
          trips << [furthest]
        else
          trips << [furthest, closest]
          bookings = bookings.reject { |booking| booking == closest }
        end
      end
      ### Add remaining booking to trip
      trips << bookings if bookings.count == 1
    end
    trips
  end
end
