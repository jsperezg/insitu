# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'services/show', type: :view do
  let(:user) { create :user }

  before do
    sign_in user

    Thread.current[:user] = user

    @service = assign(:service, create(:service))
  end

  after do
    sign_out user
  end

  it 'renders attributes in <p>' do
    render
  end
end
