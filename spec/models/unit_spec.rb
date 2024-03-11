# frozen_string_literal: true

require 'rails_helper'

describe Unit, type: :model do
  before do
    Thread.current[:user] = create(:user)
  end

  it 'short label is mandatory' do
    unit = described_class.new
    unit.save

    expect(unit.errors).to be_key :label_short
  end

  it 'short label is unique' do
    described_class.create!(label_short: 'U')

    u = described_class.create(label_short: 'U')
    u.save

    expect(u.errors).to be_key :label_short
  end
end
