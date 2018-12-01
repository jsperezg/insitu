# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'vats/edit', type: :view do
  let(:user) { create(:user) }
  let(:vat) { Vat.first || create(:vat) }

  before do
    sign_in user
    assign(:vat, vat)
  end

  after do
    sign_out user
  end

  it 'renders the edit vat form' do
    render

    assert_select 'form[action=?][method=?]', user_vat_path(user, vat), 'post' do
      assert_select 'input#vat_rate[name=?]', 'vat[rate]'
    end
  end
end
