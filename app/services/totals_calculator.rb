# frozen_string_literal: true

# Calculate totals for the given user
class TotalsCalculator
  attr_reader :user

  def self.for(user)
    new(user).totals
  end

  def initialize(user)
    @user = user
  end

  def totals
    {
      past_year: calculate_period_totals(past_year_interval),
      current_year: calculate_period_totals(current_year_interval),
      current_month: calculate_period_totals(current_month_interval),
      last_year: calculate_period_totals(last_year_interval)
    }
  end

  private

  def past_year_interval
    (Date.today - 1.year).beginning_of_year..(Date.today - 1.year).end_of_year
  end

  def current_year_interval
    Date.today.beginning_of_year..Date.today.end_of_year
  end

  def current_month_interval
    Date.today.beginning_of_month..Date.today.end_of_month
  end

  def last_year_interval
    (Time.now - 12.months).beginning_of_day..Time.now
  end

  def calculate_period_totals(interval)
    result = {
      vat: ::Dashboard::VatTotals.for_interval(interval),
      totals: {
        net: Dashboard::NetTotals.for_interval(interval),
        discounts: Dashboard::DiscountTotals.for_interval(interval),
        services: Dashboard::ServiceTotals.for_interval(interval),
        customers: Dashboard::CustomerTotals.for_interval(interval)
      }
    }

    result[:totals][:tax] = Dashboard::TaxTotals.for_interval(interval) if user.show_irpf?

    result
  end
end
