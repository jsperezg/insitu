module ServicesHelper
  def services_select(form, method)
    form.collection_select method,
      Service.order(description: :asc), :id, :description,
      {
          disabled: lambda { |service| !service.active },
          prompt: true
      },
      {
          class: 'form-control input-sm',
          onchange: "INSITU.services.loadService('#{ user_services_path(current_user)}', this, '#{ form.object_name }')"
      }
  end

  def service_options
    options_for_select(
        Service.order(description: :asc).map { |service| [service.description, service.id ] },
        disabled: Service.where(active: false).map { |service| service.id }
    )
  end
end
