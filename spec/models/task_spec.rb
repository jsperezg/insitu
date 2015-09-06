require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'description is mandatory' do
    task = Task.new
    task.save
    expect(task.errors).to satisfy { |errors| !errors.empty? && errors.key?( :description )}
  end

  it 'Project is mandatory' do
    task = Task.new
    task.save
    expect(task.errors).to satisfy { |errors| !errors.empty? && errors.key?( :project_id )}
  end
end
