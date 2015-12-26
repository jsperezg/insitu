require 'rails_helper'

RSpec.describe TimeLog, type: :model do
  it 'description is mandatory' do
    time_log = TimeLog.new
    time_log.save

    expect(time_log.errors).to satisfy { |errors| !errors.empty? && errors.key?( :description )}
  end

  it 'time_spent is mandatory' do
    time_log = TimeLog.new
    time_log.save

    expect(time_log.errors).to satisfy { |errors| errors.key? :time_spent }
  end

  it 'time_spent is a number' do
    time_log = TimeLog.new(time_spent: 'asdf')
    time_log.save

    expect(time_log.errors).to satisfy { |errors| errors.key? :time_spent }
  end

  it 'time_spent is a integer' do
    time_log = TimeLog.new(time_spent: 1.2)
    time_log.save

    expect(time_log.errors).to satisfy { |errors| errors.key? :time_spent }
  end

  it 'time_spent is greater than zero' do
    time_log = TimeLog.new(time_spent: -1)
    time_log.save

    expect(time_log.errors).to satisfy { |errors| errors.key? :time_spent }
  end

  it 'task_id is mandatory' do
    time_log = TimeLog.new
    time_log.save

    expect(time_log.errors).to satisfy { |errors| !errors.empty? && errors.key?( :task_id )}
  end

  it 'service_id is mandatory' do
    time_log = TimeLog.new
    time_log.save

    expect(time_log.errors).to satisfy { |errors| !errors.empty? && errors.key?( :service_id )}
  end

  it 'date is mandatory' do
    time_log = TimeLog.new
    time_log.save

    expect(time_log.errors).to satisfy { |errors| errors.key? :date }
  end
end
