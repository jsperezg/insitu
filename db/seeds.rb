# frozen_string_literal: true

include Settings

config = Rails.configuration.database_configuration

if Apartment::Tenant.current.blank? || Apartment::Tenant.current == config[Rails.env]['database']
  %w[project_status.active project_status.suspended project_status.cancelled project_status.closed].each do |state|
    ProjectStatus.find_or_create_by(name: state)
  end

  %w[invoice_status.created invoice_status.sent invoice_status.paid invoice_status.default].each do |status|
    InvoiceStatus.find_or_create_by(name: status)
  end

  %w[estimate_status.created estimate_status.sent estimate_status.accepted estimate_status.rejected].each do |status|
    EstimateStatus.find_or_create_by(name: status)
  end

  %w[Administrator User].each do |role|
    Role.find_or_create_by(description: role)
  end

  admin = User.find_by(email: 'admin@example.org')
  admin ||= User.create(
    email: 'admin@example.org',
    password: 'change_me',
    password_confirmation: 'change_me',
    confirmed_at: Time.now,
    terms_of_service: '1',
    role: Role.admin
  )
else
  init_default_settings

  [
    { label_short: 'H', label_long: 'Hours' },
    { label_short: 'PCS', label_long: 'Pieces' }
  ].each do |unit|
    Unit.find_by(label_short: unit[:label_short]) || Unit.create(unit)
  end

  [
    { rate: 0 },
    { rate: 4 },
    { rate: 10 },
    { rate: 21, default: true }
  ].each do |vat|
    Vat.find_by(rate: vat[:rate]) || Vat.create(vat)
  end

  PaymentMethod.find_by(name: 'Cash') || PaymentMethod.create(name: 'Cash', note_for_invoice: 'Cash payment', default: true)
end
