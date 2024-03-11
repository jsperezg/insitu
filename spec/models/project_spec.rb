# frozen_string_literal: true

require 'rails_helper'

describe Project, type: :model do
  it 'name is mandatory' do
    project = described_class.create

    expect(project.errors).to be_key :name
  end

  it 'status is mandatory' do
    project = described_class.create

    expect(project.errors).to be_key :project_status_id
  end

  it 'customer is mandatory' do
    project = described_class.create

    expect(project.errors).to be_key :customer_id
  end
end
