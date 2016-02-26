class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :role

  before_save :init_role, on: :create
  after_save :init_tenant_name, on: :create
  after_commit :init_tenant, on: :create
  after_commit :destroy_tenant, on: :destroy

  # Available locales
  def self.available_locales
    [
        { id: 'es', description: 'Español' },
        { id: 'en', description: 'English' }
    ]
  end

  def country_name
    unless country.blank?
      value = ISO3166::Country[country]
      value.translations[I18n.locale.to_s] || value.name
    end
  end

  def can_invoice?
    self.tax_id.present? and
        self.name.present? and
        self.address.present? and
        self.postal_code.present? and
        self.country.present?
  end

  private

  def init_role
    self[:role_id] = Role.find_by(description: 'Usuario').try(:id) if self[:role_id].nil?
  end

  def init_tenant_name
    if self[:tenant].blank?
      if Rails.env.production?
        self[:tenant] = "user_#{ self[:id] }"
      else
        self[:tenant] = "user_#{ self[:id] }_#{ Rails.env }"
      end

      save!
    end  
  end

  def init_tenant
    unless Rails.env.test?
      Apartment::Tenant.create(self[:tenant])
   end
  end

  def destroy_tenant
   unless Rails.env.test?
     Apartment::Tenant.drop(self[:tenant])
   end
  end
end
