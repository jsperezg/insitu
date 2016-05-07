class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :txn_id, limit: 19, null: false, index: true
      t.string :receiver_email, limit: 127, null: false
      t.string :payment_status, limit: 25, null: false, index: true
      t.string :pending_reason, limit: 25
      t.string :reason_code, limit: 25
      t.decimal :mc_gross
      t.string :mc_currency

      t.string :payer_email, limit: 127, null: false


      #TODO Create payment detail
      t.string :item_name1, limit: 127
      t.string :item_number1, limit: 127
      t.integer :fraud_management_pending_filters_1
      t.decimal :mc_gross_1


      # https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNandPDTVariables/

      t.timestamps null: false

    end
  end
end
