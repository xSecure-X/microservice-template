# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_03_062944) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "user_roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "userId"
    t.uuid "roleId"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["userId", "roleId"], name: "index_user_roles_on_userId_and_roleId"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "roles"
    t.integer "status"
    t.string "provider"
    t.uuid "company_id"
    t.string "uid"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "modified_at", null: false
    t.string "telefono"
    t.datetime "deleted_at"
    t.integer "codigoAnfitrion"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
  end

end
