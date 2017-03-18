include Settings

config = Rails.configuration.database_configuration

if Apartment::Tenant.current_tenant.blank? or Apartment::Tenant.current_tenant == config[Rails.env]['database']
  %w(project_status.active project_status.suspended project_status.cancelled project_status.closed).each do |state|
      ProjectStatus.find_by(name: state) || ProjectStatus.create(name: state)
  end

  %w(invoice_status.created invoice_status.sent invoice_status.paid invoice_status.default).each do |status|
    InvoiceStatus.find_by(name: status) || InvoiceStatus.create(name: status)
  end

  %w(estimate_status.created estimate_status.sent estimate_status.accepted estimate_status.rejected).each do |status|
    EstimateStatus.find_by(name: status) || EstimateStatus.create(name: status)
  end

  %w(Administrator User).each do |role|
    Role.find_by(description: role) || Role.create(description: role)
  end

  admin = User.find_by(email: 'jsperezg@gmail.com')
  if admin.nil?
    admin = User.create(:email => 'jsperezg@gmail.com', :password => 'change_me', :password_confirmation => 'change_me', confirmed_at: DateTime.now)
  end

  admin_role = Role.find_by(description: 'Administrator')
  unless admin_role.nil?
    admin.role = admin_role
    admin.save!
  end
else
  init_default_settings

  [
    {label_short: 'H', label_long:  'Hours'},
    {label_short: 'PCS', label_long: 'Pieces'}
  ].each do |unit|
      Unit.find_by(label_short: unit[:label_short]) || Unit.create(unit)
  end

  [
    { label: '0%', rate: 0 },
    { label: '4%', rate: 4 },
    { label: '10%', rate: 10 },
    { label: '21%', rate: 21, default: true }
  ].each do |vat|
    Vat.find_by(rate: vat[:rate]) || Vat.create(vat)
  end

  PaymentMethod.find_by(name: 'Cash') || PaymentMethod.create(name: 'Cash', note_for_invoice: 'Cash payment', default: true)
end
