class Api::PlansController < ApiController
  version 1

  # The list of foods is cached for 5 minutes, the food itself is cached
  # until it's modified (using Efficient Validation)
  caches :index, :cache_for => 2.hours

  def index
    expose Plan.where(is_active: true).order(months: :asc), only: [:id, :description, :months, :vat_rate, :price, :hosted_button_id]
  end
end
