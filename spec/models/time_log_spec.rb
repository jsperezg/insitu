require 'rails_helper'

RSpec.describe TimeLog, type: :model do
  it 'description is mandatory' do
    time_log = TimeLog.new
    time_log.save

    expect(time_log.errors).to satisfy { |errors| !errors.empty? && errors.key?( :description )}
  end

  it 'start_time is mandatory' do
    time_log = TimeLog.new
    time_log.save

    expect(time_log.errors).to satisfy { |errors| !errors.empty? && errors.key?( :start_time )}
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

  it 'start time is before end time' do
    time_log = TimeLog.new(start_time: DateTime.now.utc, end_time: DateTime.now.utc - 2.hours)
    time_log.save

    expect(time_log.errors).to satisfy { |errors| !errors.empty? && errors.key?( :start_time )}
  end
end
