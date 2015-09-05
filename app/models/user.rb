class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   belongs_to :role

   after_commit :init_tenant, on: :create
   after_commit :destroy_tenant, on: :destroy

  #  def after_database_authentication
  #    byebug
  #    Apartment::Tenant.switch! self[:tenant]
  #  end

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
end
