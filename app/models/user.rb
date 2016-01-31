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

  private

  def init_role
    self[:role_id] = Role.find_by(description: 'Usuario').try(:id) if self[:role_id].nil?
  end

  def init_tenant_name
    if self[:tenant].blank?
      self[:tenant] = "user_#{ self[:id] }"
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
