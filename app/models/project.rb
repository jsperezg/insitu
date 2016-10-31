class Project < ActiveRecord::Base
  filterrific(
      default_filter_params: {
        sorted_by: 'name_asc',
        with_status: ProjectStatus.find_by(name: 'project_status.active').try(:id)
      },
      available_filters: [
        :with_name,
        :with_status,
        :sorted_by
      ]
  )

  self.per_page = DEFAULT_ITEMS_PER_PAGE

  def self.options_for_sorted_by
    [
        [I18n.t('filterrific.sort_by_name_desc'), 'name_desc'],
        [I18n.t('filterrific.sort_by_name_asc'), 'name_asc']
    ]
  end

  scope :with_name, lambda { |name|
    where('name like :name', { name: "%#{name}%" })
  }

  scope :with_status, lambda { |status_id|
    where(project_status_id: status_id)
  }

  scope :sorted_by, lambda { |sort_by|
    case sort_by
      when 'name_asc'
        order(name: :asc)

      when 'name_desc'
        order(name: :desc)

      else
        order(name: :asc)
    end
  }

  belongs_to :project_status
  belongs_to :customer

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :project_status_id, presence: true
  validates :customer_id, presence: true
end
