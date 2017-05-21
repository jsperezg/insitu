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

ActiveRecord::Schema.define(version: 20170521065518) do

  create_table "ar_internal_metadata", primary_key: "key", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "name",             limit: 255, null: false
    t.string   "tax_id",           limit: 255
    t.string   "billing_serie",    limit: 255
    t.integer  "irpf",             limit: 4
    t.string   "contact_name",     limit: 255
    t.string   "contact_phone",    limit: 255
    t.string   "contact_email",    limit: 255
    t.string   "address",          limit: 255
    t.string   "city",             limit: 255
    t.string   "postal_code",      limit: 255
    t.string   "state",            limit: 255
    t.string   "country",          limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "send_invoices_to", limit: 255
  end

  create_table "delivery_note_details", force: :cascade do |t|
    t.integer  "delivery_note_id",  limit: 4,                           null: false
    t.integer  "service_id",        limit: 4
    t.decimal  "quantity",                      precision: 7, scale: 2, null: false
    t.decimal  "price",                         precision: 7, scale: 2, null: false
    t.string   "description",       limit: 255
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "invoice_detail_id", limit: 4
  end

  add_index "delivery_note_details", ["delivery_note_id"], name: "index_delivery_note_details_on_delivery_note_id", using: :btree
  add_index "delivery_note_details", ["invoice_detail_id"], name: "index_delivery_note_details_on_invoice_detail_id", using: :btree
  add_index "delivery_note_details", ["service_id"], name: "index_delivery_note_details_on_service_id", using: :btree

  create_table "delivery_notes", force: :cascade do |t|
    t.string   "number",      limit: 255, null: false
    t.integer  "customer_id", limit: 4,   null: false
    t.date     "date",                    null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "delivery_notes", ["customer_id"], name: "index_delivery_notes_on_customer_id", using: :btree
  add_index "delivery_notes", ["number"], name: "index_delivery_notes_on_number", using: :btree

  create_table "estimate_details", force: :cascade do |t|
    t.integer  "estimate_id",       limit: 4,                                       null: false
    t.integer  "service_id",        limit: 4
    t.string   "description",       limit: 255
    t.decimal  "quantity",                      precision: 7, scale: 2,             null: false
    t.decimal  "price",                         precision: 7, scale: 2,             null: false
    t.integer  "discount",          limit: 4,                           default: 0, null: false
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.integer  "invoice_detail_id", limit: 4
  end

  add_index "estimate_details", ["estimate_id"], name: "index_estimate_details_on_estimate_id", using: :btree
  add_index "estimate_details", ["invoice_detail_id"], name: "index_estimate_details_on_invoice_detail_id", using: :btree
  add_index "estimate_details", ["service_id"], name: "index_estimate_details_on_service_id", using: :btree

  create_table "estimate_statuses", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "estimates", force: :cascade do |t|
    t.string   "number",             limit: 255, null: false
    t.integer  "customer_id",        limit: 4,   null: false
    t.integer  "estimate_status_id", limit: 4,   null: false
    t.date     "date",                           null: false
    t.date     "valid_until"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "estimates", ["customer_id"], name: "index_estimates_on_customer_id", using: :btree
  add_index "estimates", ["estimate_status_id"], name: "index_estimates_on_estimate_status_id", using: :btree
  add_index "estimates", ["number"], name: "index_estimates_on_number", using: :btree

  create_table "invoice_details", force: :cascade do |t|
    t.integer  "invoice_id",  limit: 4,                                       null: false
    t.integer  "service_id",  limit: 4
    t.string   "description", limit: 255
    t.integer  "vat_rate",    limit: 4,                                       null: false
    t.decimal  "price",                   precision: 7, scale: 2,             null: false
    t.decimal  "quantity",                precision: 7, scale: 2,             null: false
    t.integer  "discount",    limit: 4,                           default: 0, null: false
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "invoice_details", ["invoice_id"], name: "index_invoice_details_on_invoice_id", using: :btree
  add_index "invoice_details", ["service_id"], name: "index_invoice_details_on_service_id", using: :btree

  create_table "invoice_statuses", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "number",            limit: 255, null: false
    t.date     "date",                          null: false
    t.integer  "payment_method_id", limit: 4,   null: false
    t.integer  "customer_id",       limit: 4,   null: false
    t.integer  "invoice_status_id", limit: 4,   null: false
    t.date     "payment_date",                  null: false
    t.date     "paid_on"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "irpf",              limit: 4
  end

  add_index "invoices", ["customer_id"], name: "index_invoices_on_customer_id", using: :btree
  add_index "invoices", ["invoice_status_id"], name: "index_invoices_on_invoice_status_id", using: :btree
  add_index "invoices", ["number"], name: "index_invoices_on_number", using: :btree
  add_index "invoices", ["payment_method_id"], name: "index_invoices_on_payment_method_id", using: :btree

  create_table "payment_methods", force: :cascade do |t|
    t.string   "name",             limit: 255,                   null: false
    t.text     "note_for_invoice", limit: 65535
    t.boolean  "default",                        default: false, null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string   "txn_id",            limit: 19,                          null: false
    t.string   "business",          limit: 127,                         null: false
    t.string   "receiver_email",    limit: 127,                         null: false
    t.string   "receiver_id",       limit: 13,                          null: false
    t.string   "residence_country", limit: 2
    t.integer  "user_id",           limit: 4,                           null: false
    t.string   "payer_id",          limit: 13,                          null: false
    t.string   "payer_email",       limit: 127,                         null: false
    t.string   "payer_status",      limit: 10,                          null: false
    t.string   "last_name",         limit: 64
    t.string   "first_name",        limit: 64
    t.datetime "payment_date",                                          null: false
    t.string   "payment_status",    limit: 25,                          null: false
    t.string   "payment_type",      limit: 7,                           null: false
    t.string   "txn_type",          limit: 50,                          null: false
    t.decimal  "mc_gross",                      precision: 5, scale: 2, null: false
    t.decimal  "tax",                           precision: 5, scale: 2, null: false
    t.decimal  "mc_fee",                        precision: 5, scale: 2, null: false
    t.integer  "quantity",          limit: 4,                           null: false
    t.integer  "plan_id",           limit: 4,                           null: false
    t.string   "mc_currency",       limit: 5,                           null: false
    t.string   "charset",           limit: 255
    t.string   "notify_version",    limit: 25
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.datetime "processed_at"
  end

  add_index "payments", ["payment_status"], name: "index_payments_on_payment_status", using: :btree
  add_index "payments", ["plan_id"], name: "index_payments_on_plan_id", using: :btree
  add_index "payments", ["txn_id"], name: "index_payments_on_txn_id", using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "description", limit: 255
    t.decimal  "price",                   precision: 7, scale: 2, null: false
    t.integer  "months",      limit: 4,                           null: false
    t.integer  "vat_rate",    limit: 4,                           null: false
    t.boolean  "is_active",                                       null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
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
    t.string   "code",        limit: 255,                                        null: false
    t.string   "description", limit: 255,                                        null: false
    t.integer  "vat_id",      limit: 4,                                          null: false
    t.integer  "unit_id",     limit: 4,                                          null: false
    t.decimal  "price",                   precision: 7, scale: 2,                null: false
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.boolean  "active",                                          default: true
  end

  add_index "services", ["code"], name: "index_services_on_code", using: :btree
  add_index "services", ["unit_id"], name: "index_services_on_unit_id", using: :btree
  add_index "services", ["vat_id"], name: "index_services_on_vat_id", using: :btree

  create_table "setting_keys", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "data_type",  limit: 4,   null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "setting_keys", ["name"], name: "index_setting_keys_on_name", using: :btree

  create_table "setting_values", force: :cascade do |t|
    t.integer  "value_i",        limit: 4
    t.string   "value_s",        limit: 255
    t.boolean  "value_b"
    t.date     "value_d"
    t.integer  "setting_key_id", limit: 4
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "setting_values", ["setting_key_id"], name: "index_setting_values_on_setting_key_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 4096
    t.integer  "project_id",  limit: 4,                null: false
    t.date     "finish_date"
    t.date     "dead_line"
    t.integer  "priority",    limit: 4,    default: 1, null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "tasks", ["project_id"], name: "index_tasks_on_project_id", using: :btree

  create_table "time_logs", force: :cascade do |t|
    t.string   "description",       limit: 255, null: false
    t.date     "date",                          null: false
    t.integer  "time_spent",        limit: 4,   null: false
    t.integer  "task_id",           limit: 4,   null: false
    t.integer  "service_id",        limit: 4,   null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "invoice_detail_id", limit: 4
  end

  add_index "time_logs", ["invoice_detail_id"], name: "index_time_logs_on_invoice_detail_id", using: :btree
  add_index "time_logs", ["service_id"], name: "index_time_logs_on_service_id", using: :btree
  add_index "time_logs", ["task_id"], name: "index_time_logs_on_task_id", using: :btree

  create_table "units", force: :cascade do |t|
    t.string   "label_short", limit: 255, null: false
    t.string   "label_long",  limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "units", ["label_short"], name: "index_units_on_label_short", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "tenant",                 limit: 255
    t.string   "tax_id",                 limit: 255
    t.string   "name",                   limit: 255
    t.string   "address",                limit: 255
    t.string   "city",                   limit: 255
    t.string   "postal_code",            limit: 255
    t.string   "state",                  limit: 255
    t.string   "country",                limit: 255
    t.string   "locale",                 limit: 255
    t.string   "phone_number",           limit: 255
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.integer  "role_id",                limit: 4
    t.date     "valid_until"
    t.boolean  "banned",                             default: false, null: false
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "currency",               limit: 3,   default: "EUR", null: false
    t.string   "authentication_token",   limit: 30
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.string   "logo_file_name",         limit: 255
    t.string   "logo_content_type",      limit: 255
    t.integer  "logo_file_size",         limit: 4
    t.datetime "logo_updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["role_id"], name: "fk_rails_642f17018b", using: :btree

  create_table "vats", force: :cascade do |t|
    t.string   "label",      limit: 255,                 null: false
    t.integer  "rate",       limit: 4,                   null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "default",                default: false
  end

  add_index "vats", ["label"], name: "index_vats_on_label", using: :btree
  add_index "vats", ["rate"], name: "index_vats_on_rate", using: :btree

  add_foreign_key "delivery_note_details", "delivery_notes"
  add_foreign_key "delivery_note_details", "invoice_details"
  add_foreign_key "delivery_note_details", "services"
  add_foreign_key "delivery_notes", "customers"
  add_foreign_key "estimate_details", "estimates"
  add_foreign_key "estimate_details", "invoice_details"
  add_foreign_key "estimate_details", "services"
  add_foreign_key "estimates", "customers"
  add_foreign_key "invoice_details", "invoices"
  add_foreign_key "invoice_details", "services"
  add_foreign_key "invoices", "customers"
  add_foreign_key "invoices", "payment_methods"
  add_foreign_key "payments", "plans"
  add_foreign_key "payments", "users"
  add_foreign_key "setting_values", "setting_keys"
  add_foreign_key "tasks", "projects"
  add_foreign_key "time_logs", "services"
  add_foreign_key "time_logs", "tasks"
  add_foreign_key "users", "roles"
end
