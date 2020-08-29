# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'estimates/edit', type: :view do
  let(:user) { create :user }
  let(:estimate) { create :estimate }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:estimate, estimate)
  end

  after do
    sign_out user
  end

  it 'renders the edit estimate form' do
    render

    assert_select 'form[action=?][method=?]', user_estimate_path(user, estimate), 'post' do
    end
  end
end
