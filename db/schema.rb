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

ActiveRecord::Schema[7.0].define(version: 2025_03_24_161853) do
  create_table "active_storage_attachments", charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "customers", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "tax_id"
    t.string "billing_serie"
    t.integer "irpf"
    t.string "contact_name"
    t.string "contact_phone"
    t.string "contact_email"
    t.string "address"
    t.string "city"
    t.string "postal_code"
    t.string "state"
    t.string "country"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "send_invoices_to"
    t.index ["tax_id"], name: "index_customers_on_tax_id", unique: true
  end

  create_table "delivery_note_details", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "delivery_note_id", null: false
    t.integer "service_id"
    t.decimal "quantity", precision: 7, scale: 2, null: false
    t.decimal "price", precision: 7, scale: 2, null: false
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "invoice_detail_id"
    t.index ["delivery_note_id"], name: "index_delivery_note_details_on_delivery_note_id"
    t.index ["invoice_detail_id"], name: "index_delivery_note_details_on_invoice_detail_id"
    t.index ["service_id"], name: "index_delivery_note_details_on_service_id"
  end

  create_table "delivery_notes", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "number", null: false
    t.integer "customer_id", null: false
    t.date "date", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["customer_id"], name: "index_delivery_notes_on_customer_id"
    t.index ["number"], name: "index_delivery_notes_on_number", unique: true
  end

  create_table "estimate_details", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "estimate_id", null: false
    t.integer "service_id"
    t.string "description"
    t.decimal "quantity", precision: 7, scale: 2, null: false
    t.decimal "price", precision: 7, scale: 2, null: false
    t.integer "discount", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "invoice_detail_id"
    t.index ["estimate_id"], name: "index_estimate_details_on_estimate_id"
    t.index ["invoice_detail_id"], name: "index_estimate_details_on_invoice_detail_id"
    t.index ["service_id"], name: "index_estimate_details_on_service_id"
  end

  create_table "estimate_statuses", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "estimates", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "number", null: false
    t.integer "customer_id", null: false
    t.integer "estimate_status_id", null: false
    t.date "date", null: false
    t.date "valid_until"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["customer_id"], name: "index_estimates_on_customer_id"
    t.index ["estimate_status_id"], name: "index_estimates_on_estimate_status_id"
    t.index ["number"], name: "index_estimates_on_number", unique: true
  end

  create_table "invoice_details", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "invoice_id", null: false
    t.integer "service_id"
    t.string "description"
    t.integer "vat_rate", null: false
    t.decimal "price", precision: 7, scale: 2, null: false
    t.decimal "quantity", precision: 7, scale: 2, null: false
    t.integer "discount", default: 0, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["invoice_id"], name: "index_invoice_details_on_invoice_id"
    t.index ["service_id"], name: "index_invoice_details_on_service_id"
  end

  create_table "invoice_statuses", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "invoices", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "number", null: false
    t.date "date", null: false
    t.integer "payment_method_id"
    t.integer "customer_id", null: false
    t.integer "invoice_status_id", null: false
    t.date "payment_date"
    t.date "paid_on"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "irpf"
    t.integer "amended_invoice_id"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["invoice_status_id"], name: "index_invoices_on_invoice_status_id"
    t.index ["number"], name: "index_invoices_on_number", unique: true
    t.index ["payment_method_id"], name: "index_invoices_on_payment_method_id"
  end

  create_table "payment_methods", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "note_for_invoice"
    t.boolean "default", default: false, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_payment_methods_on_name", unique: true
  end

  create_table "plans", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "description"
    t.decimal "price", precision: 7, scale: 2, null: false
    t.integer "months", null: false
    t.integer "vat_rate", null: false
    t.boolean "is_active", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "project_statuses", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "projects", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "project_status_id", null: false
    t.integer "customer_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["customer_id"], name: "index_projects_on_customer_id"
    t.index ["project_status_id"], name: "index_projects_on_project_status_id"
  end

  create_table "roles", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["description"], name: "index_roles_on_description"
  end

  create_table "services", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.integer "vat_id", null: false
    t.integer "unit_id", null: false
    t.decimal "price", precision: 7, scale: 2, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "active", default: true
    t.index ["code"], name: "index_services_on_code", unique: true
    t.index ["unit_id"], name: "index_services_on_unit_id"
    t.index ["vat_id"], name: "index_services_on_vat_id"
  end

  create_table "setting_keys", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "data_type", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_setting_keys_on_name", unique: true
  end

  create_table "setting_values", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "value_i"
    t.string "value_s"
    t.boolean "value_b"
    t.date "value_d"
    t.integer "setting_key_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["setting_key_id"], name: "index_setting_values_on_setting_key_id"
  end

  create_table "tasks", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "description", limit: 4096
    t.integer "project_id", null: false
    t.date "finish_date"
    t.date "dead_line"
    t.integer "priority", default: 1, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "time_logs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "description", null: false
    t.date "date", null: false
    t.integer "time_spent", null: false
    t.integer "task_id", null: false
    t.integer "service_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "invoice_detail_id"
    t.index ["invoice_detail_id"], name: "index_time_logs_on_invoice_detail_id"
    t.index ["service_id"], name: "index_time_logs_on_service_id"
    t.index ["task_id"], name: "index_time_logs_on_task_id"
  end

  create_table "units", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "label_short", null: false
    t.string "label_long"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["label_short"], name: "index_units_on_label_short", unique: true
  end

  create_table "users", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "tenant"
    t.string "tax_id"
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "postal_code"
    t.string "state"
    t.string "country"
    t.string "locale"
    t.string "phone_number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "role_id"
    t.date "valid_until"
    t.boolean "banned", default: false, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.string "currency", limit: 3, default: "EUR", null: false
    t.string "authentication_token", limit: 30
    t.string "provider"
    t.string "uid"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "fk_rails_642f17018b"
  end

  create_table "vats", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "rate", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "default", default: false
    t.index ["rate"], name: "index_vats_on_rate", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
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
  add_foreign_key "setting_values", "setting_keys"
  add_foreign_key "tasks", "projects"
  add_foreign_key "time_logs", "services"
  add_foreign_key "time_logs", "tasks"
  add_foreign_key "users", "roles"
end
