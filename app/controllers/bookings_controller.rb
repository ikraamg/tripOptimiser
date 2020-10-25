class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  # GET /bookings
  # GET /bookings.json

  def index
    @booking = Booking.new
    @home_location = '64 Rigger Rd, Spartan, Kempton Park, 1619'
    @bookings = Booking.order(timeslot: :asc, location: :asc, destination: :asc)
    @bookings_inbound = @bookings.where("location = ?", @home_location)
    @bookings_outbound= @bookings.where("destination = ?", @home_location)

    @trips = []

    @grouped_outbound_bookings = @bookings_outbound.group_by  do |booking| 
      booking.timeslot
    end

    @grouped_inbound_bookings = @bookings_inbound.group_by  do |booking| 
      booking.timeslot
    end

    @grouped_inbound_bookings.each do |time, time_group| 
      remaining_bookings = time_group.clone
      ### Loop if more than one booking in timeslot
      while remaining_bookings.count > 1
        ### Check furthest location
        furthest = 0
        furthest_booking = nil
        remaining_bookings.each do |booking|
          distance = booking.loclonlat.distance(booking.deslonlat)
          if distance > furthest
            furthest = distance
            furthest_booking = booking
          end
        end

        ### Find closest location to furthest
        closest = 999999
        next_booking = nil
        remaining_bookings = remaining_bookings.select {|booking| booking != furthest_booking}
        remaining_bookings.each do |booking|
          distance = furthest_booking.deslonlat.distance(booking.deslonlat)
            if distance < closest
              closest = distance
              next_booking = booking
            end
        end
        ### Add single or double bookings to trips 
        if closest > 15000
          @trips << [furthest_booking]
          # puts 'Added single item:'
          # print furthest_booking.passenger
          # puts
        else
          @trips << [furthest_booking, next_booking]
          # puts 'Added double item:'
          # print furthest_booking.passenger
          # print ' and '
          # print next_booking.passenger
          remaining_bookings = remaining_bookings.select {|booking| booking != next_booking}
          # puts
        end
      end
      ### Add single booking if there is only one in timeslot
      # puts
      # puts
      if remaining_bookings.count == 1 
        @trips << remaining_bookings
        # puts 'Added single item:'
        # print remaining_bookings[0].passenger
        # puts
      end
    end

      @grouped_outbound_bookings.each do |time, time_group| 
      remaining_bookings = time_group.clone
      ### Loop if more than one booking in timeslot
      while remaining_bookings.count > 1
        ### Check furthest location
        furthest = 0
        furthest_booking = nil
        remaining_bookings.each do |booking|
          distance = booking.loclonlat.distance(booking.deslonlat)
          # puts
          # print 'passenger: '
          # print booking.passenger
          # puts
          # print 'distance: '
          # print distance
          if distance > furthest
            furthest = distance
            furthest_booking = booking
          end
        end
        # puts
        # puts
        # print 'furthest: '
        # puts furthest
        # print 'furthest passenger: '
        # puts furthest_booking.passenger

        ### Find closest location to furthest
        closest = 999999
        next_booking = nil
        remaining_bookings = remaining_bookings.select {|booking| booking != furthest_booking}
        remaining_bookings.each do |booking|
          distance = furthest_booking.loclonlat.distance(booking.loclonlat)
            # puts
            # print 'passenger: '
            # print booking.passenger
            # puts
            # print 'distance: '
            # print distance
            if distance < closest
              closest = distance
              next_booking = booking
            end
        end
        # puts
        # puts
        # print 'closest: '
        # puts closest
        # print 'closest passenger: '
        # puts next_booking.passenger
        ### Add single or double bookings to trips 
        puts
        puts
        if closest > 15000
          @trips << [furthest_booking]
          # puts 'Added single item:'
          # print furthest_booking.passenger
        else
          @trips << [furthest_booking, next_booking]
          # puts 'Added double item:'
          # print furthest_booking.passenger
          # print ' and '
          # print next_booking.passenger
          remaining_bookings = remaining_bookings.select {|booking| booking != next_booking}
        end
      end
      ### Add single booking if there is only one in timeslot
      if remaining_bookings.count == 1 
        @trips << remaining_bookings
        # puts 'Added single item:'
        # print remaining_bookings[0].passenger
      end
    end

    @testing = @trips
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end

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
    flash[:notice] = "Bookings uploaded successfully"
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
      params.require(:booking).permit(:passenger, :location, :destination, :timeslot,:file)
    end
end
