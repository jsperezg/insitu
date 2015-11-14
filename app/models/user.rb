class User < ActiveRecord::Base
  include Settings

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   belongs_to :role

   after_commit :init_tenant, on: :create
   after_commit :initialize_settings, on: :create
   after_commit :destroy_tenant, on: :destroy

  private

  def init_tenant
   unless Rails.env.test?
     self[:tenant] = "user_#{ self[:id] }"
     save

     Apartment::Tenant.create(self[:tenant])
   end
  end

  def destroy_tenant
   unless Rails.env.test?
     Apartment::Tenant.drop(self[:tenant])
   end
  end

  def initialize_settings
    begin
      Apartment::Tenant.switch! self[:tenant]

      init_default_settings_for(self)
    ensure
      Apartment::Tenant.switch! Thread.current[:user].tenant
    end
  end
end
