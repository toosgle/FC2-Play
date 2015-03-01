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

ActiveRecord::Schema.define(version: 20150301022348) do

  create_table "bug_reports", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favs", force: true do |t|
    t.integer  "user_id"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "video_id"
  end

  add_index "favs", ["user_id"], name: "index_favs_on_user_id", using: :btree
  add_index "favs", ["video_id"], name: "index_favs_on_video_id", using: :btree

  create_table "histories", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "keyword"
    t.integer  "video_id"
  end

  add_index "histories", ["user_id"], name: "index_histories_on_user_id", using: :btree
  add_index "histories", ["video_id"], name: "index_histories_on_video_id", using: :btree

  create_table "monthly_ranks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "video_id"
  end

  add_index "monthly_ranks", ["video_id"], name: "index_monthly_ranks_on_video_id", using: :btree

  create_table "records", force: true do |t|
    t.string   "kind"
    t.date     "day"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_his", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "favs"
    t.string   "duration"
    t.integer  "user_id"
    t.text     "keyword"
  end

  create_table "surveys", force: true do |t|
    t.integer  "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "size"
  end

  create_table "videos", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "views"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "duration"
    t.boolean  "adult"
    t.string   "image_url"
    t.boolean  "morethan100min"
    t.integer  "bookmarks"
    t.datetime "deleted_at"
  end

  add_index "videos", ["bookmarks"], name: "index_videos_on_bookmarks", using: :btree
  add_index "videos", ["deleted_at"], name: "index_videos_on_deleted_at", using: :btree
  add_index "videos", ["title"], name: "index_videos_on_title", using: :btree

  create_table "weekly_ranks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "video_id"
  end

  add_index "weekly_ranks", ["video_id"], name: "index_weekly_ranks_on_video_id", using: :btree

end
