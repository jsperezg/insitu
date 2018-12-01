# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :txn_id, limit: 19, null: false, index: true

      t.string :business, limit: 127, null: false
      t.string :receiver_email, limit: 127, null: false
      t.string :receiver_id, limit: 13, null: false
      t.string :residence_country, limit: 2

      t.references :user, index: true, foreign_key: true, null: false
      t.string :payer_id, limit: 13, null: false
      t.string :payer_email, limit: 127, null: false
      t.string :payer_status, limit: 10, null: false
      t.string :last_name, limit: 64
      t.string :first_name, limit: 64

      t.datetime :payment_date, null: false
      t.string :payment_status, limit: 25, null: false, index: true
      t.string :payment_type, limit: 7, null: false
      t.string :txn_type, limit: 50, null: false

      t.decimal :mc_gross, precision: 5, scale: 2, null: false
      t.decimal :tax, precision: 5, scale: 2, null: false
      t.decimal :mc_fee, precision: 5, scale: 2, null: false

      t.integer :quantity, null: false
      t.references :plan,  index: true, foreign_key: true, null: false
      t.string :mc_currency, limit: 5, null: false

      t.string :charset
      t.string :notify_version, limit: 25

      # https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNandPDTVariables/
      # {
      # "txn_id"=>"1KW388315P8523947",

      # "business"=>"jsperezg_facilitator@gmail.com",
      # "receiver_email"=>"jsperezg_facilitator@gmail.com",
      # "receiver_id"=>"RYG2VVDDN76XA",
      # "residence_country"=>"ES",

      # "custom"=>"2",
      # "payer_id"=>"2E8UEHL748ALL",
      # "payer_email"=>"jsperezg-buyer@gmail.com",
      # "payer_status"=>"verified",
      # "last_name"=>"buyer",
      # "first_name"=>"test",

      # "payment_date"=>"02:24:10 May 08, 2016 PDT",
      # "payment_status"=>"Completed",
      # "payment_type"=>"instant",
      # "txn_type"=>"web_accept",

      # "mc_gross"=>"6.05",
      # "tax"=>"1.05",
      # "mc_fee"=>"0.56",

      # "quantity"=>"1",
      # "item_name"=>"Renovar por 1 mes",
      # "mc_currency"=>"EUR",
      # "item_number"=>"1",

      # "charset"=>"windows-1252",
      # "notify_version"=>"3.8",

      # "test_ipn"=>"1",
      # "ipn_track_id"=>"36de2a4bc2691"
      # "transaction_subject"=>"",
      # "payment_fee"=>"",
      # "verify_sign"=>"AcFHC8-bPIDZ88ii3yYZm66tFJ6VAN2wnIFytDXpt8OuR7yjaGKUekws",
      # "protection_eligibility"=>"Ineligible",
      # "handling_amount"=>"0.00",
      # "shipping"=>"0.00",
      # "payment_gross"=>"",
      # }

      t.timestamps null: false
    end
  end
end
