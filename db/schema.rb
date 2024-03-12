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

ActiveRecord::Schema.define(version: 2017_12_28_083540) do

  create_table "customers", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "send_invoices_to"
  end

  create_table "delivery_note_details", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "delivery_note_id", null: false
    t.integer "service_id"
    t.decimal "quantity", precision: 7, scale: 2, null: false
    t.decimal "price", precision: 7, scale: 2, null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invoice_detail_id"
    t.index ["delivery_note_id"], name: "index_delivery_note_details_on_delivery_note_id"
    t.index ["invoice_detail_id"], name: "index_delivery_note_details_on_invoice_detail_id"
    t.index ["service_id"], name: "index_delivery_note_details_on_service_id"
  end

  create_table "delivery_notes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "number", null: false
    t.integer "customer_id", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_delivery_notes_on_customer_id"
    t.index ["number"], name: "index_delivery_notes_on_number"
  end

  create_table "estimate_details", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "estimate_id", null: false
    t.integer "service_id"
    t.string "description"
    t.decimal "quantity", precision: 7, scale: 2, null: false
    t.decimal "price", precision: 7, scale: 2, null: false
    t.integer "discount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invoice_detail_id"
    t.index ["estimate_id"], name: "index_estimate_details_on_estimate_id"
    t.index ["invoice_detail_id"], name: "index_estimate_details_on_invoice_detail_id"
    t.index ["service_id"], name: "index_estimate_details_on_service_id"
  end

  create_table "estimate_statuses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "estimates", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "number", null: false
    t.integer "customer_id", null: false
    t.integer "estimate_status_id", null: false
    t.date "date", null: false
    t.date "valid_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_estimates_on_customer_id"
    t.index ["estimate_status_id"], name: "index_estimates_on_estimate_status_id"
    t.index ["number"], name: "index_estimates_on_number"
  end

  create_table "invoice_details", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "invoice_id", null: false
    t.integer "service_id"
    t.string "description"
    t.integer "vat_rate", null: false
    t.decimal "price", precision: 7, scale: 2, null: false
    t.decimal "quantity", precision: 7, scale: 2, null: false
    t.integer "discount", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_details_on_invoice_id"
    t.index ["service_id"], name: "index_invoice_details_on_service_id"
  end

  create_table "invoice_statuses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "number", null: false
    t.date "date", null: false
    t.integer "payment_method_id"
    t.integer "customer_id", null: false
    t.integer "invoice_status_id", null: false
    t.date "payment_date"
    t.date "paid_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "irpf"
    t.integer "amended_invoice_id"
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
    t.index ["invoice_status_id"], name: "index_invoices_on_invoice_status_id"
    t.index ["number"], name: "index_invoices_on_number"
    t.index ["payment_method_id"], name: "index_invoices_on_payment_method_id"
  end

  create_table "payment_methods", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.text "note_for_invoice"
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "txn_id", limit: 19, null: false
    t.string "business", limit: 127, null: false
    t.string "receiver_email", limit: 127, null: false
    t.string "receiver_id", limit: 13, null: false
    t.string "residence_country", limit: 2
    t.integer "user_id", null: false
    t.string "payer_id", limit: 13, null: false
    t.string "payer_email", limit: 127, null: false
    t.string "payer_status", limit: 10, null: false
    t.string "last_name", limit: 64
    t.string "first_name", limit: 64
    t.datetime "payment_date", null: false
    t.string "payment_status", limit: 25, null: false
    t.string "payment_type", limit: 7, null: false
    t.string "txn_type", limit: 50, null: false
    t.decimal "mc_gross", precision: 5, scale: 2, null: false
    t.decimal "tax", precision: 5, scale: 2, null: false
    t.decimal "mc_fee", precision: 5, scale: 2, null: false
    t.integer "quantity", null: false
    t.integer "plan_id", null: false
    t.string "mc_currency", limit: 5, null: false
    t.string "charset"
    t.string "notify_version", limit: 25
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "processed_at"
    t.index ["payment_status"], name: "index_payments_on_payment_status"
    t.index ["plan_id"], name: "index_payments_on_plan_id"
    t.index ["txn_id"], name: "index_payments_on_txn_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "plans", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description"
    t.decimal "price", precision: 7, scale: 2, null: false
    t.integer "months", null: false
    t.integer "vat_rate", null: false
    t.boolean "is_active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_statuses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "project_status_id", null: false
    t.integer "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_projects_on_customer_id"
    t.index ["project_status_id"], name: "index_projects_on_project_status_id"
  end

  create_table "roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_roles_on_description"
  end

  create_table "services", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.integer "vat_id", null: false
    t.integer "unit_id", null: false
    t.decimal "price", precision: 7, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["code"], name: "index_services_on_code"
    t.index ["unit_id"], name: "index_services_on_unit_id"
    t.index ["vat_id"], name: "index_services_on_vat_id"
  end

  create_table "setting_keys", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.integer "data_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_setting_keys_on_name"
  end

  create_table "setting_values", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "value_i"
    t.string "value_s"
    t.boolean "value_b"
    t.date "value_d"
    t.integer "setting_key_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_key_id"], name: "index_setting_values_on_setting_key_id"
  end

  create_table "tasks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description", limit: 4096
    t.integer "project_id", null: false
    t.date "finish_date"
    t.date "dead_line"
    t.integer "priority", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_tasks_on_project_id"
  end

  create_table "time_logs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "description", null: false
    t.date "date", null: false
    t.integer "time_spent", null: false
    t.integer "task_id", null: false
    t.integer "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "invoice_detail_id"
    t.index ["invoice_detail_id"], name: "index_time_logs_on_invoice_detail_id"
    t.index ["service_id"], name: "index_time_logs_on_service_id"
    t.index ["task_id"], name: "index_time_logs_on_task_id"
  end

  create_table "units", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "label_short", null: false
    t.string "label_long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label_short"], name: "index_units_on_label_short"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role_id"
    t.date "valid_until"
    t.boolean "banned", default: false, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "currency", limit: 3, default: "EUR", null: false
    t.string "authentication_token", limit: 30
    t.string "provider"
    t.string "uid"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.bigint "logo_file_size"
    t.datetime "logo_updated_at"
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "fk_rails_642f17018b"
  end

  create_table "vats", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "rate", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default", default: false
    t.index ["rate"], name: "index_vats_on_rate"
  end

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
