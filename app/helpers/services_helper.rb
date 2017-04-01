module ServicesHelper
  def service_options
    options_for_select(
        Service.order(description: :asc).map { |service| [ service.description, service.id ] },
        disabled: Service.where(active: false).map(&:id) # { |service| service.id }
    )
  end
end
