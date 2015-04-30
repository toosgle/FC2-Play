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

ActiveRecord::Schema.define(version: 20150430084434) do

  create_table "bug_reports", force: :cascade do |t|
    t.string   "content",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "erotos", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.string   "url",        limit: 255
    t.string   "thumbnail",  limit: 255
    t.string   "content",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "favs", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "comment",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "video_id",   limit: 4
  end

  add_index "favs", ["user_id"], name: "index_favs_on_user_id", using: :btree
  add_index "favs", ["video_id"], name: "index_favs_on_video_id", using: :btree

  create_table "histories", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "keyword",    limit: 65535
    t.integer  "video_id",   limit: 4
  end

  add_index "histories", ["user_id"], name: "index_histories_on_user_id", using: :btree
  add_index "histories", ["video_id"], name: "index_histories_on_video_id", using: :btree

  create_table "monthly_ranks", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "video_id",   limit: 4
  end

  add_index "monthly_ranks", ["video_id"], name: "index_monthly_ranks_on_video_id", using: :btree

  create_table "new_arrivals", force: :cascade do |t|
    t.integer  "video_id",   limit: 4
    t.string   "title",      limit: 255
    t.string   "image_url",  limit: 255
    t.string   "duration",   limit: 255
    t.integer  "recommend",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "new_arrivals", ["video_id"], name: "index_new_arrivals_on_video_id", using: :btree

  create_table "records", force: :cascade do |t|
    t.string   "kind",       limit: 255
    t.date     "day"
    t.integer  "value",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_his", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "favs",       limit: 255
    t.string   "duration",   limit: 255
    t.integer  "user_id",    limit: 4
    t.text     "keyword",    limit: 65535
  end

  create_table "surveys", force: :cascade do |t|
    t.integer  "result",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "size",            limit: 4
  end

  create_table "videos", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "url",            limit: 255
    t.integer  "views",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "duration",       limit: 255
    t.boolean  "adult",          limit: 1
    t.string   "image_url",      limit: 255
    t.boolean  "morethan100min", limit: 1
    t.integer  "bookmarks",      limit: 4
    t.datetime "deleted_at"
  end

  add_index "videos", ["bookmarks"], name: "index_videos_on_bookmarks", using: :btree
  add_index "videos", ["deleted_at"], name: "index_videos_on_deleted_at", using: :btree
  add_index "videos", ["title"], name: "index_videos_on_title", using: :btree

  create_table "weekly_ranks", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "video_id",   limit: 4
  end

  add_index "weekly_ranks", ["video_id"], name: "index_weekly_ranks_on_video_id", using: :btree

end
