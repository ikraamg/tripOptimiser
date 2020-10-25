# frozen_string_literal: true

class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]

  # GET /bookings
  # GET /bookings.json

  def index
    @booking = Booking.new

    @bookings = Booking.order(timeslot: :asc, location: :asc, destination: :asc)

    @home_location = '64 Rigger Rd, Spartan, Kempton Park, 1619'
    @bookings_inbound = @bookings.where('location = ?', @home_location)
    @bookings_outbound = @bookings.where('destination = ?', @home_location)

    # @other_bookings = Booking.where.not('location = ? AND destination = ?', @home_location, @home_location)

    @grouped_outbound_bookings = @bookings_outbound.group_by(&:timeslot)
    @grouped_inbound_bookings = @bookings_inbound.group_by(&:timeslot)

    @trips = []
    ### Create inbound trips
    @grouped_inbound_bookings.each do |_time, time_group|
      remaining_bookings = time_group.clone
      ### Loop if more than one booking in timeslot
      while remaining_bookings.count > 1
        ### Check furthest location
        furthest_booking = get_furthest_booking(remaining_bookings)
        remaining_bookings = remaining_bookings.reject { |booking| booking == furthest_booking }
        ### Find closest location to furthest
        closest = 999_999
        next_booking = nil
        remaining_bookings.each do |booking|
          distance = furthest_booking.deslonlat.distance(booking.deslonlat)
          if distance < closest
            closest = distance
            next_booking = booking
          end
        end
        ### Add single or double bookings to trips
        if closest > 15_000
          @trips << [furthest_booking]
        else
          @trips << [furthest_booking, next_booking]
          remaining_bookings = remaining_bookings.reject { |booking| booking == next_booking }
        end
      end
      ### Add remaining booking to trip
      @trips << remaining_bookings if remaining_bookings.count == 1
    end

    ### Create outbound trips
    @grouped_outbound_bookings.each do |_time, time_group|
      remaining_bookings = time_group.clone
      ### Loop if more than one booking in timeslot
      while remaining_bookings.count > 1
        ### Check furthest location
        furthest_booking = get_furthest_booking(remaining_bookings)
        remaining_bookings = remaining_bookings.reject { |booking| booking == furthest_booking }
        ### Find closest location to furthest
        closest = 999_999
        next_booking = nil
        remaining_bookings.each do |booking|
          distance = furthest_booking.loclonlat.distance(booking.loclonlat)
          if distance < closest
            closest = distance
            next_booking = booking
          end
        end
        ### Add single or double bookings to trips
        if closest > 15_000
          @trips << [furthest_booking]
        else
          @trips << [furthest_booking, next_booking]
          remaining_bookings = remaining_bookings.reject { |booking| booking == next_booking }
        end
      end
      ### Add remaining booking to trip
      @trips << remaining_bookings if remaining_bookings.count == 1
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

  def get_furthest_booking(remaining_bookings)
    furthest = 0
    furthest_booking = nil
    remaining_bookings.each do |booking|
      distance = booking.loclonlat.distance(booking.deslonlat)
      if distance > furthest
        furthest = distance
        furthest_booking = booking
      end
    end
    furthest_booking
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def booking_params
    params.require(:booking).permit(:passenger, :location, :destination, :timeslot, :file)
  end
end
