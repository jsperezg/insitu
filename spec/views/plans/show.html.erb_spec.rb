# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'plans/show', type: :view do
  let(:user) { create(:user, :admin) }
  let(:plan) { create(:plan) }
  before(:each) do
    sign_in user
    assign(:plan, plan)
  end

  after(:each) do
    sign_out user
  end

  it 'renders attributes in <p>' do
    render
  end
end
