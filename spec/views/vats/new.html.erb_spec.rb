require 'rails_helper'

RSpec.describe 'vats/new', type: :view do
  let(:user) { create(:user) }
  let(:vat) { Vat.new }

  before(:each) do
    sign_in user
    assign(:vat, vat)
  end

  after(:each) do
    sign_out user
  end

  it 'renders new vat form' do
    render

    assert_select 'form[action=?][method=?]', user_vats_path(user), 'post' do
      assert_select 'input#vat_label[name=?]', 'vat[label]'
      assert_select 'input#vat_rate[name=?]', 'vat[rate]'
    end
  end
end
