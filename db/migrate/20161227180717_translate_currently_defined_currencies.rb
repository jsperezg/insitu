# frozen_string_literal: true

class TranslateCurrentlyDefinedCurrencies < ActiveRecord::Migration
  def change
    User.all.each do |user|
      if user.currency == '$'
        user.currency = 'USD'
      else
        currencies = ISO4217::Currency.list_from_symbol(user.currency)
        user.currency = currencies.first[1].code unless currencies.empty?
      end

      user.save
    end
  end
end
