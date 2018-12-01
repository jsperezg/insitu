# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'units/new', type: :view do
  let(:user) { create :user }

  before do
    sign_in user

    Thread.current[:user] = user

    assign(:unit, Unit.new)
  end

  after do
    sign_out user
  end

  it 'renders new unit form' do
    render

    assert_select 'form[action=?][method=?]', user_units_path(user), 'post' do
    end
  end
end
