require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'name is mandatory' do
    task = Task.new
    task.save
    expect(task.errors).to satisfy { |errors| errors.key? :name }
  end

  it 'Project is mandatory' do
    task = Task.new
    task.save
    expect(task.errors).to satisfy { |errors| errors.key? :project_id }
  end

  it 'Priority defaults to 1' do
    task = Task.new
    task.save
    expect(task.errors).not_to satisfy { |errors| errors.key? :priority }
    expect(task.priority).to be(1)
  end

  it 'Priority only accepts numbers' do
    task = Task.new(priority: 'asdf')
    task.save
    expect(task.errors).to satisfy { |errors| errors.key? :priority }
  end

  it 'Priority only accepts integers' do
    task = Task.new(priority: 1.2)
    task.save
    expect(task.errors).to satisfy { |errors| errors.key? :priority }
  end

  it 'Priority must be within range 1 to 5' do
    task = Task.new(priority: 6)
    task.save
    expect(task.errors).to satisfy { |errors| errors.key? :priority }
  end

  it 'expired user cant save delivery notes' do
    Thread.current[:user] = create(:expired_user)
    object = Task.new
    object.save

    expect(object.errors).to satisfy { |errors| !errors.empty? && errors.key?( :base )}
    expect(object.errors[:base]).to include(I18n.t('activerecord.errors.messages.subscription_expired'))
  end
end
