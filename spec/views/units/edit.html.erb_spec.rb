# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'units/edit', type: :view do
  let(:user) { create :user }
  let(:unit) { create :unit }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:unit, unit)
  end

  after do
    sign_out user
  end

  it 'renders the edit unit form' do
    render

    assert_select 'form[action=?][method=?]', user_unit_path(user, unit), 'post' do
    end
  end
end
