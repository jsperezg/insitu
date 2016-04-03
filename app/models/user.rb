class User < ActiveRecord::Base
  filterrific(
      default_filter_params: {
          sorted_by: 'valid_until_asc'
      },
      available_filters: [
          :with_filter_criteria,
          :with_active_criteria,
          :sorted_by
      ]
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  def self.options_for_sorted_by
    [
        [ "#{ Service.human_attribute_name(:valid_until) } (#{I18n.t('filterrific.sort_alpha_asc')})", 'valid_until_asc'],
        [ "#{ Service.human_attribute_name(:valid_until) } (#{I18n.t('filterrific.sort_alpha_desc')})", 'valid_until_desc']
    ]
  end

  def self.active_filter_options
    [
        [I18n.t('users.only_active'), '1'],
        [I18n.t('users.vip'), '0'],
        [I18n.t('users.only_inactive'), '2']
    ]
  end

  scope :with_filter_criteria, lambda { |filter|
    where('email like :filter', filter: "%#{filter}%")
  }

  scope :with_active_criteria, lambda { |filter |
    case filter
      when 0 then where(valid_until: nil)
      when 2 then where('valid_until < ?', Date.today)
      when 1 then where('valid_until >= ? or valid_until is null', Date.today)
    end
  }

  scope :sorted_by, lambda { |sort_by|
    case sort_by
      when 'valid_until_asc'
        order(valid_until: :asc)

      when 'valid_until_desc'
        order(valid_until: :desc)

      else
        order(email: :asc)
    end
  }

  validates :email, presence: true
  validates :encrypted_password, presence: true

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

  def is_active?
    self.valid_until.nil? || self.valid_until >= Date.today
  end

  def has_expired?
    self.valid_until < Date.today?
  end

  def is_about_to_expire?
    self.valid_until >= Date.today && self.valid_until - 7.days <= Date.today
  end

  private

  def init_role
    self[:role_id] = Role.find_by(description: 'User').try(:id) if self[:role_id].nil?
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
