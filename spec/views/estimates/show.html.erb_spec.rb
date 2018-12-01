# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'estimates/show', type: :view do
  let(:user) { create :user }

  before do
    sign_in user

    Thread.current[:user] = user

    @estimate = assign(:estimate, create(:estimate))
  end

  after do
    sign_out user
  end

  it 'renders attributes in <p>' do
    render
  end
end
