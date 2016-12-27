class TranslateCurrentlyDefinedCurrencies < ActiveRecord::Migration
  def change
    User.all.each do |user|
      if user.currency == '$'
        user.currency = 'USD'
      else
        currencies = ISO4217::Currency.list_from_symbol(user.currency)
        unless currencies.empty?
          user.currency = currencies.first[1].code
        end
      end

      user.save
    end
  end
end
