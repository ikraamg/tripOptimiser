# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_24_103549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "bookings", force: :cascade do |t|
    t.string "passenger"
    t.string "location"
    t.string "destination"
    t.string "timeslot"
    t.geography "loclonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.geography "deslonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deslonlat"], name: "index_bookings_on_deslonlat", using: :gist
    t.index ["loclonlat"], name: "index_bookings_on_loclonlat", using: :gist
    t.index ["timeslot"], name: "index_bookings_on_timeslot"
  end

end
