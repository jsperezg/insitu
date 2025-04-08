# frozen_string_literal: true

require 'rails_helper'

describe Customer, type: :model do
  subject(:customer) { build(:customer) }

  before do
    Thread.current[:user] = create(:user)
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.not_to validate_presence_of(:contact_email) }
  it { is_expected.to validate_numericality_of(:irpf).only_integer.is_greater_than_or_equal_to(0) }

  it { is_expected.to allow_value(nil).for(:tax_id) }
  it { is_expected.to allow_value('').for(:tax_id) }
  it { is_expected.to validate_uniqueness_of(:tax_id).case_insensitive.allow_blank }

  it { is_expected.not_to allow_value('bwaaa').for(:contact_email) }
  it { is_expected.to allow_value('user@domain.com').for(:contact_email) }
end
