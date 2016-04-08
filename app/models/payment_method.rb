class PaymentMethod < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  after_save :maintain_default_flag, on: [ :create, :update ]

  private

  def maintain_default_flag
    if self.default
      PaymentMethod.where(default: true).where.not(id: self.id).update_all(default: false)
    end
  end
end
