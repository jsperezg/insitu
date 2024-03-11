# frozen_string_literal: true

require 'rails_helper'

describe TimeLog, type: :model do
  it 'description is mandatory' do
    time_log = described_class.new
    time_log.save

    expect(time_log.errors).to be_key :description
  end

  it 'time_spent is mandatory' do
    time_log = described_class.new
    time_log.save

    expect(time_log.errors).to be_key :time_spent
  end

  it 'time_spent is a number' do
    time_log = described_class.new(time_spent: 'asdf')
    time_log.save

    expect(time_log.errors).to be_key :time_spent
  end

  it 'time_spent is a integer' do
    time_log = described_class.new(time_spent: 1.2)
    time_log.save

    expect(time_log.errors).to be_key :time_spent
  end

  it 'time_spent is greater than zero' do
    time_log = described_class.new(time_spent: -1)
    time_log.save

    expect(time_log.errors).to be_key :time_spent
  end

  it 'service_id is mandatory' do
    time_log = described_class.new
    time_log.save

    expect(time_log.errors).to be_key :service_id
  end

  it 'date is mandatory' do
    time_log = described_class.new
    time_log.save

    expect(time_log.errors).to be_key :date
  end
end
