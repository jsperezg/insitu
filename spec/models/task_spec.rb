# frozen_string_literal: true

require 'rails_helper'

describe Task, type: :model do
  it 'name is mandatory' do
    task = described_class.new
    task.save
    expect(task.errors).to be_key :name
  end

  it 'Project is mandatory' do
    task = described_class.new
    task.save
    expect(task.errors).to be_key :project_id
  end

  it 'Priority defaults to 1' do
    task = described_class.new
    task.save
    expect(task.errors).not_to be_key :priority
    expect(task.priority).to be(1)
  end

  it 'Priority only accepts numbers' do
    task = described_class.new(priority: 'asdf')
    task.save
    expect(task.errors).to be_key :priority
  end

  it 'Priority only accepts integers' do
    task = described_class.new(priority: 1.2)
    task.save
    expect(task.errors).to be_key :priority
  end

  it 'Priority must be within range 1 to 5' do
    task = described_class.new(priority: 6)
    task.save
    expect(task.errors).to be_key :priority
  end
end
