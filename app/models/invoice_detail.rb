class InvoiceDetail < ActiveRecord::Base
  belongs_to :invoice, touch: true
  belongs_to :service
  has_one :time_log, dependent: :nullify
  has_one :estimate_detail, dependent: :nullify
  has_one :delivery_note_detail, dependent: :nullify

  validates :vat_rate, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :discount, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }

  after_initialize :set_default_values, if: :new_record?

  def subtotal
    if price.present? && quantity.present?
      price * quantity
    end
  end

  def applied_discount
    if price.present? && quantity.present? && discount.present?
      discount / 100.0 * subtotal
    end
  end

  def tax
    if price.present? && quantity.present? && discount.present? && vat_rate.present?
      ( 1 - (discount / 100.0)) * price * quantity * ( vat_rate / 100.0)
    end
  end

  def total
    if price.present? && quantity.present? && discount.present? && vat_rate.present?
	    ( 1 - (discount / 100.0)) * price * quantity * ( 1 + (vat_rate / 100.0))
    end
  end

  def self.calculate_totals_for(user)
    result = {
      past_year: InvoiceDetail.calculate_period_totals(user, (DateTime.now - 1.year).beginning_of_year..(DateTime.now - 1.year).end_of_year),
      current_year: InvoiceDetail.calculate_period_totals(user, DateTime.now.beginning_of_year..DateTime.now.end_of_year),
      current_month: InvoiceDetail.calculate_period_totals(user, DateTime.now.beginning_of_month..DateTime.now.end_of_month),
      last_year: InvoiceDetail.calculate_period_totals(user, (DateTime.now - 12.months)..DateTime.now)
    }

    result
  end

  def self.calculate_period_totals(user,interval)
    result = {}

    result[:net] = InvoiceDetail
                       .includes(:invoice)
                       .where('invoices.date': interval)
                       .sum('(1 - discount / 100) * price * quantity')

    result[:discounts] = InvoiceDetail
                             .includes(:invoice)
                             .where('invoices.date': interval)
                             .sum('(discount / 100) * price * quantity')

    result[:tax] = InvoiceDetail
                       .includes(invoice: [ :customer ])
                       .where('invoices.date': interval)
                       .where.not('customers.irpf': nil)
                       .sum('(1 - discount / 100) * price * quantity * (customers.irpf / 100)') unless user.has_cif?

    result[:vat] = InvoiceDetail
                       .includes(:invoice)
                       .where('invoices.date': interval)
                       .where.not(vat_rate: 0)
                       .group(:vat_rate)
                       .sum('(1 - discount / 100) * price * quantity * (vat_rate / 100)')

    customers = InvoiceDetail
                    .includes(invoice: [ :customer ])
                    .where('invoices.date': interval)
                    .group('customers.name')
                    .sum('(1 - discount / 100) * price * quantity')
    result[:customers] = customers.select { |t| customers[t] >= 3000 }

    result
  end

  private

  def set_default_values
    self.vat_rate = Vat.find_by(default: true).try(:rate) if self.vat_rate.nil?
  end
end
