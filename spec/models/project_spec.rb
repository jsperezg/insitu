require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'name is mandatory' do
    project = Project.new
    project.save

    expect(project.errors).to satisfy { |errors| !errors.empty? && errors.key?( :name )}
  end

  it 'status is mandatory' do
    project = Project.new
    project.save

    expect(project.errors).to satisfy { |errors| !errors.empty? && errors.key?( :project_status_id )}
  end

  it 'customer is mandatory' do
    project = Project.new
    project.save

    expect(project.errors).to satisfy { |errors| !errors.empty? && errors.key?( :customer_id )}
  end
end
