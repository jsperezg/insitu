# frozen_string_literal: true

module CurrenciesHelper
  def currency_options
    ISO4217::Currency.currencies.collect { |c| ["#{c[1].code} #{c[1].name} (#{c[1].symbol})", c[1].code] }
  end

  def current_currency_symbol
    currency_code = current_user.try(:currency)
    currency = ISO4217::Currency.from_code(currency_code) unless currency_code.blank?
    currency.try(:symbol)
  end
end
