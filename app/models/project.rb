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

  scope :with_name, lambda { |name|
    where('name like :name', { name: "%#{name}%" })
  }

  scope :with_status, lambda { |status_id|
    where(project_status_id: status_id)
  }

  scope :sorted_by, lambda { |sort_by|
    parts = sort_by.split('_')

    if parts.empty?
      order(name:  :asc)
    elsif parts[0] == 'project status'
      joins(:project_status).order("project_statuses.name #{ parts[1] }")
    else
      sort_criteria = {}
      sort_criteria[parts[0].to_sym] = parts[1].to_sym
      order(sort_criteria)
    end
  }

  belongs_to :project_status
  belongs_to :customer

  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :project_status_id, presence: true
  validates :customer_id, presence: true
end
