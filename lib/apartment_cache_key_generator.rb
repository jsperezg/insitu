module ApartmentCacheKeyGenerator
  def cache_key
    "#{ self.class.name }/#{ Apartment::Tenant.current }/#{ self.id }-#{ self.updated_at.try(:to_i) }"
  end
end