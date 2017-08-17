# frozen_string_literal: true

# Class that represents the invoice status
class InvoiceStatus < ActiveRecord::Base
  validates :name, presence: true
  has_many :invoices

  def locale_name
    I18n.t(name)
  end

  def self.paid
    InvoiceStatus.find_by(name: 'invoice_status.paid')
  end

  def self.default
    InvoiceStatus.find_by(name: 'invoice_status.default')
  end

  def self.created
    InvoiceStatus.find_by(name: 'invoice_status.created')
  end

  def self.sent
    InvoiceStatus.find_by(name: 'invoice_status.sent')
  end
end
