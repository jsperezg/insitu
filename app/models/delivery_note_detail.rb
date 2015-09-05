class DeliveryNoteDetail < ActiveRecord::Base
  belongs_to :delivery_note
  belongs_to :service
end
