['Activo', 'Suspendido', 'Cancelado', 'Cerrado'].each do |state|
    ProjectStatus.find_by(name: state) || ProjectStatus.create(name: state)
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

%w(Administrador Usuario).each do |role|
  Role.find_by(description: role) || Role.create(description: role)
end

jsperezg = User.find_by(email: 'jsperezg@gmail.com')
if jsperezg.nil?
  jsperezg = User.new(
    email: 'jsperezg@gmail.com',
    password: 'change_me',
    role_id: Role.find_by(description: 'Administrador')
  )

  jsperezg.save!

  Apartment::Tenant.create("user_#{ jsperezg.id }")
end
