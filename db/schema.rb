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

ActiveRecord::Schema.define(version: 20150914171851) do

  create_table "customers", force: :cascade do |t|
    t.string   "name",          limit: 255, null: false
    t.string   "tax_id",        limit: 255
    t.string   "billing_serie", limit: 255
    t.integer  "billing_tax",   limit: 4
    t.string   "contact_name",  limit: 255
    t.string   "contact_phone", limit: 255
    t.string   "contact_email", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "delivery_note_details", force: :cascade do |t|
    t.integer  "delivery_note_id", limit: 4,                         null: false
    t.integer  "service_id",       limit: 4,                         null: false
    t.decimal  "quantity",                   precision: 7, scale: 2, null: false
    t.decimal  "price",                      precision: 7, scale: 2, null: false
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "delivery_note_details", ["delivery_note_id"], name: "index_delivery_note_details_on_delivery_note_id", using: :btree
  add_index "delivery_note_details", ["service_id"], name: "index_delivery_note_details_on_service_id", using: :btree

  create_table "delivery_notes", force: :cascade do |t|
    t.string   "number",      limit: 255, null: false
    t.integer  "customer_id", limit: 4,   null: false
    t.datetime "date",                    null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "delivery_notes", ["customer_id"], name: "index_delivery_notes_on_customer_id", using: :btree

  create_table "invoice_details", force: :cascade do |t|
    t.integer  "invoice_id",  limit: 4,                           null: false
    t.integer  "service_id",  limit: 4,                           null: false
    t.string   "description", limit: 255
    t.integer  "vat_rate",    limit: 4,                           null: false
    t.decimal  "price",                   precision: 7, scale: 2, null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "invoice_details", ["invoice_id"], name: "index_invoice_details_on_invoice_id", using: :btree
  add_index "invoice_details", ["service_id"], name: "index_invoice_details_on_service_id", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.string   "number",            limit: 255, null: false
    t.date     "date",                          null: false
    t.integer  "payment_method_id", limit: 4,   null: false
    t.integer  "customer_id",       limit: 4,   null: false
    t.datetime "issue_date",                    null: false
    t.date     "payment_date",                  null: false
    t.date     "paid_on"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "invoices", ["customer_id"], name: "index_invoices_on_customer_id", using: :btree
  add_index "invoices", ["number"], name: "index_invoices_on_number", using: :btree
  add_index "invoices", ["payment_method_id"], name: "index_invoices_on_payment_method_id", using: :btree

  create_table "payment_methods", force: :cascade do |t|
    t.string   "name",             limit: 255,                 null: false
    t.string   "note_for_invoice", limit: 255
    t.boolean  "default",                      default: false, null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  create_table "project_statuses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",              limit: 255, null: false
    t.integer  "project_status_id", limit: 4,   null: false
    t.integer  "customer_id",       limit: 4,   null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "projects", ["customer_id"], name: "index_projects_on_customer_id", using: :btree
  add_index "projects", ["project_status_id"], name: "index_projects_on_project_status_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "roles", ["description"], name: "index_roles_on_description", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "code",        limit: 255,                         null: false
    t.string   "description", limit: 255,                         null: false
    t.integer  "vat_id",      limit: 4,                           null: false
    t.integer  "unit_id",     limit: 4,                           null: false
    t.decimal  "price",                   precision: 7, scale: 2, null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "services", ["code"], name: "index_services_on_code", using: :btree
  add_index "services", ["unit_id"], name: "index_services_on_unit_id", using: :btree
  add_index "services", ["vat_id"], name: "index_services_on_vat_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "description", limit: 255,                 null: false
    t.integer  "project_id",  limit: 4,                   null: false
    t.boolean  "finished",                default: false, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree

  create_table "time_logs", force: :cascade do |t|
    t.string   "description", limit: 255, null: false
    t.datetime "start_time",              null: false
    t.datetime "end_time",                null: false
    t.integer  "project_id",  limit: 4,   null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "service_id",  limit: 4
  end

  add_index "time_logs", ["project_id"], name: "index_time_logs_on_project_id", using: :btree
  add_index "time_logs", ["service_id"], name: "index_time_logs_on_service_id", using: :btree

  create_table "units", force: :cascade do |t|
    t.string   "label_short", limit: 255, null: false
    t.string   "label_long",  limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "units", ["label_short"], name: "index_units_on_label_short", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "role_id",                limit: 4
    t.string   "tenant",                 limit: 255
    t.string   "tax_id",                 limit: 255
    t.string   "name",                   limit: 255
    t.string   "addess",                 limit: 255
    t.string   "city",                   limit: 255
    t.string   "country",                limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "index_users_on_role_id", using: :btree

  create_table "vats", force: :cascade do |t|
    t.string   "label",      limit: 255, null: false
    t.integer  "rate",       limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "vats", ["label"], name: "index_vats_on_label", using: :btree

  add_foreign_key "delivery_note_details", "delivery_notes"
  add_foreign_key "delivery_note_details", "services"
  add_foreign_key "delivery_notes", "customers"
  add_foreign_key "invoice_details", "invoices"
  add_foreign_key "invoice_details", "services"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "payment_methods"
  add_foreign_key "tasks", "projects"
  add_foreign_key "time_logs", "projects"
  add_foreign_key "time_logs", "services"
  add_foreign_key "users", "roles"
end
