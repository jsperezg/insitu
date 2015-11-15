class AddCustomDescriptionDeliveryNoteDetail < ActiveRecord::Migration
  def change
  	change_table :delivery_note_details do |t|
  		t.string :custom_description
	end
  end
end
