# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoiceStatus, type: :model do
  subject { build :invoice_status, name: name }

  let(:name) { Faker::Lorem.word }

  it { is_expected.to be_valid }

  context 'when name is blank' do
    let(:name) { nil }

    it { is_expected.not_to be_valid }
  end
end
