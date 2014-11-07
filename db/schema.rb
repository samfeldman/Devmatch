# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141105214441) do

  create_table "follows", force: true do |t|
    t.integer "follower_id"
    t.integer "followee_id"
  end

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.datetime "posttime"
    t.string   "text"
  end

  create_table "users", force: true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "email"
    t.string   "password"
    t.string   "location"
    t.string   "company"
    t.string   "sex"
    t.datetime "birthday"
    t.string   "aboutme"
  end

end