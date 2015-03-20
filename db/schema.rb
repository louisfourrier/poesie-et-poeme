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

ActiveRecord::Schema.define(version: 20141110202335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auteurs", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.text     "description_source"
    t.date     "birth_date"
    t.date     "death_date"
    t.integer  "poemes_count",       default: 0, null: false
    t.integer  "century"
    t.string   "first_letter"
    t.string   "slug"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "research_name"
    t.text     "html_content"
    t.text     "crawl_url"
    t.text     "image_url"
    t.string   "date_string"
    t.float    "century_float"
  end

  add_index "auteurs", ["research_name"], name: "index_auteurs_on_research_name", using: :btree
  add_index "auteurs", ["slug"], name: "index_auteurs_on_slug", using: :btree

  create_table "poemes", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "recueil"
    t.string   "slug"
    t.date     "written_date"
    t.integer  "auteur_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "research_name"
    t.string   "first_letter"
    t.text     "html_content"
    t.text     "crawl_url"
  end

  add_index "poemes", ["auteur_id"], name: "index_poemes_on_auteur_id", using: :btree
  add_index "poemes", ["research_name"], name: "index_poemes_on_research_name", using: :btree
  add_index "poemes", ["slug"], name: "index_poemes_on_slug", using: :btree

end
