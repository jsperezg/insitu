module UnitsHelper
  # Units for best in place of type :select
  def bip_units_collection
    Unit.all.map { |u| [ u.id, u.label_short ] }
  end
end
