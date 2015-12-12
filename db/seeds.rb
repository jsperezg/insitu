include Settings

config = Rails.configuration.database_configuration

if Apartment::Tenant.current_tenant.blank? or Apartment::Tenant.current_tenant == config[Rails.env]["database"]
  ['project_status.active', 'project_status.suspended', 'project_status.cancelled', 'project_status.closed'].each do |state|
      ProjectStatus.find_by(name: state) || ProjectStatus.create(name: state)
  end

  ['invoice_status.created', 'invoice_status.planed', 'invoice_status.sent'].each do |status|
    InvoiceStatus.find_by(name: status) || InvoiceStatus.create(name: status)
  end

  %w(Administrador Usuario).each do |role|
    Role.find_by(description: role) || Role.create(description: role)
  end

  admin = User.find_by(email: 'jsperezg@gmail.com')
  if admin.nil?
    admin = User.create(:email => 'jsperezg@gmail.com', :password => 'change_me', :password_confirmation => 'change_me')
  end

  admin_role = Role.find_by(description: 'Administrador')
  unless admin_role.nil?
    admin.role = admin_role
    admin.save!
  end
else
  user = User.find_by(tenant: Apartment::Tenant.current_tenant)
  unless user.nil?
    init_default_settings_for(user)
  end

  [
    {label_short: 'H', label_long:  'Horas'},
    {label_short: 'UDS', label_long: 'Unidades'}
  ].each do |unit|
      Unit.find_by(label_short: unit[:label_short]) || Unit.create(unit)
  end

  [
    { label: '0%', rate: 0 },
    { label: '4%', rate: 4 },
    { label: '10%', rate: 10 },
    { label: '21%', rate: 21 }
  ].each do |vat|
    Vat.find_by(rate: vat[:rate]) || Vat.create(vat)
  end
end
