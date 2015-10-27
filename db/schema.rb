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

ActiveRecord::Schema.define(version: 20150510102044) do

  create_table "admins", force: :cascade do |t|
    t.integer  "mem_id",     limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "alerts", force: :cascade do |t|
    t.integer  "mem_id",     limit: 4
    t.string   "title",      limit: 255
    t.string   "content",    limit: 1000
    t.string   "link",       limit: 255
    t.string   "status",     limit: 255,  default: "UNREAD"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", force: :cascade do |t|
    t.string   "recsts",     limit: 1,     default: "0"
    t.integer  "ask_id",     limit: 4
    t.integer  "mem_id",     limit: 4
    t.integer  "votes",      limit: 4,     default: 0
    t.text     "con",        limit: 65535
    t.string   "typcd",      limit: 255,   default: "ANSWER"
    t.integer  "parent",     limit: 4,     default: 0
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  create_table "asks", force: :cascade do |t|
    t.string   "recsts",     limit: 1,     default: "1"
    t.string   "title",      limit: 255
    t.string   "keywords",   limit: 255
    t.text     "con",        limit: 65535
    t.integer  "mem_id",     limit: 4
    t.integer  "money",      limit: 4,     default: 0
    t.integer  "adopt_cd",   limit: 4
    t.string   "status",     limit: 255,   default: "UNSOLVE"
    t.integer  "visit",      limit: 4,     default: 0
    t.integer  "collect",    limit: 4,     default: 0
    t.integer  "answer",     limit: 4,     default: 0
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "buylogs", force: :cascade do |t|
    t.string   "typ",        limit: 255
    t.integer  "idcd",       limit: 4
    t.integer  "mem_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", force: :cascade do |t|
    t.string   "recsts",     limit: 1,   default: "0"
    t.string   "key",        limit: 255
    t.string   "pwd",        limit: 255
    t.integer  "cost",       limit: 4
    t.integer  "val",        limit: 4
    t.integer  "mem_id",     limit: 4
    t.string   "used",       limit: 1,   default: "0"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "checkins", force: :cascade do |t|
    t.integer  "mem_id",     limit: 4
    t.date     "begdt"
    t.date     "enddt"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "codes", force: :cascade do |t|
    t.string   "recsts",     limit: 1,     default: "1"
    t.string   "title",      limit: 255
    t.string   "desc",       limit: 255
    t.string   "keywords",   limit: 255
    t.text     "snippet",    limit: 65535
    t.text     "shtml",      limit: 65535
    t.text     "scss",       limit: 65535
    t.text     "sjs",        limit: 65535
    t.text     "con",        limit: 65535
    t.integer  "mem_id",     limit: 4
    t.integer  "visit",      limit: 4,     default: 0
    t.integer  "collect",    limit: 4,     default: 0
    t.integer  "comment",    limit: 4,     default: 0
    t.string   "ischeck",    limit: 1,     default: "1"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.string   "recsts",     limit: 1,     default: "0"
    t.string   "typ",        limit: 255
    t.integer  "idcd",       limit: 4
    t.integer  "mem_id",     limit: 4
    t.text     "con",        limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "docs", force: :cascade do |t|
    t.string   "recsts",     limit: 1,     default: "0"
    t.string   "typ",        limit: 255
    t.string   "key",        limit: 255
    t.integer  "val1",       limit: 4
    t.string   "val2",       limit: 255
    t.string   "sdesc",      limit: 255
    t.text     "fdesc",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorites", force: :cascade do |t|
    t.string   "recsts",     limit: 1,   default: "0"
    t.string   "typ",        limit: 255
    t.integer  "idcd",       limit: 4
    t.integer  "mem_id",     limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "from_id",    limit: 4
    t.integer  "to_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fund_records", force: :cascade do |t|
    t.string   "recsts",     limit: 1,   default: "0"
    t.integer  "mem_id",     limit: 4
    t.integer  "num",        limit: 4
    t.integer  "balance",    limit: 4
    t.string   "remark",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "cd",         limit: 4
    t.string   "code",       limit: 255
    t.integer  "parent",     limit: 4
    t.string   "nm",         limit: 255
    t.string   "nmen",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "mauths", force: :cascade do |t|
    t.string   "recsts",     limit: 1,   default: "0"
    t.integer  "mem_id",     limit: 4
    t.string   "provider",   limit: 255
    t.string   "uid",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mem_infos", force: :cascade do |t|
    t.integer  "mem_id",     limit: 4
    t.string   "gender",     limit: 255
    t.string   "dob",        limit: 255
    t.string   "city",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "mems", force: :cascade do |t|
    t.string   "recsts",      limit: 1,   default: "0"
    t.string   "nc",          limit: 255
    t.string   "photo",       limit: 255
    t.integer  "integral",    limit: 4,   default: 0
    t.string   "gender",      limit: 1,   default: "M"
    t.string   "email",       limit: 255
    t.string   "email_valid", limit: 255, default: "NO"
    t.string   "pwd",         limit: 255
    t.integer  "plugin",      limit: 4,   default: 0
    t.integer  "code",        limit: 4,   default: 0
    t.integer  "video",       limit: 4,   default: 0
    t.integer  "favorp",      limit: 4,   default: 0
    t.integer  "favorc",      limit: 4,   default: 0
    t.integer  "favorv",      limit: 4,   default: 0
    t.integer  "favorask",    limit: 4,   default: 0
    t.integer  "followers",   limit: 4,   default: 0
    t.integer  "following",   limit: 4,   default: 0
    t.integer  "ask",         limit: 4,   default: 0
    t.integer  "answer",      limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "msgs", force: :cascade do |t|
    t.string   "recsts",     limit: 1,    default: "0"
    t.string   "content",    limit: 1000
    t.string   "extra",      limit: 1000
    t.integer  "from_id",    limit: 4
    t.string   "from_typcd", limit: 20
    t.integer  "to_id",      limit: 4
    t.string   "to_typcd",   limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: :cascade do |t|
    t.string   "recsts",     limit: 1,   default: "0"
    t.string   "no",         limit: 255
    t.integer  "mem_id",     limit: 4
    t.string   "price",      limit: 255
    t.string   "remark",     limit: 255
    t.string   "state",      limit: 255
    t.string   "issend",     limit: 1,   default: "0"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plugincons", force: :cascade do |t|
    t.string   "recsts",     limit: 1,     default: "1"
    t.integer  "mem_id",     limit: 4
    t.text     "con",        limit: 65535
    t.integer  "plugin_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plugins", force: :cascade do |t|
    t.string   "recsts",     limit: 1,     default: "1"
    t.string   "title",      limit: 255
    t.string   "desc",       limit: 255
    t.string   "keywords",   limit: 255
    t.string   "typ",        limit: 255
    t.string   "root_typ",   limit: 255
    t.string   "pic",        limit: 255
    t.string   "demo",       limit: 255
    t.string   "download",   limit: 255
    t.integer  "downnum",    limit: 4,     default: 0
    t.string   "website",    limit: 255
    t.string   "browser",    limit: 255
    t.string   "videos",     limit: 255
    t.text     "con",        limit: 65535
    t.integer  "mem_id",     limit: 4
    t.integer  "cost",       limit: 4,     default: 0
    t.integer  "visit",      limit: 4,     default: 0
    t.integer  "collect",    limit: 4,     default: 0
    t.integer  "comment",    limit: 4,     default: 0
    t.string   "ischeck",    limit: 1,     default: "1"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plugins", ["recsts"], name: "index_plugins_on_recsts", using: :btree
  add_index "plugins", ["root_typ"], name: "index_plugins_on_root_typ", using: :btree
  add_index "plugins", ["typ"], name: "index_plugins_on_typ", using: :btree

  create_table "pwdkeys", force: :cascade do |t|
    t.integer  "mem_id",     limit: 4
    t.string   "key",        limit: 255
    t.string   "email",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "refcds", force: :cascade do |t|
    t.string   "cd",         limit: 255
    t.string   "key",        limit: 255
    t.string   "sdesc",      limit: 255
    t.string   "var1",       limit: 255
    t.string   "var2",       limit: 255
    t.integer  "var3",       limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string   "nm",         limit: 255
    t.integer  "num",        limit: 4
    t.string   "typcd",      limit: 255, default: "PLUGIN"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "thiefs", force: :cascade do |t|
    t.string   "recsts",     limit: 1,   default: "0"
    t.string   "server",     limit: 255
    t.string   "referer",    limit: 255
    t.integer  "num",        limit: 4,   default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", force: :cascade do |t|
    t.string   "recsts",     limit: 1,     default: "1"
    t.string   "title",      limit: 255
    t.string   "desc",       limit: 255
    t.string   "keywords",   limit: 255
    t.string   "typ",        limit: 255
    t.text     "con",        limit: 65535
    t.string   "src",        limit: 255
    t.string   "cover",      limit: 255
    t.string   "duration",   limit: 255
    t.integer  "mem_id",     limit: 4
    t.string   "preview",    limit: 255
    t.integer  "cost",       limit: 4,     default: 0
    t.integer  "visit",      limit: 4,     default: 0
    t.integer  "playnum",    limit: 4,     default: 0
    t.integer  "collect",    limit: 4,     default: 0
    t.integer  "comment",    limit: 4,     default: 0
    t.string   "ischeck",    limit: 1,     default: "1"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vote_logs", force: :cascade do |t|
    t.string   "recsts",     limit: 1,   default: "0"
    t.integer  "answer_id",  limit: 4
    t.integer  "mem_id",     limit: 4
    t.string   "act",        limit: 255
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  create_table "withdraws", force: :cascade do |t|
    t.string   "recsts",     limit: 1,   default: "1"
    t.integer  "mem_id",     limit: 4
    t.integer  "num",        limit: 4
    t.string   "remark",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
