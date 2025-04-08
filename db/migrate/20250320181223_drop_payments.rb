# frozen_string_literal: true
class DropPayments < ActiveRecord::Migration[7.0]
  def change
    drop_table :payments, if_exists: true do
      t.string :txn_id, null: false, limit: 19
      t.string :business, null: false, limit: 127
      t.string :receiver_email, null: false, limit: 127
      t.string :receiver_id, null: false, limit: 13
      t.string :residence_country, limit: 2
      t.integer :user_id, null: false
      t.string :payer_id, null: false, limit: 13
      t.string :payer_email, null: false, limit: 127
      t.string :payer_status, null: false, limit: 10
      t.string :last_name, limit: 64
      t.string :first_name, limit: 64
      t.datetime :payment_date, null: false
      t.string :payment_status, null: false, limit: 25
      t.string :payment_type, null: false, limit: 7
      t.string :txn_type, null: false, limit: 50
      t.decimal :mc_gross, null: false
      t.decimal :tax, null: false
      t.decimal :mc_fee, null: false
      t.integer :quantity, null: false
      t.integer :plan_id, null: false
      t.string :mc_currency, null: false, limit: 5
      t.string :notify_version, limit: 25
      t.timestamps
    end
  end
end
