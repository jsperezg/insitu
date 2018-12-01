# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'estimates/new', type: :view do
  let(:user) { User.first || create(:user) }

  before do
    sign_in user

    assign(:estimate, Estimate.new)
  end

  it 'renders new estimate form' do
    render

    assert_select 'form[action=?][method=?]', user_estimates_path(user), 'post' do
    end
  end
end
