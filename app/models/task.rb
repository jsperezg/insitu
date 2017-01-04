class Task < ActiveRecord::Base
  include ApartmentCacheKeyGenerator

  belongs_to :project

  has_many :time_logs, dependent: :destroy

  validates :name, presence: true
  validates :project_id, presence: true
  validates :priority, numericality: { only_integer: true }, inclusion: { in: 1..5 }

  after_initialize :set_default_values
  before_validation :set_default_values

  accepts_nested_attributes_for :time_logs, reject_if: proc { |attr|
    result = true

    [:description, :time_spent, :date].each do |attr_id|
      result = false unless attr[attr_id].blank?
    end

    result
  }, :allow_destroy => true

  def self.retrieve_project_tasks(project_id)
    Task.includes(:project).where(project_id: project_id)
  end

  def self.retrieve_finished_tasks(project_id)
    self.retrieve_project_tasks(project_id).where.not(finish_date: :nil)
  end

  def invoice_timelogs_into(invoice)
    time_logs = TimeLog.where(task_id: self.id, invoice_detail_id: nil)
    time_logs.each do |time_log|
      invoice_detail = InvoiceDetail.create!(
          invoice_id: invoice.id,
          service_id: time_log.service_id,
          vat_rate: time_log.service.vat.rate,
          price: time_log.service.price,
          discount: 0,
          description: time_log.description,
          quantity: time_log.time_spent / 60
      )

      time_log.invoice_detail_id = invoice_detail.id
      time_log.save!
    end
  end

  private

  def set_default_values
    self.priority ||= 1
  end
end
